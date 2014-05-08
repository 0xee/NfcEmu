## Generated SDC file "TbdNfcEmu.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Thu Sep 12 18:04:49 2013"

##
## DEVICE  "EP2C5T144C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {Fx2Clk} -period 20.833 -waveform { 0.000 10.416 } [get_ports {iFx2Clk}]
create_clock -name {Xtal2Clk} -period 73.746 -waveform { 0.000 36.873 } [get_ports {iXtal2Clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {AdcClk} -source [get_pins {nfc_pll_1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 8 -master_clock {Xtal2Clk} [get_pins {nfc_pll_1|altpll_component|pll|clk[0]}] 

create_generated_clock -name {NfcClk} -source [get_pins {nfc_pll_1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 3 -master_clock {Xtal2Clk} [get_pins {nfc_pll_1|altpll_component|pll|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************


#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {AdcClk}]  -to  [get_clocks {NfcClk}]
set_false_path  -from  [get_clocks {NfcClk}]  -to  [get_clocks {Fx2Clk}]
set_false_path  -from  [get_clocks {Fx2Clk}]  -to  [get_clocks {NfcClk}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

#specify the maximum external clock delay from the external device
set CLKs_max 0.300

#specify the minimum external clock delay from the external device
set CLKs_min 0.250

#specify the maximum external clock delay to the FPGA
set CLKd_max 0.000

#specify the minimum external clock delay to the FPGA
set CLKd_min -0.100

#specify the maximum clock-to-out of the external device
set tCO_max 5.100

#specify the minimum clock-to-out of the external device
set tCO_min 2.4

#specify the maximum board delay
set BD_max 0.180

#specify the minimum board delay
set BD_min 0.120

#create the input maximum delay for the data input to the FPGA that
#accounts for all delays specified
set_input_delay -clock AdcClk \
-max [expr $CLKs_max + $tCO_max + $BD_max - $CLKd_min] \
[get_ports {iAdc1Data[*]}]

#create the input minimum delay for the data input to the FPGA that

#accounts for all delays specified
set_input_delay -clock AdcClk \
-min [expr $CLKs_min + $tCO_min + $BD_min - $CLKd_max] \
[get_ports {iAdc1Data[*]}]
