module SerialDacV(clk, ADC_DACCTRL, DAC_regdata);
   

  input clk;
  output ADC_DACCTRL;
  input [31:0] DAC_regdata;
   
   


// Minimal ADC DAC-control logic
// Required with some revisions of Flashy that don't work if the DAC is not set to a minimum value
// See the Flashy documentation for more details

parameter psdac = 8;
reg [psdac+9:0] DAC_cnt /* synthesis keep */;


initial DAC_cnt = 0;
   
  always @(posedge clk) DAC_cnt <= DAC_cnt + 1;

   reg [7:0]   currentReg;
   
   
   always @(DAC_regdata or DAC_cnt)
     begin : MUX
        case(DAC_cnt[psdac+9:psdac+8])
          2'b00: currentReg <= DAC_regdata[7:0];
          2'b01: currentReg <= DAC_regdata[15:8];
          2'b10: currentReg <= DAC_regdata[23:16];
          2'b11: currentReg <= DAC_regdata[31:24];
        endcase
     end

   
wire [15:0] DAC_data = {5'b11111, 
                        DAC_cnt[psdac+9:psdac+8],
                        1'b1, 
                        currentReg};
   
   
reg ADC_DACCTRL; always @(posedge clk) ADC_DACCTRL <= &DAC_cnt[psdac+7:psdac+5] & (&DAC_cnt[psdac:1] ? ~DAC_cnt[0] : DAC_data[~DAC_cnt[psdac+4:psdac+1]]);

endmodule // ADC_DACCTRL
   
