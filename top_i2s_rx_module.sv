//////////////////////////////////////////////////////////////////
// Name File	: i2s_rx_module.sv								//
// Autor		: Serhii Yatsenko								//
// Mail			: royalroad1995@gmail.com						//
// Description	: SystemVerilog module of the					//
//				  I2S receiver (Synthesizable Digital Core).	//
// описать инклуды cntr_module, decoder_module, full_sync_dff_module	//
// Date			: 2020											//
// License		: MIT											//
//////////////////////////////////////////////////////////////////

module i2s_rx_module #(
	parameter	FRAME_RES 	= 32,
					DATA_RES		= 24
	
)(
	input		logic						bck_i, lrck_i, dat_i,
	output	logic [DATA_RES-1:0]	left_o, right_o
);
	localparam LOG2_FRAME_RES = $clog2(FRAME_RES);

	logic								wsd, wsn, wsp;
	logic [DATA_RES-1:0]			data;
	logic [FRAME_RES-1:0]		en_data;
	logic [LOG2_FRAME_RES-1:0]	cnt;

	cntr_module #(
		.CNT_RES			( LOG2_FRAME_RES					)
	) cntr (
		.rst_i			( wsp									),
		.clk_i			( ~bck_i								),
		.en_i				( ~en_data[FRAME_RES-1]			),
		.cnt_o			( cnt									)
	);
	
	decoder_module #(
		.INPUT_WIDTH	( LOG2_FRAME_RES					),
		.OUTPUT_WIDTH	( FRAME_RES							)
	) decoder (
		.d_i				( cnt									),
		.d_o				( en_data							)
	);
	
	genvar i;
	generate
		for(i = 0; i < DATA_RES-1; i++) begin: forgen
			full_sync_dff_module dreg (
					.d_i	( dat_i								),
					.rst_i( wsp									),
					.en_i	( en_data[DATA_RES-1-i]			),
					.clk_i( bck_i								),
					.q_o	( data[i]							)
			);
		end
	endgenerate

	assign wsp = wsd ^ wsn;

	always_ff @(posedge bck_i) begin
		wsd <= lrck_i;
		wsn <= wsd;
		if(en_data[0])
			data[DATA_RES-1] <= dat_i;
		if(wsp & ~wsd)
			right_o	<= data;
		if(wsp & wsd)
			left_o	<= data;
	end

endmodule: i2s_rx_module
