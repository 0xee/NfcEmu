module dacctrl(clk, ADC_DACCTRL);
   

  input clk;
  output ADC_DACCTRL;
   


// Minimal ADC DAC-control logic
// Required with some revisions of Flashy that don't work if the DAC is not set to a minimum value
// See the Flashy documentation for more details
wire [7:0] DAC_regdata[3:0] /* synthesis keep */; 
assign DAC_regdata[0] = 8'b11000000;  // minimum values (corresponds to maximum vertical pos + maximum range)
assign DAC_regdata[1] = 8'b10000000;
assign DAC_regdata[2] = 8'b11000000;
assign DAC_regdata[3] = 8'b10000000;
parameter psdac = 8;
reg [psdac+9:0] DAC_cnt /* synthesis keep */;


initial DAC_cnt = 0;
   
  always @(posedge clk) DAC_cnt <= DAC_cnt + 1;
wire [15:0] DAC_data = {5'b11111, DAC_cnt[psdac+9:psdac+8], 1'b1, DAC_regdata[DAC_cnt[psdac+9:psdac+8]]} /* synthesis keep */;
reg ADC_DACCTRL; always @(posedge clk) ADC_DACCTRL <= &DAC_cnt[psdac+7:psdac+5] & (&DAC_cnt[psdac:1] ? ~DAC_cnt[0] : DAC_data[~DAC_cnt[psdac+4:psdac+1]]);

endmodule // ADC_DACCTRL


module dacctrl_tb;
   
   reg clk, ctrl;
   
   dacctrl theDacCtrl(
                      .clk(clk),
                      .ADC_DACCTRL(ctrl));
   
        
   initial begin
      clk = 0;
   end
   
   always #5ns  clk = ~clk;

      
endmodule // tb
   
