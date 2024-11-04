module RegisterFile
(
	input logic Clock,					//	Clock pulse
	input logic [5:0] AddressA,		// Address index for PORTA
	input logic [5:0] AddressB,		// Address index for PORTB
	input logic [15:0] WriteData,		// 16 bit value that will be written to an address
	input logic WriteEnable,			// Bit to enable the writing of data to an address
	output logic [15:0] ReadDataA,	// 16 bit output, showing the value stored in addressA
	output logic [15:0] ReadDataB		// 16 bit output, showing the value stored in addressB
);

logic [15:0] Registers [63:0];		// (16 x 64) 2 dimensional matrix for storing addresses

always @(posedge Clock)	// Always run this loop on the rising edge of clock

    if (WriteEnable)									// If the WriteEnable bit is high
        Registers[AddressA] <= WriteData;		// Write the binary value in WriteData to a specified address
    else													// If the WriteEnable bit is low
		begin
        ReadDataA <= Registers[AddressA];		// Read and display the data from address A
		  ReadDataB <= Registers[AddressB];		// Read and display the data from address A
		end
endmodule
