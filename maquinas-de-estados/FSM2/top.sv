// TESTE

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

// Projetar um detector de sequência de dois bits consecutivos iguais
//a 0 ou 1 em um sinal serial.

  logic reset, in_bit, out_bit;
  
  always_comb reset <= SWI[0];
  always_comb in_bit <= SWI[4];
	
  enum logic [2:0] { reset_state, read_1_zero, read_1_one, read_2_zero, read_2_one }  state;

  always_ff @ (posedge clk_2)
    if (reset) state <= reset_state;
    else
		unique case (state)
			reset_state:
				if (in_bit == 0)
					state <= read_1_zero;
				else 
					state <= read_1_one;
			read_1_zero:
				if (in_bit == 0)
					state <= read_2_zero;
				else
					state <= read_1_one;
			read_2_zero:
				if (in_bit == 0)
					state <= read_2_zero;
				else
					state <= read_1_one;
			read_1_one:
				if (in_bit == 0)
					state <= read_1_zero;
				else
					state <= read_2_one;
						read_2_one:
				if (in_bit == 0)
					state <= read_1_zero;
				else
					state <= read_2_one;

		endcase

  always_comb out_bit <= (state == read_2_zero) || (state == read_2_one);

  
  always_comb LED[0] <= clk_2;      
  always_comb LED[7] <= out_bit;

endmodule