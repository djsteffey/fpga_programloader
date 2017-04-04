# Clock signal
# Uncomment the next two lines to use the clock (100 MHz / 10 ns)
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clock }];
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clock }]; # Sch name = CLK100MHZ

# CPU reset button
#set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports { reset }];

#7 segment display
set_property -dict { PACKAGE_PIN L3   IOSTANDARD LVCMOS33 } [get_ports { segments[7] }]; #IO_L24N_T3_A00_D16_14 Sch=ca
set_property -dict { PACKAGE_PIN N1   IOSTANDARD LVCMOS33 } [get_ports { segments[6] }]; #IO_25_14 Sch=cb
set_property -dict { PACKAGE_PIN L5   IOSTANDARD LVCMOS33 } [get_ports { segments[5] }]; #IO_25_15 Sch=cc
set_property -dict { PACKAGE_PIN L4   IOSTANDARD LVCMOS33 } [get_ports { segments[4] }]; #IO_L17P_T2_A26_15 Sch=cd
set_property -dict { PACKAGE_PIN K3   IOSTANDARD LVCMOS33 } [get_ports { segments[3] }]; #IO_L13P_T2_MRCC_14 Sch=ce
set_property -dict { PACKAGE_PIN M2   IOSTANDARD LVCMOS33 } [get_ports { segments[2] }]; #IO_L19P_T3_A10_D26_14 Sch=cf
set_property -dict { PACKAGE_PIN L6   IOSTANDARD LVCMOS33 } [get_ports { segments[1] }]; #IO_L4P_T0_D04_14 Sch=cg
set_property -dict { PACKAGE_PIN M4   IOSTANDARD LVCMOS33 } [get_ports { segments[0] }]; #IO_L19N_T3_A21_VREF_15 Sch=dp
set_property -dict { PACKAGE_PIN N6   IOSTANDARD LVCMOS33 } [get_ports { digitselect[0] }]; #IO_L23P_T3_FOE_B_15 Sch=an[0]
set_property -dict { PACKAGE_PIN M6   IOSTANDARD LVCMOS33 } [get_ports { digitselect[1] }]; #IO_L23N_T3_FWE_B_15 Sch=an[1]
set_property -dict { PACKAGE_PIN M3   IOSTANDARD LVCMOS33 } [get_ports { digitselect[2] }]; #IO_L24P_T3_A01_D17_14 Sch=an[2]
set_property -dict { PACKAGE_PIN N5   IOSTANDARD LVCMOS33 } [get_ports { digitselect[3] }]; #IO_L19P_T3_A22_15 Sch=an[3]
set_property -dict { PACKAGE_PIN N2   IOSTANDARD LVCMOS33 } [get_ports { digitselect[4] }]; #IO_L8N_T1_D12_14 Sch=an[4]
set_property -dict { PACKAGE_PIN N4   IOSTANDARD LVCMOS33 } [get_ports { digitselect[5] }]; #IO_L14P_T2_SRCC_14 Sch=an[5]
set_property -dict { PACKAGE_PIN L1   IOSTANDARD LVCMOS33 } [get_ports { digitselect[6] }]; #IO_L23P_T3_35 Sch=an[6]
set_property -dict { PACKAGE_PIN M1   IOSTANDARD LVCMOS33 } [get_ports { digitselect[7] }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]

# microphone
set_property -dict { PACKAGE_PIN J5   IOSTANDARD LVCMOS33 } [get_ports { MICROPHONE_CLOCK }];
set_property -dict { PACKAGE_PIN H5   IOSTANDARD LVCMOS33 } [get_ports { MICROPHONE_DATA }];
set_property -dict { PACKAGE_PIN F5   IOSTANDARD LVCMOS33 } [get_ports { MICROPHONE_LRSELECT }];

# USB/UART
set_property -dict { PACKAGE_PIN D4   IOSTANDARD LVCMOS33 } [get_ports { UART_TX }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]
set_property -dict { PACKAGE_PIN C4   IOSTANDARD LVCMOS33 } [get_ports { UART_RX }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]
set_property -dict { PACKAGE_PIN D3   IOSTANDARD LVCMOS33 } [get_ports { UART_RTR }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]
set_property -dict { PACKAGE_PIN E5   IOSTANDARD LVCMOS33 } [get_ports { UART_CTS }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]

# swiches
set_property -dict { PACKAGE_PIN U9   IOSTANDARD LVCMOS33 } [get_ports { SWITCHES[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports { SWITCHES[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN R7   IOSTANDARD LVCMOS33 } [get_ports { SWITCHES[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
set_property -dict { PACKAGE_PIN R6   IOSTANDARD LVCMOS33 } [get_ports { SWITCHES[3] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]

# mouse/keyboard
set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33  PULLUP true} [get_ports { PS2_CLOCK }];
set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33  PULLUP true} [get_ports { PS2_DATA }];

#Accelerometer
set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports { aclMISO }];
set_property -dict { PACKAGE_PIN B14   IOSTANDARD LVCMOS33 } [get_ports { aclMOSI }];
set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { aclSCK }];
set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { aclSS }];

# audio
#set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports { AUD_PWM }];
#set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports { AUD_EN }];

# onboard buttons
set_property -dict { PACKAGE_PIN T16  IOSTANDARD LVCMOS33 } [get_ports { BTNL }];
set_property -dict { PACKAGE_PIN R10  IOSTANDARD LVCMOS33 } [get_ports { BTNR }];
set_property -dict { PACKAGE_PIN F15  IOSTANDARD LVCMOS33 } [get_ports { BTNU }];
set_property -dict { PACKAGE_PIN V10  IOSTANDARD LVCMOS33 } [get_ports { BTND }];
set_property -dict { PACKAGE_PIN E16  IOSTANDARD LVCMOS33 } [get_ports { BTNC }];