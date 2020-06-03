//////////////////////////////////////////////////////////////////
// Name File	: cntr_module.sv								//
// Autor		: Serhii Yatsenko								//
// Mail			: royalroad1995@gmail.com						//
// Description	: SystemVerilog module of the					//
// 				  Binary Counter (Synthesizable Digital Core).	//
//				  Binary Counter use synchronous reset and		//
//				  enable inputs, where reset overrules the		// 
//				  enable input.									//
// Date			: 2020											//
// License		: MIT											//
//////////////////////////////////////////////////////////////////

module cntr_module #(
	parameter CNT_RES = 5
)(
	input		logic						rst_i, clk_i, en_i,
	output	logic [CNT_RES-1:0]	cnt_o
);
	always_ff @(posedge clk_i) begin
		if(rst_i)
			cnt_o <= 0;
		else if(en_i)
			cnt_o <= cnt_o + 1'b1;
	end
	
endmodule: cntr_module
