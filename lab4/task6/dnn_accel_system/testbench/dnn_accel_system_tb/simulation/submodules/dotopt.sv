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

    logic signed [31:0] curr_weight;
    logic signed [31:0] curr_vector;
    logic signed [63:0] product;
    logic signed [31:0] sum;

    enum{reset, setup, read, waitread, waitread2, dotproduct, done} state;

    assign slave_readdata = (slave_read && slave_address == 4'd0) ? sum : 32'b0;

    always @(posedge clk) begin
        if (rst_n == 0)
            state <= reset;
        else begin
            case(state)
            reset: begin
                slave_waitrequest <= 1'b0;
                state <= setup;
                master_read <= 0;
                master2_read <= 0;
            end

            setup: begin
                counter <= 0;
                if (slave_write) begin
                    sum <= 32'b0;
                    case(slave_address)
                    4'd0: begin 
                        state <= read; 
                        start_value <= slave_writedata; 
                        slave_waitrequest <= 1'b1;
                    end
                    4'd2: weight_base <= slave_writedata;
                    4'd3: vector_base <= slave_writedata;
                    4'd5: length <= slave_writedata;
                    endcase
                end
            end

            read: begin
                master_write <= 1'b0;
                master2_write <= 1'b0;
                if (counter < length) begin
                    master_read <= 1'b1;
                    master_address <= weight_base + counter * 4;

                    state <= waitread;
                end
                else
                    state <= done;
            end

            waitread: begin
                if (master_waitrequest == 1'b0) begin
                    if (master_readdatavalid) begin
                        master_read <= 1'b0;
                        curr_weight <= master_readdata;
                        state <= waitread2;

                        master2_read <= 1'b1;
                        master2_address <= vector_base + counter * 4;
                    end
                end
            end

            waitread2: begin
                if (master2_waitrequest == 1'b0) begin
                    if (master2_readdatavalid) begin
                        master2_read <= 1'b0;
                        curr_vector <= master2_readdata;
                        state <= dotproduct;
                    end
                end
            end
            dotproduct: begin
                product = curr_weight * curr_vector;
                sum = sum + product[47:16];
                state <= read;
                counter <= counter + 1;
            end

            done: begin
                // if (master_waitrequest == 1'b0 && slave_write)
                //     state <= setup;
                slave_waitrequest <= 1'b0;
                state <= setup;
            end

            endcase
        end
    end

endmodule: dotopt
