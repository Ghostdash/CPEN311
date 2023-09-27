module lab0(input CLOCK_50, input resetn,
            input [3:0] valueA, input [3:0] valueB, 
            input loadA, input loadB, 
            output [4:0] sum);

    reg [3:0] storedA, storedB;

    assign sum = storedA + storedB;

    always @ (posedge CLOCK_50) begin
      if (~resetn) begin
          storedA <= 4'b0;
          storedB <= 4'b0;
      end
      else
      begin
            if (loadA) begin
                storedA <= valueA;
            end
            if (loadB) begin
                storedB <= valueB;
            end
      end
    end

endmodule
