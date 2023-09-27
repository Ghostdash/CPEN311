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
    logic [31:0] num_words;
    logic [31:0] counter;
    logic [31:0] dest_address;
    logic [31:0] sour_address;
    logic [31:0] temp;

    enum {RESET, RECEIVE, READ,WAIT,COPY,WAIT2,DONE} state;
    always @(posedge clk) begin
        if (rst_n == 0) state <= RESET;
        else begin
            case (state)
                RESET: begin
                    slave_waitrequest <= 0;
                    state <= RECEIVE;
                end
                RECEIVE: begin
                    if (slave_write) begin
                        case (slave_address[3:2])
                            2'b00: begin
                                state <= READ;
                                counter <= 0;
                                master_read <= 1;
                                slave_waitrequest <= 1;
                                temp <= slave_writedata;
                            end
                            2'b01: dest_address <= slave_writedata;   //offset 1    
                            2'b10: sour_address <= slave_writedata;
                            2'b11: num_words <= slave_writedata;
                        endcase
                    end
                    if (slave_read == 1 && slave_address[3:2] == 2'b00)
                        slave_readdata <= temp;
                end
                READ: begin
                    slave_waitrequest <= 1;
                    master_write <= 0;
                    master_read <= 1;
                    if (counter < num_words) begin
                        master_address <= sour_address + 4*counter;
                        state <= WAIT;
                    end
                    else begin
                        state <= DONE;
                        slave_waitrequest <= 0;
                    end
                end
                WAIT: begin
                    if (master_waitrequest == 0 && master_readdatavalid == 1) begin
                        state <= COPY;
                        slave_waitrequest <= 0;
                        master_writedata <= master_readdata;
                    end
                end
                COPY: begin
                    master_read <= 0;
                    master_write <= 1;
                    master_address <= dest_address + 4*counter;
                    state <= WAIT2;
                end
                WAIT2:begin
                    if (master_waitrequest == 0) begin       //data has been written in
                        counter <= counter + 1;
                        state <= READ;
                    end
                end
                default: begin
                    state <= RECEIVE; 
                end
            endcase
        end
    end

endmodule: wordcopy
