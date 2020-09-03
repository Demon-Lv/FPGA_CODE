#Setup.tcl 
# Setup pin setting for EP2C5_ board 
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED" 
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF 

set_location_assignment PIN_23 -to CLK_50M

set_location_assignment PIN_51 -to LED[8]
set_location_assignment PIN_49 -to LED[7]
set_location_assignment PIN_44 -to LED[6]
set_location_assignment PIN_42 -to LED[5]
set_location_assignment PIN_38 -to LED[4]
set_location_assignment PIN_33 -to LED[3]
set_location_assignment PIN_31 -to LED[2]
set_location_assignment PIN_28 -to LED[1]


set_location_assignment PIN_52 -to BUT[7]
set_location_assignment PIN_50 -to BUT[6]
set_location_assignment PIN_46 -to BUT[5]
set_location_assignment PIN_43 -to BUT[4]
set_location_assignment PIN_39 -to BUT[3]
set_location_assignment PIN_34 -to BUT[2]
set_location_assignment PIN_32 -to BUT[1]
set_location_assignment PIN_30 -to Rst_n



set_location_assignment PIN_144 -to SEG_LED[0]
set_location_assignment PIN_143 -to SEG_LED[1]
set_location_assignment PIN_142 -to SEG_LED[2]
set_location_assignment PIN_141 -to SEG_LED[3]
set_location_assignment PIN_138 -to SEG_LED[4]
set_location_assignment PIN_137 -to SEG_LED[5]
set_location_assignment PIN_136 -to SEG_LED[6]
set_location_assignment PIN_135 -to SEG_LED[7]

set_location_assignment PIN_133 -to SEG_NCS[6]
set_location_assignment PIN_132 -to SEG_NCS[5]
set_location_assignment PIN_129 -to SEG_NCS[4]
set_location_assignment PIN_3 -to SEG_NCS[3]
set_location_assignment PIN_2 -to SEG_NCS[2]
set_location_assignment PIN_1 -to SEG_NCS[1]