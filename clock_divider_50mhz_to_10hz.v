module clock_divider_50mhz_to_10hz(
    input wire clk_in, // 50 Mhz clock input
    input wire rstn, // Active-low reset
    output reg clk_out // 10 Hz clock output
);

parameter TC = 5000000;
reg [22:0] counter;

always @(posedge clk_in or negedge rstn) begin
   if(!rstn) begin
    counter <= 0;
    clk_out <= 0;
   end else begin
    if (counter == TC - 1) begin // Count to 5000000
    counter <= 0;
    clk_out <= ~clk_out; // Toggle output clock
    end else begin
        counter <= counter + 1;
    end
   end
end


endmodule