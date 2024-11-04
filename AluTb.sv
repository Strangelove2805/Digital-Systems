`timescale 1ns / 1ps

import InstructionSetPkg::*;

// This module implements a set of tests that 
// partially verify the ALU operation.
module AluTb();

	eOperation Operation;
	
	sFlags    InFlags;
	sFlags    OutFlags;
	
	logic signed [ImmediateWidth-1:0] InImm = '0;
	
	logic	signed [DataWidth-1:0] InSrc  = '0;
	logic signed [DataWidth-1:0] InDest = '0;
	
	logic signed [DataWidth-1:0] OutDest;

	ArithmeticLogicUnit uut (.*);

	initial
	begin
		InFlags = sFlags'(0);
		
		
		$display("Start of NAND tests");																			// Start NAND tests
		Operation = NAND;
		
		InDest = 16'h0000;
		InSrc  = 16'ha5a5;      
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h9999; 
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'hFFFF; 
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h1234; 
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h0000;   
		InDest = 16'ha5a5;     
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h9999;  
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'hFFFF; 
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h1234;  
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		#50;

		
		$display("Start of NOR tests");																			// Start NOR tests
		Operation = NOR;
		
		InDest = 16'h0000;
		InSrc  = 16'ha5a5;      
	   #1 if (OutDest != 16'h5a5a) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'h9999; 
	   #1 if (OutDest != 16'h4242) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'hFFFF; 
	   #1 if (OutDest != 16'h0000) $display("Error in NOR operation at time %t",$time);
		#50;
		
		
		$display("Start of ADC tests");																			// Start ADC tests
		Operation = ADC;
		
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'ha5a5) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InFlags.Carry = '1;
	   #1 
		if (OutDest != 16'ha5a6) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);

		#10 InDest = 16'h5a5a; 
	   #1 
		if (OutDest != 16'h0000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(11)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h8000;
		InFlags.Carry = '0;
		InSrc = 16'hffff;      
	   #1 
		if (OutDest != 16'h7fff) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(17)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h7fff;
		InSrc = 16'h0001;     
	   #1 
		if (OutDest != 16'h8000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(20)) $display("Error (flags) in ADC operation at time %t",$time);
		#50;

		
		$display("Start of LIU tests");																			// Start LIU tests
		Operation = LIU;
		
		InDest = 16'h0000;
		InImm = 6'h3F;          
	   #1 if (OutDest != 16'hF800) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h0F;      
	   #1 if (OutDest != 16'h03C0) $display("Error in LIU operation at time %t",$time);
		
		#10 InDest = 16'hAAAA;  		
	   #1 if (OutDest != 16'h03EA) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h3F;      
	   #1 if (OutDest != 16'hFAAA) $display("Error in LIU operation at time %t",$time);
		#50;
		
		
		$display("Start of ROL tests");																			// Start ROL tests
		Operation = ROL;
		
		InDest = 16'h0000;
		InSrc = 16'ha5a5;
		InFlags.Carry = '0;
		
		#20 InFlags.Carry = '1;
		#50
		
		$display("Start of ROR tests");																			// Start ROR tests
		Operation = ROR;
		
		InDest = 16'h0000;
		InSrc = 16'ha5a5;
		InFlags.Carry = '0;
		
		#20 InFlags.Carry = '1;
		#50
		
		$display("Start of MOVE tests");																			// Start MOVE tests
		Operation = MOVE;
		
		InDest = 16'h0000;
		InSrc = 16'ha5a5;

		#50
		
		$display("Start of DIV tests");																			// Start DIV tests
		Operation = DIV;
		
		InDest = 16'h0000;
		InSrc = 16'h8000;
		#20
		InDest = 16'ha5a5;

		#50
		
		$display("Start of SUB tests");																			// Start SUB tests
		Operation = SUB;
		
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'ha5a5) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InFlags.Carry = '1;
	   #1 
		if (OutDest != 16'ha5a6) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);

		#10 InDest = 16'h5a5a; 
	   #1 
		if (OutDest != 16'h0000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(11)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h8000;
		InFlags.Carry = '0;
		InSrc = 16'hffff;      
	   #1 
		if (OutDest != 16'h7fff) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(17)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h7fff;
		InSrc = 16'h0001;     
	   #1 
		if (OutDest != 16'h8000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(20)) $display("Error (flags) in ADC operation at time %t",$time);
		#50;
		
		$display("Start of MUL tests");																			// Start MUL tests
		Operation = MUL;
		
		InDest = 16'hb4b4;
		InSrc = 16'ha5a5;

		#50
		
		$display("Start of MUH tests");																			// Start MUH tests
		Operation = MUH;
		
		InDest = 16'hb4b4;
		InSrc = 16'ha5a5;
		
		#10
		
		InDest = 16'd65000;					// Test to fire the negative flag
		InSrc = 16'd2000;
		
		#10
		
		InDest = 16'd1;						// Test to fire the zero flag
		InSrc = 16'd2;


		#50
		
		$display("Start of LIL tests");																			// Start LIL tests
		Operation = LIL;
		
		InDest = 16'h0000;
		InImm = 6'h3F;          
	   #1 if (OutDest != 16'hF800) $display("Error in LIL operation at time %t",$time);
		
		#10 InImm = 6'h0F;      
	   #1 if (OutDest != 16'h03C0) $display("Error in LIL operation at time %t",$time);
		
		#10 InDest = 16'hAAAA;  		
	   #1 if (OutDest != 16'h03EA) $display("Error in LIL operation at time %t",$time);
		
		#10 InImm = 6'h3F;      
	   #1 if (OutDest != 16'hFAAA) $display("Error in LIL operation at time %t",$time);
		#50;
	
		$display("Start of MOD tests");																			// Start MOD tests
		Operation = MOD;
		
		InDest = 16'd9;					// Test to fire the negative flag
		InSrc = 16'd2;
		
		#10
		
		InDest = 16'd4;					// Test to fire the zero flag
		InSrc = 16'd2;

		#50
		
		$display("Start of DIV tests");																			// Start DIV tests
		Operation = DIV;
		
		InDest = 16'd0;					// Test to fire the zero flag
		InSrc = 16'd5;
		
		#10
		
		InDest = 16'd9;					// Test to fire the negative flag
		InSrc = 16'd2;

		#50
		
		$display("End of tests");
	end
endmodule
