module dot(input logic clk, input logic rst_n,
           // slave (CPU-facing)
           output logic slave_waitrequest,
           input logic [3:0] slave_address,
           input logic slave_read, output logic [31:0] slave_readdata,
           input logic slave_write, input logic [31:0] slave_writedata,
           // master (memory-facing)
           input logic master_waitrequest,
           output logic [31:0] master_address,
           output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
           output logic master_write, output logic [31:0] master_writedata);

    // your code here
    logic [31:0] start_value;
    logic [31:0] weight_base;
    logic [31:0] vector_base;
    logic [31:0] length;
    logic [31:0] counter;

    logic signed [31:0] curr_weight;
    logic signed [31:0] curr_vector;
    logic signed [63:0] product;
    logic signed [31:0] sum;

    enum{reset, setup, readweight, waitreadweight, readvector, waitreadvector, dotproduct, done} state;

    assign slave_readdata = (slave_read && slave_address == 4'd0) ? sum : 32'b0;

    always @(posedge clk) begin
        if (rst_n == 0)
            state <= reset;
        else begin
            case(state)
            reset: begin
                slave_waitrequest <= 1'b0;
                state <= setup;
            end

            setup: begin
                counter <= 0;
                if (slave_write) begin
                    sum <= 32'b0;
                    case(slave_address)
                    4'd0: begin 
                        state <= readweight; 
                        start_value <= slave_writedata; 
                        slave_waitrequest <= 1'b1;
                    end
                    4'd2: weight_base <= slave_writedata;
                    4'd3: vector_base <= slave_writedata;
                    4'd5: length <= slave_writedata;
                    endcase
                end
            end

            readweight: begin
                master_write <= 1'b0;
                if (counter < length) begin
                    master_read <= 1'b1;
                    master_address <= weight_base + counter * 4;
                    state <= waitreadweight;
                end
                else
                    state <= done;
            end

            waitreadweight: begin
                if (master_waitrequest == 1'b0) begin
                    if (master_readdatavalid) begin
                        master_read <= 1'b0;
                        curr_weight <= master_readdata;
                        state <= readvector;
                    end
                end
            end

            readvector: begin
                master_read <= 1'b1;
                master_address <= vector_base + counter * 4;
                state <= waitreadvector;
            end

            waitreadvector: begin
                if (master_waitrequest == 1'b0) begin
                    if (master_readdatavalid) begin
                        master_read <= 1'b0;
                        curr_vector <= master_readdata;
                        state <= dotproduct;
                    end
                end
            end

            dotproduct: begin
                product = curr_weight * curr_vector;
                sum = sum + product[47:16];
                state <= readweight;
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

endmodule: dot