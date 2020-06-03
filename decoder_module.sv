//////////////////////////////////////////////////////////////////
// Name File	: decoder_module.sv								//
// Autor		: Serhii Yatsenko								//
// Mail			: royalroad1995@gmail.com						//
// Description	: SystemVerilog module of the					//
// 				  Binary to Decimal Decoder						//
//				  (Synthesizable Digital Core)					//
// Date			: 2020											//
// License		: MIT											//
//////////////////////////////////////////////////////////////////

module decoder_module #(
	parameter	INPUT_WIDTH		= 5,
					OUTPUT_WIDTH	= 32
)(	
	input		[INPUT_WIDTH-1:0]		d_i,
	output	[OUTPUT_WIDTH-1:0]	d_o
);
	assign d_o = 1'b1 << d_i;
	
endmodule: decoder_module
