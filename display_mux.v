module display_mux(
    input [15:0] running_time,
    input [15:0] lap1,
    input [15:0] lap2,
    input [1:0] display_select, // 00 =Running, 01=Lap1, 10=Lap2
    output reg [15:0] display
);

 always @(display_select or running_time or lap1 or lap2) begin
    case(display_select)
      2'b00: display = running_time;
      2'b01: display = lap1;
      2'b10: display = lap2;
      default: display =16'd0;
 endcase
 end


endmodule
