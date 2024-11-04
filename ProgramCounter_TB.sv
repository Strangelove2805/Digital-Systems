`timescale 1ns / 1ps

module ProgramCounter_TB();

	logic Clock = 0;									// Import inputs / outputs from ProgramCounter.sv
	logic	Reset;
	logic LoadEnable;
	logic OffsetEnable;
	logic signed [8:0] Offset;
	logic [15:0] LoadValue;
	logic signed [15:0] CounterValue;
	
	ProgramCounter uut(.*);							// Assign inputs / outputs from ProgramCounter.sv
	
	default clocking @(posedge Clock);			// Set default rising edge clock cycle
	endclocking
	
	always #10 Clock = ~Clock;						// Set the clock pulse to 10ns on, 10 ns off

	initial
	begin
	   Reset = 0;										// Set the reset bit to low
		CounterValue = 0;								// Set the counter to the start
		LoadEnable = 0;								// Do not enable a value to be loaded
		OffsetEnable = 0;								// Do not enable the offset to be applied
		
		Offset = 9'b111110001;						// Set the offset to an arbitrary negative number
		LoadValue = 16'b0000001010101101;		// Set the load value to an arbitrary high number
		
		#20 Reset = 1;									// Set the reset bit for a short time
		#20 Reset = 0;
		
		#60 LoadEnable = 1;							// Allow the load value to be loaded into the counter
		#20 LoadEnable = 0;
		
		#140 Reset = 1;								// Set the reset bit for a short time
		#20 Reset = 0;
		
		#140 LoadEnable = 1;							// Allow the load value to be loaded into the counter
		#20 LoadEnable = 0;
		
		#140 OffsetEnable = 1;						// Offset the counter by the amount indicated
		#20 OffsetEnable = 0;
		
	end
	
endmodule
