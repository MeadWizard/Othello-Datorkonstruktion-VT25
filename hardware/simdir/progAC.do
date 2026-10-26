vcom "+acc" ../awesomecomputer.vhd 
vcom "+acc" ../ALU/ALU.vhd 
vcom "+acc" ../CU/ControlUnit.vhd 
vcom "+acc" ../DM/DM.vhd 
vcom "+acc" ../Keyboard/KB_encoder.vhd 
vcom "+acc" ../PipeCPU/pipeCPU.vhd 
vcom "+acc" ../PM/PM.vhd 
vcom "+acc" ../RM/RM.vhd 
vcom "+acc" ../VGA/VGA.vhd 
vcom "+acc" ../VGA/char_rom.vhd	 

vcom "+acc" ../awesomecomputer_tb.vhd
vsim awesomecomputer_tb

add wave {sim:/awesomecomputer_tb/U0/U2/clk }
add wave {sim:/awesomecomputer_tb/U0/U2/rst }

add wave -hex -color Coral {sim:/awesomecomputer_tb/U0/U2/PMdata_out }
add wave -hex -color Coral {sim:/awesomecomputer_tb/U0/U2/IR1 }
add wave -dec -color Coral {sim:/awesomecomputer_tb/U0/U2/IR1_k }
add wave -dec -color Coral {sim:/awesomecomputer_tb/U0/U2/digitC }
add wave -hex {sim:/awesomecomputer_tb/U0/U2/IR1_op }
add wave -hex -color Coral {sim:/awesomecomputer_tb/U0/U2/IR2 }
add wave -dec -color Coral {sim:/awesomecomputer_tb/U0/U2/IR2_k }
add wave -hex {sim:/awesomecomputer_tb/U0/U2/IR2_op }

add wave -dec -color Magenta {sim:/awesomecomputer_tb/U0/U2/pm_addr }
add wave -dec -color Magenta {sim:/awesomecomputer_tb/U0/U2/PC }
add wave -dec {sim:/awesomecomputer_tb/U0/U2/PC1 }
add wave -dec {sim:/awesomecomputer_tb/U0/U2/PC2 }
add wave {sim:/awesomecomputer_tb/U0/U2/jump_condition1 }
add wave {sim:/awesomecomputer_tb/U0/U2/jump_condition2 }

add wave {sim:/awesomecomputer_tb/U0/U2/alu_Z }
add wave {sim:/awesomecomputer_tb/U0/U2/flag_Z }
add wave {sim:/awesomecomputer_tb/U0/U2/dm_we }
add wave {sim:/awesomecomputer_tb/U0/U1/dm }

add wave -color Blue {sim:/awesomecomputer_tb/U0/U1/cpu_din}
add wave -color Blue {sim:/awesomecomputer_tb/U0/U1/cpu_we}
add wave -color Blue {sim:/awesomecomputer_tb/U0/U1/cpu_dout}
add wave -color Blue {sim:/awesomecomputer_tb/U0/U1/Z2}

add wave -color Yellow {sim:/awesomecomputer_tb/U0/U2/U2/RM}

add wave -color Blue {sim:/awesomecomputer_tb/U0/U2/U4/D2}
add wave -color Yellow {sim:/awesomecomputer_tb/U0/U2/U2/data_in}



add wave -color Yellow {sim:/awesomecomputer_tb/U0/U2/cu_result_signal}
add wave {sim:/awesomecomputer_tb/U0/U2/U3/RM_write_enable}
add wave -color Yellow {sim:/awesomecomputer_tb/U0/U2/U2/regA_out}
add wave -color Yellow {sim:/awesomecomputer_tb/U0/U2/U2/regB_out}

add wave -color Magenta {sim:/awesomecomputer_tb/U0/U1/mux_addr_signal}
add wave -color Magenta {sim:/awesomecomputer_tb/U0/U1/cpu_addr_imm}
add wave -color Magenta {sim:/awesomecomputer_tb/U0/U1/Z2b}

restart -f
run 1000 ns