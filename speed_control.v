module speed_control(
    input clk,
    input rstn,
    input [1 : 0] speed_mode,
    output reg timer_enable
);

reg [4:0] clk_div;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        clk_div <= 0;
        timer_enable <= 0;
    end else begin
         case(speed_mode)
         // Normal Speed
          2'b00 : begin
            timer_enable <= 1'b1; //  Timer increments with every clock tick
            clk_div <= 0;  // No division needed
          end
          // 4x speed
          2'b01 : begin
             // Increment timer every 1/4th of a clock tick
             if (clk_div == 3) begin
                timer_enable <= 1'b1;
                clk_div <= 0;
             end else begin
                timer_enable <= 1'b0;
                clk_div <= clk_div + 1;
             end
          end

          // 20x speed 
          2'b10 : begin
            // Increment timer every 1/20th of a clock tick
            if (clk_div == 19) begin
                timer_enable <= 1'b1;
                clk_div <= 0;
            end else begin
                timer_enable = 1'b0;
                clk_div <= clk_div + 1;
            end
          end
          // Default case (no operation)
          default : begin
          timer_enable <= 0;
          clk_div <= 0;
              
          end
         endcase

    end

end

endmodule