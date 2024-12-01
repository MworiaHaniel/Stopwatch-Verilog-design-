module stopwatch(
    input clk,
    input resetn,
    input start_stop,
    input lap,
    input clear,
    input [1:0] speed_mode,
    output [6:0] minutesDigit,
    output [6:0] tensDigit,
    output [6:0] onesDigit,
    output [6:0] tenthsDigit,
    output [3:0] minutes,
    output [3:0] seconds_tens,
    output [3:0] seconds_ones,
    output [3:0] tenths
);

//wire [3:0] tenths, seconds_ones, seconds_tens, minutes;
wire timer_enable, running;
wire [15 :0] lap1, lap2, display;
wire [1:0] display_select;

// Clear Logic: Ensure clear is only effective when the timer is stopped
wire clear_active = clear && !running;

// Propagate clear to submodules
assign reset_timer = clear_active;
assign reset_lap_storage = clear_active;


// Submodules
speed_control speed(.clk(clk), .rstn(resetn), .speed_mode(speed_mode), .timer_enable(timer_enable));
timer timer_inst (.clk(clk), .rstn(resetn & ~reset_timer), .enable(timer_enable & running), .tenths(tenths), .seconds_ones(seconds_ones), .seconds_tens(seconds_tens), .minutes(minutes));
lap_storage lap_store (.clk(clk), .rstn(resetn & ~reset_lap_storage), .lap(lap), .tenths(tenths), .seconds_ones(seconds_ones), .seconds_tens(seconds_tens), .minutes(minutes), .lap1(lap1), .lap2(lap2));
display_mux mux_inst (.running_time({minutes, seconds_tens, seconds_ones, tenths}), .lap1(lap1), .lap2(lap2), .display_select(display_select), .display(display));
fsm_control fsm(.clk(clk), .rstn(resetn), .start_stop(start_stop), .lap(lap), .running(running), .display_select(display_select));
seven_seg_decoder dec1 (.bcd(display[15:12]), .seg(minutesDigit));
seven_seg_decoder dec2 (.bcd(display[11:8]), .seg(tensDigit));
seven_seg_decoder dec3 (.bcd(display[7:4]), .seg(onesDigit));
seven_seg_decoder dec4 (.bcd(display[3:0]), .seg(tenthsDigit));
endmodule
