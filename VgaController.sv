module VgaController
(

	input Clock,
	input Reset,
	output logic  blank_n, 				
	output logic  sync_n, 
	output logic  hSync_n, 
	output logic  vSync_n, 
	output logic [11:0] nextX, 
	output logic [11:0] nextY 
);

	logic [11:0] hCount; 						// signal used to increment horizontal counter
	logic [11:0] vCount; 						// signal used to increment vertical counter
	

always_ff @(posedge Clock) 					// Run the loop on the positive edge of the Clock signal
begin

	if (Reset)										// If the Reset bit is logic 1...
	
		begin
		
			hCount <= 1;							// ... set the hCount bit high
			vCount <= 1;							// ... set the vCount bit high
			
		end
		
	else if (hCount >= 1040)					// If the reset bit is low and hCount is greater or equal to the width of the screen...
	
		begin
		
			hCount <= 1;							// ... set the hCount to 1
			
			if (vCount >= 666) 					// If vCount is greater or equal to height of the screen...
			
				vCount <= 1;						// ... set the vCount to 1
			
			else 										// If vCount is less than the height...
			
				vCount <= vCount + 1;			// ... increment vCount by 1
				
		end

	else 												// If the reset bit is low and hCount is lower than the width...
	
		hCount <= hCount + 1;					// ... increment hCount by 1
	 
end

assign nextX = (hCount < 800) ? hCount : 0;							// If hCount is in the visible area, update nextX with hCount. If not, it is zero

assign nextY = (vCount < 600) ? vCount : 0; 							// If vCount is in the visible area, update nextX with vCount. If not, it is zero

assign hSync_n = ((hCount >= 856) & (hCount < 976)) ? 0 : 1;	// If hCount > front porch and less than or equal to the sync, set hSync_n low. If not, it is high

assign vSync_n = ((vCount >= 637) & (vCount < 643)) ? 0 : 1;	// If vCount > front porch and less than or equal to the sync, set vSync_n low. If not, it is high

assign blank_n = ((hCount >= 800) | (vCount >= 600)) ? 0 : 1;	// If hCount or vCount are at or beyond the front porch, set blank_n low. If not, it is high


// If hCount is greater than or equal to Sync Pulse and less than Back Porch, or if vCount is greater than or equal to Sync Pulse 
// and less then Back Porch then set sync_n low. If not, it is high
assign sync_n = (((hCount >= 856) & (hCount < 976)) | ((vCount >= 637) & (vCount < 643))) ? 0 : 1;	


endmodule 