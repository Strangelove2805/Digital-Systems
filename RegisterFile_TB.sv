`timescale 1ns / 1ps

module RegisterFile_TB();

	logic Clock = 0;									// Import inputs / outputs from RegisterFile.sv
	logic [5:0] AddressA;
	logic [5:0] AddressB;
	logic [15:0] ReadDataA;
	logic [15:0] ReadDataB;
	logic [15:0] WriteData;
	logic WriteEnable;
	logic [15:0] Registers [63:0];
	
	RegisterFile uut(.*);							// Assign inputs / outputs from RegisterFile.sv
	
	default clocking @(posedge Clock);			// Set default rising edge clock cycle
	endclocking
	
	always #10 Clock = ~Clock;						// Set the clock pulse to 10ns on, 10 ns off

	initial
	begin
	
		// The choice of WriteData values below is random. Arbitrary high numbers just to test the functionality.
		
		WriteEnable = 0;								// Start with no addresses being written
		AddressA = 6'b000001;						// Set addressA to be address 1
		WriteData = 16'b0000001010101101;		// Set the data to be written to be 685		
		#40 WriteEnable = 1;							// Enable the writing of data for a short time
		#20 WriteEnable = 0;
		
		#10 AddressA = 6'b000111;					// Change the location of address A to address 7
		#10 WriteData = 16'b1010110110101101;	// Change the written data to 44461
		
		#100 WriteEnable = 1;						// Enable the writing of data for a short time
		#20 WriteEnable = 0;
		
		#10 AddressA = 6'b001101;					// Change the location of addressA to address 13
		#10 WriteData = 16'b0000000000000001;	// Change the written data to 1
		
		#100 WriteEnable = 1;						// Enable the writing of data for a short time
		#20 WriteEnable = 0;
		
		#10 AddressB = 6'b000001;					// Change addressB to a previously written address to see if it stays written
		
		
	end
	
endmodule
