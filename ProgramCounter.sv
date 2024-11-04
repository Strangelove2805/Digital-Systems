module ProgramCounter
(
	input logic Clock,									//	Clock pulse
	input logic Reset,									// Counter value reset bit
	input logic LoadEnable,								// Load insert confirmation bit
	input logic OffsetEnable,							// Offset confirmation bit
	input logic signed [8:0] Offset,					// 9 bit, 2's complement port for the offset
	input logic [15:0] LoadValue,						// 16 bit port for a value to be loaded into the counter
	output logic signed [15:0] CounterValue		// 16 bit port for the counter
);

always_ff @(posedge Clock, posedge Reset)				// Always run this loop on the rising edge of clock and reset
begin
        if (Reset)											// If reset is high
            CounterValue <= 0;								// Reset the counter value
        else if (LoadEnable)								// If LoadEnable is high
				CounterValue <= LoadValue;						// Store the loaded value in the counter
		  else if (OffsetEnable)							// If OffsetEnable is high
		      CounterValue <= CounterValue + Offset;		// Add the offset to the counter
		  else													// If none of these conditions are met
            CounterValue <= CounterValue + 1;			// Increase the counter by 1
   end
endmodule
