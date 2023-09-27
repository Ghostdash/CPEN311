module wordcopy(input logic clk, input logic rst_n,
                // slave (CPU-facing)
                output logic slave_waitrequest,
                input logic [3:0] slave_address,
                input logic slave_read, output logic [31:0] slave_readdata,
                input logic slave_write, input logic [31:0] slave_writedata,
                // master (SDRAM-facing)
                input logic master_waitrequest,
                output logic [31:0] master_address,
                output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
                output logic master_write, output logic [31:0] master_writedata);

    // your code here
    logic [31:0] start_value;
    logic [31:0] dst;
    logic [31:0] src;
    logic [31:0] n_words;
    logic [31:0] counter;

    enum{reset, setup, read, waitread, write, waitwrite, done} state;

    assign slave_readdata = (slave_read && slave_address == 4'd0) ? start_value : 32'b0;

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
                    case(slave_address)
                    4'd0: begin 
                        state <= read; 
                        start_value <= slave_writedata; 
                        slave_waitrequest <= 1'b1;
                    end
                    4'd1: dst <= slave_writedata;
                    4'd2: src <= slave_writedata;
                    4'd3: n_words <= slave_writedata;
                    endcase
                end
            end

            read: begin
                master_write <= 1'b0;
                if (counter < n_words) begin
                    master_read <= 1'b1;
                    master_address <= src + counter * 4;
                    state <= waitread;
                end
                else
                    state <= done;
            end

            waitread: begin
                if (master_waitrequest == 1'b0) begin
                    master_read <= 1'b0;
                    state <= write;
                end
            end

            write: begin
                if (master_readdatavalid) begin
                    master_write <= 1'b1;
                    master_writedata <= master_readdata;
                    master_address <= dst + counter * 4;
                    state <= waitwrite;
                end
            end

            waitwrite: begin
                if (master_waitrequest == 1'b0) begin
                    master_write <= 1'b0;
                    counter <= counter + 1;
                    state <= read;
                end
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
endmodule