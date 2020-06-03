/**
  ***********************************************************************************
  * @file    top_i2s_rx_module.sv
  * @author  Serhii Yatsenko [royalroad1995@gmail.com]
  * @version V1.0
  * @date    May-2020
  * @brief   Synthesizable Digital Core of the I2S receiver. To successfully compile
  *	     this design in the same directory, the following files with 
  *	     SystemVerilog design must be located with it:
  *		- cntr_module.sv
  *		- decoder_module.sv
  *		- full_sync_dff_module.sv
  ***********************************************************************************
  * @license
  *
  * MIT License
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
  * in the Software without restriction, including without limitation the rights
  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  * copies of the Software, and to permit persons to whom the Software is
  * furnished to do so, subject to the following conditions:
  *
  * The above copyright notice and this permission notice shall be included in all
  * copies or substantial portions of the Software.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  *
  ***********************************************************************************
  */

module top_i2s_rx_module #(
	parameter	FRAME_RES	= 32,
			DATA_RES	= 24
)(
	input	logic			bck_i, lrck_i, dat_i,
	output	logic	[DATA_RES-1:0]	left_o, right_o
);
	
	localparam LOG2_FRAME_RES = $clog2(FRAME_RES);

	logic				wsd, wsn, wsp;
	logic [DATA_RES-1:0]		data;
	logic [FRAME_RES-1:0]		en_data;
	logic [LOG2_FRAME_RES-1:0]	cnt;

	cntr_module #(
		.CNT_RES	( LOG2_FRAME_RES	)
	) cntr (
		.rst_i		( wsp			),
		.clk_i		(~bck_i			),
		.en_i		(~en_data[FRAME_RES-1]	),
		.cnt_o		( cnt			)
	);
	
	decoder_module #(
		.INPUT_WIDTH	( LOG2_FRAME_RES	),
		.OUTPUT_WIDTH	( FRAME_RES		)
	) decoder (
		.d_i		( cnt			),
		.d_o		( en_data		)
	);
	
	genvar i;
	generate
		for(i = 0; i < DATA_RES-1; i++) begin: forgen
			full_sync_dff_module dreg (
				.d_i	( dat_i			),
				.rst_i	( wsp			),
				.en_i	( en_data[DATA_RES-1-i]	),
				.clk_i	( bck_i			),
				.q_o	( data[i]		)
			);
		end: forgen
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

endmodule: top_i2s_rx_module
