//////////////////////////////////////////////////////////////////
// Name File	: full_sync_dff_module.sv						//
// Autor		: Serhii Yatsenko								//
// Mail			: royalroad1995@gmail.com						//
// Description	: SystemVerilog module of the					//
// 				  Synchronous D-trigger							//
//				  (Synthesizable Digital Core).					//
//				  Synchronous D-trigger use synchronous reset	// 
//				  and enable inputs, where reset overrules the	// 
//				  enable input.									//
// Date			: 2020											//
// License		: MIT											//
//////////////////////////////////////////////////////////////////

module full_sync_dff_module
(
	input		logic d_i, rst_i, en_i, clk_i,
	output	logic q_o		
);
	always_ff @(posedge clk_i) begin
		if(rst_i)
			q_o <= 0;
		else if(en_i)
			q_o <= d_i;
	end
	
endmodule: full_sync_dff_module
