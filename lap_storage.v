module lap_storage(
    input clk,
    input rstn,
    input lap,  // Lap button
    input [3:0] tenths, 
    input [3:0] seconds_ones,
    input [3:0] seconds_tens,
    input [3:0] minutes,
    output reg [15:0] lap1,  // Most recent lap time
    output reg [15:0] lap2   // Second Most recent lap time
);

always @(posedge clk or negedge rstn ) begin
    if (!rstn) begin
        lap1 <= 0;
        lap2 <= 0;
    end else if (lap) begin
        lap2 <= lap1; 
        lap1 <= {minutes, seconds_tens, seconds_ones, tenths};
    end  
end

endmodule
