# Synthesizable SystemVerilog IP-Core of the I2S receiver

This Synthesizable IP-Core of I2S receiver is a SystemVerilog representation of the I2S (audio data format) receiver digital circuit from [I2S bus specification document](./I2SBUS_Specification.pdf "I2S bus specification"), page 6. The uniqueness of this implementation of the I2S receiver lies in the fact that during the synthesis of the circuit, only the necessary number of D-triggers is generated in accordance with the bit depth of the audio data (DATA_RES), which allows to occupy a minimum of FPGA or CPLD resources.

* Project structure
	* I2SBUS_Specification.pdf - I2S bus specification document
	* README.md - current file
	* LICENSE - file with license description
  * cntr_module.sv - Synthesizable Digital IP-Core of the Binary Counter
  * decoder_module.sv  - Synthesizable Digital IP-Core of the binary to decimal decoder
  * full_sync_dff_module.sv - Synthesizable Digital IP-Core of the Synchronous D-trigger
  * top_i2s_rx_module.sv - file with Top-level module of the I2S receiver Synthesizable Digital IP-Core

# top_i2s_rx_module description

* User constants
  * FRAME_RES - RAW audio frame bit resolution
  * DATA_RES - audio data bit resolution
* Inputs
  * bck_i - bit clock signal (BCK)
  * lrck_i - left-right channel clock signal (LRCK)
  * dat_i - data bitstream signal (DATA)
* Outputs
  * left_o - left data output bus
  * right_o - right data output bus
  
# License
  
[MIT](./LICENSE "License Description")
