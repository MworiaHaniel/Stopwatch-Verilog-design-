module fsm_control(
    input clk,
    input rstn,
    input start_stop,
    input lap,
    output reg running,
    output reg [1:0] display_select // 00=Running, 01=Lap1, 10=Lap2
);

// Define states as parameters
parameter STOPPED = 2'b00;
parameter RUNNING = 2'b01;
parameter DISPLAY_LAP = 2'b10;

reg [1:0] current_state, next_state;

// Always Block for State Transitions
always @(posedge clk or negedge rstn) begin
    if(rstn == 1'b0) begin
      current_state <= STOPPED; // Reset state to STOPPED
    end else begin
       current_state <= next_state; // Transition to the next state
    end
end

// Always block for next state and outputs
always @(current_state or start_stop or lap) begin
    // next_state = current_state;
    // running = 0;

   case(current_state)
   // Stopped State
   STOPPED : begin
    running = 0;
    display_select =2'b00; // Display Running 
    if (start_stop) begin
    next_state = RUNNING;
    end
    end

    RUNNING : begin
      running = 1; // Timer is running
      display_select = 2'b00; // Display Running 
      if (start_stop) begin
        next_state = STOPPED;
      end else if (lap) begin
        next_state = DISPLAY_LAP;
      end
    end

// Display Lap state
    DISPLAY_LAP : begin
    running = 1; // TImer is running in the background 
    

    if (lap) begin 
        // If already displaying lap 1, go to lap 2
        case(display_select)
        2'b00: display_select = 2'b01; // Show lap 1
        2'b01: display_select  = 2'b10; // Show lap 2
        2'b10: display_select = 2'b00; // revert to running timer
        default : display_select  = 2'b01; // Default to lap 1

        endcase
        
    end
    // Return to Stopped or running based on start stop
    if (start_stop) begin
    next_state  = STOPPED;

    end
    end
    default : begin
     next_state = STOPPED;
     running = 0;
     display_select  = 2'b00;

    end
  
endcase
end

endmodule
