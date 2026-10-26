vcom "+acc" ../../ALU/ALU.vhd 
vcom "+acc" ../../CU/ControlUnit.vhd 
vcom "+acc" ../pipeCPU.vhd 
vcom "+acc" ../../PM/PM.vhd 
vcom "+acc" ../../RM/RM.vhd 

vcom "+acc" ../pipeCPU_tb.vhd
vsim pipeCPU_tb

add wave {sim:/pipeCPU_tb/UUT/clk }
add wave {sim:/pipeCPU_tb/UUT/rst }

add wave -hex -color Magenta {sim:/pipeCPU_tb/UUT/keyboard_interrupt }
add wave -color Magenta {sim:/pipeCPU_tb/UUT/keyboard_input }

add wave -dec -color Yellow {sim:/pipeCPU_tb/UUT/U2/RM }
add wave {sim:/pipeCPU_tb/UUT/flag_I }
add wave -dec -color Coral {sim:/pipeCPU_tb/UUT/PC }
add wave -dec {sim:/pipeCPU_tb/UUT/PC1 }
add wave -dec {sim:/pipeCPU_tb/UUT/PC2 }

add wave -hex -color Blue {sim:/pipeCPU_tb/UUT/IR1}
add wave -color Blue {sim:/pipeCPU_tb/UUT/IR1_op}
add wave -hex -color Blue {sim:/pipeCPU_tb/UUT/IR2}
add wave -color Blue {sim:/pipeCPU_tb/UUT/IR2_op}
add wave -color Yellow {sim:/pipeCPU_tb/UUT/jump_condition1}
add wave -color Yellow {sim:/pipeCPU_tb/UUT/jump_condition2}



restart -f
run 500 ns