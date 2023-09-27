module dotopt(input logic clk, input logic rst_n,
           // slave (CPU-facing)
           output logic slave_waitrequest,
           input logic [3:0] slave_address,
           input logic slave_read, output logic [31:0] slave_readdata,
           input logic slave_write, input logic [31:0] slave_writedata,

           // master_* (SDRAM-facing): weights (anb biases for task7)
           input logic master_waitrequest,
           output logic [31:0] master_address,
           output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
           output logic master_write, output logic [31:0] master_writedata,

           // master2_* (SRAM-facing to bank0 and bank1): input activations (and output activations for task7)
           input logic master2_waitrequest,
           output logic [31:0] master2_address,
           output logic master2_read, input logic [31:0] master2_readdata, input logic master2_readdatavalid,
           output logic master2_write, output logic [31:0] master2_writedata);

    // your code: you may wish to start by copying code from your "dot" module, and then add control for master2_* port
    logic [31:0] start_value;
    logic [31:0] weight_base;
    logic [31:0] vector_base;
    logic [31:0] length;
    logic [31:0] counter;

    logic signed [31:0] curr_weight; // signed q16.16 value
    logic signed [31:0] curr_vector; // signed q16.16 value
    logic signed [63:0] product;     // the product of above values should be signed q32.32 value
    logic signed [31:0] sum;         // signed q16.16 value

    // less state here compared to dot.sv since now we read both the weight and the vector at the same state
    enum{reset, setup, readboth, waitboth, dotproduct, done} state;

    // at the end cpu will read data from address 0, the dotproduct result will be returned
    assign slave_readdata = (slave_read && slave_address == 4'd0) ? sum : 32'b0;

    always @(posedge clk) begin
        if (rst_n == 0)
            state <= reset;
        else begin
            case(state)
            reset: begin
                slave_waitrequest <= 1'b0; // the cpu proceeds normally, can both write and read
                master_write <= 1'b0;
                master2_write <= 1'b0;
                state <= setup;
            end

            setup: begin
                counter <= 0;
                if (slave_write) begin
                    sum <= 32'b0;       // everytime the cpu writes new values, it indicates another function call to dotproduct_hw
                    case(slave_address)
                    4'd0: begin 
                        state <= readboth; 
                        start_value <= slave_writedata; 
                        slave_waitrequest <= 1'b1;          // after writing to address 0, the cpu should stall until the dot process is done
                    end
                    4'd2: weight_base <= slave_writedata;   // put the value at base+2 into weight_base
                    4'd3: vector_base <= slave_writedata;   // put the value at base+3 into vector_base
                    4'd5: length <= slave_writedata;        // put the value at base+5 into length
                    endcase
                end
            end

            readboth: begin
                if (counter < length) begin
                    // read from SDRAM and SRAM
                    master_read <= 1'b1;
                    master2_read <= 1'b1;
                    master_address <= weight_base + counter * 4;
                    master2_address <= vector_base + counter * 4;
                    state <= waitboth;
                end
                else
                    state <= done;
            end

            waitboth: begin
                // it takes some cycles to proceed the read requests, while proceeding master_waitrequest is 1
                if (master_waitrequest == 1'b0 && master2_waitrequest == 1'b0) begin
                    // when both read are done, check readdatavalid
                    if (master_readdatavalid == 1'b1 && master2_readdatavalid == 1'b1) begin
                        master_read <= 1'b0;
                        master2_read <= 1'b0;
                        curr_weight <= master_readdata;   // read into our signed q16.16 register
                        curr_vector <= master2_readdata;  // read into our signed q16.16 register
                        state <= dotproduct;
                    end
                end
            end

            dotproduct: begin
                // this two lines use blocking assignment since we want to update the value of product then assign it to sum
                product = curr_weight * curr_vector;
                sum = sum + product[47:16]; // the sum should also be consistent with signed q16.16 format
                state <= readboth;
                counter <= counter + 1; // go to next 32-bit word
            end

            done: begin
                // accelerator is done, go to setup for next cpu request
                slave_waitrequest <= 1'b0;
                state <= setup;
            end

            endcase
        end
    end

endmodule: dotopt