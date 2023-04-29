// Aline de Brito das Neves; 120210474.
// Roteiro 4 - questão 3

parameter divide_by=200000000;  // divisor do clock de referência
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

logic reset, in_bit, out_bit;
  
  always_comb reset <= SWI[0];
  always_comb in_bit <= SWI[1];
	
  enum logic [4:0] { estado_inicial, primeiro_um, primeiro_zero, segundo_um, terceiro_um }  state;

  always_ff @ (posedge clk_2)
    if (reset) state <= estado_inicial;
    else
		unique case (state)
			estado_inicial:
				if (in_bit == 0)
					state <= estado_inicial;
				else 
					state <= primeiro_um;
			primeiro_um:
				if (in_bit == 0)
					state <= primeiro_zero;
				else
					state <= estado_inicial;
			primeiro_zero:
				if (in_bit == 0)
					state <= estado_inicial;
				else
					state <= segundo_um;
			segundo_um:
				if (in_bit == 0)
					state <= estado_inicial;
				else
					state <= terceiro_um;
			terceiro_um:
				if (in_bit == 0)
					state <= estado_inicial;
				else
					state <= primeiro_um;

		endcase

  always_comb out_bit <= (state == terceiro_um);

  
  always_comb LED[0] <= clk_2;      
  always_comb LED[7] <= out_bit;

endmodule