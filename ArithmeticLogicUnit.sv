// ArithmeticLogicUnit
// This is a basic implementation of the essential operations needed
// in the ALU. Adding futher instructions to this file will increase 
// your marks.

// Load information about the instruction set. 
import InstructionSetPkg::*;

// Define the connections into and out of the ALU.
module ArithmeticLogicUnit
(
	// The Operation variable is an example of an enumerated type and
	// is defined in InstructionSetPkg.
	input eOperation Operation,
	
	// The InFlags and OutFlags variables are examples of structures
	// which have been defined in InstructionSetPkg. They group together
	// all the single bit flags described by the Instruction set.
	input  sFlags    InFlags,
	output sFlags    OutFlags,
	
	// All the input and output busses have widths determined by the 
	// parameters defined in InstructionSetPkg.
	input  signed [ImmediateWidth-1:0] InImm,
	
	// InSrc and InDest are the values in the source and destination
	// registers at the start of the instruction.
	input  signed [DataWidth-1:0] InSrc,
	input  signed [DataWidth-1:0]	InDest,
	
	// OutDest is the result of the ALU operation that is written 
	// into the destination register at the end of the operation.
	output logic signed [DataWidth-1:0] OutDest
);

	// This block allows each OpCode to be defined. Any opcode not
	// defined outputs a zero. The names of the operation are defined 
	// in the InstructionSetPkg. 
	always_comb
	begin
	
		// By default the flags are unchanged. Individual operations
		// can override this to change any relevant flags.
		OutFlags  = InFlags;
		
		// The basic implementation of the ALU only has the NAND and
		// ROL operations as examples of how to set ALU outputs 
		// based on the operation and the register / flag inputs.
		case(Operation)		
		
			ROL:     {OutFlags.Carry,OutDest} = {InSrc,InFlags.Carry};	
			
			NAND:    OutDest = ~(InSrc & InDest);

			LIU:
				begin
					if (InImm[ImmediateWidth - 1] ==  1)
						OutDest = {InImm[ImmediateWidth - 2:0], InDest[ImmediateHighStart - 1:0]};
					else if  (InImm[ImmediateWidth - 1] ==  0)	
						OutDest = $signed({InImm[ImmediateWidth - 2:0], InDest[ImmediateMidStart - 1:0]});
					else
						OutDest = InDest;	
				end


			// ***** ONLY CHANGES BELOW THIS LINE ARE ASSESSED *****
			// Put your instruction implementations here.
			
			MOVE:		OutDest = InSrc;											// Move the value in the source directly to the output destination
			
			NOR:		OutDest = ~(InSrc | InDest);							// Perform the inverse of the OR of input source and destinations
			
			ROR:
				begin
					OutFlags.Carry = InSrc[0];								// Place the value at the end of the destination in the carry bit
					OutDest[DataWidth-2:0] = InSrc[DataWidth-1:1];		// Move the rest of indest to the lower-but-one bits of the out destination
					OutDest[DataWidth-1] = InFlags.Carry;					// Put the carry bit at the end of the out destination, completing the rotation
				end
				
			ADC:		
				begin
					{OutFlags.Carry,OutDest} = InSrc + InDest + InFlags.Carry;			// Sum the in source, destination and carry bit
					if (OutDest == 0)																	// If the result is zero...
						OutFlags.Zero = 1;															// ...set the zero flag
					else																					// If not make sure the zero flag isn't set
						OutFlags.Zero = 0;
					if (OutDest < 0)																	// If the result is less than zero...
						OutFlags.Negative = 1;														// ...set the negative flag
					else																					// If not less than zero...
						OutFlags.Negative = 0;														// ..make sure the negative flag is low
					// If the overflow conditions are met, set the overflow bit
					OutFlags.Overflow = ~(InDest[DataWidth-1])&(InSrc[DataWidth-1])&(OutDest[DataWidth-1])|(InDest[DataWidth-1])&~(InSrc[DataWidth-1])&~(OutDest[DataWidth-1]);														
					OutFlags.Parity = ~^OutDest;								// Set the parity bit depending on the inverse XOR of the output
					
				end
				
			SUB:		
				begin
					{OutFlags.Carry,OutDest} = (InDest - (InSrc + InFlags.Carry));			// Sum the in destination with the carry flag, then subtract this from the source
					if (OutDest == 0)																		// If the result is zero...
						OutFlags.Zero = 1;																// ...set the zero flag
					else																						// If not make sure the zero flag isn't set
						OutFlags.Zero = 0;
					if (OutDest < 0)																		// If the result is less than zero...
						OutFlags.Negative = 1;															// ...set the negative flag
					else																						// If not less than zero...
						OutFlags.Negative = 0;															// ...make sure the negative flag is low
						// If the overflow conditions are met, set the overflow bit
					OutFlags.Overflow = ~(InDest[DataWidth-1])&(InSrc[DataWidth-1])&(OutDest[DataWidth-1])|(InDest[DataWidth-1])&~(InSrc[DataWidth-1])&~(OutDest[DataWidth-1]);																											// Set the overflow bit										// ...set the carry bit
					OutFlags.Parity = ~^OutDest;								// Set the parity bit depending on the inverse XOR of the output
					
				end
						
			DIV:
				begin
					OutDest = InDest / InSrc;									// Output the division of the in destination over the in source
					OutFlags.Parity = ~^OutDest;								// Set the parity bit depending on the inverse XOR of the output
					if (OutDest == 0)												// If the result is zero...
						OutFlags.Zero = 1;										// ...set the zero flag
					else																// If not make sure the zero flag isn't set
						OutFlags.Zero = 0;
					if (OutDest < 0)												// If the result is less than zero...
						OutFlags.Negative = 1;									// ...set the negative flag
					else																// If not less than zero...
						OutFlags.Negative = 0;									// ..make sure the negative flag is low
				end
				
			MOD:
				begin
					OutDest = InDest % InSrc;									// Output the remainder of the division of the in destination over the in source
					OutFlags.Parity = ~^OutDest;								// Set the parity bit depending on the inverse XOR of the output
					if (OutDest == 0)												// If the result is zero...
						OutFlags.Zero = 1;										// ...set the zero flag
					else																// If not make sure the zero flag isn't set
						OutFlags.Zero = 0;
					if (OutDest < 0)												// If the result is less than zero...
						OutFlags.Negative = 1;									// ...set the negative flag
					else																// If not less than zero...
						OutFlags.Negative = 0;									// ..make sure the negative flag is low
				end
					
			MUL: 
				begin
					OutDest = InDest * InSrc;									// Multiply the in destination and source, placing the lower half of the result into the out destination.
					OutFlags.Parity = ~^OutDest;								// Set the parity bit depending on the inverse XOR of the output
					if (OutDest == 0)												// If the result is zero...
						OutFlags.Zero = 1;										// ...set the zero flag
					else																// If not make sure the zero flag isn't set
						OutFlags.Zero = 0;
					if (OutDest < 0)												// If the result is less than zero...
						OutFlags.Negative = 1;									// ...set the negative flag
					else																// If not less than zero...
						OutFlags.Negative = 0;									// ..make sure the negative flag is low
				end
				
			MUH: 
				begin
					{OutDest,OutDest} = InDest * InSrc;						// Multiply the in destination and source, placing the upper half of the result into the out destination.
					OutFlags.Parity = ~^OutDest;								// Set the parity bit depending on the inverse XOR of the output
					if (OutDest == 0)												// If the result is zero...
						OutFlags.Zero = 1;										// ...set the zero flag
					else																// If not make sure the zero flag isn't set
						OutFlags.Zero = 0;
					if (OutDest < 0)												// If the result is less than zero...
						OutFlags.Negative = 1;									// ...set the negative flag
					else																// If not less than zero...
						OutFlags.Negative = 0;									// ..make sure the negative flag is low
				end
				
			LIL:		OutDest = $signed(InImm);								// Add InImm bits in front of the MSB as a sign extension, store the output in the out destination
						
			// ***** ONLY CHANGES ABOVE THIS LINE ARE ASSESSED	*****		
			
			default:	OutDest = '0;
			
		endcase;
	end

endmodule
