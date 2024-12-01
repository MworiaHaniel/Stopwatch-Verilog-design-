module timer (
    input clk, // 10 Hz Clock
    input rstn, // Active low reset
    input enable, //  Enable signal (from FSM)
    output reg [3:0] tenths, // Tenths of a second (0-9)
    output reg [3:0] seconds_ones, // Seconds (0-9)
    output reg [3:0] seconds_tens, // Tens of seconds (0-5)
    output reg [3:0] minutes // minutes (0-9)
);

always @(posedge clk or negedge rstn) begin
  if (!rstn) begin
    tenths <= 0;
    seconds_ones <=0;
    seconds_tens <=0;
    minutes <= 0;
  end else if (enable) begin
    // Increment tenths
    if (tenths == 9) begin
        tenths <= 0;
        // Increment seconds_ones
        if (seconds_ones == 9) begin
            seconds_ones <= 0;
            // Increment seconds_tens
            if (seconds_tens == 5) begin
                seconds_tens <= 0;
                // Increment minutes
                if (minutes == 9)
                minutes <= 0;
                else 
                minutes <= minutes + 1;
            end else 
            seconds_tens <= seconds_tens + 1;
        end else
        seconds_ones <= seconds_ones + 1;
    end else
    tenths <= tenths + 1;

    end

  end



endmodule
