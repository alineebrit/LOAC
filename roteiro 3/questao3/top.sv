// Aline de Brito das Neves; 120210474.
// Roteiro 3 - questão 3

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
  // Variáveis
    logic signed [2:0] SAIDA;
    logic signed [2:0] A;
    logic signed [2:0] B;
    logic [1:0] SELECAO;
  always_comb
    begin
        A <= SWI[7:5];
        SELECAO <= SWI[4:3];
        B <= SWI[2:0];
    end

// Tipos de saida
  always_comb begin
    case(SELECAO)
      2'b00: begin
        SAIDA <= A & B;
        LED [2:0] <= SAIDA;
        LED[7] <= 0;
      end

      2'b01: begin 
        SAIDA <= A | B;
        LED[7] <= 0;
        LED [2:0] <= SAIDA;
      end

      2'b10: begin 
        SAIDA <= A + B;
        LED [2:0] <= SAIDA;
        if (A + B > 3 | A + B < -4) 
          LED[7] <= 1;
        else 
          LED[7] <= 0;
      end

      2'b11: begin
        SAIDA <= A - B;
        LED [2:0] <= SAIDA;
        if (A - B > 3 | A - B < -4) 
          LED[7] <= 1;

        else 
          LED[7] <= 0;
      end
    endcase
    // Display de 7 segmentos
    case(SAIDA)
        0: SEG[7:0] <= 'b00111111;
        1: SEG[7:0] <= 'b00000110;
        2: SEG[7:0] <= 'b01011011;
        3: SEG[7:0] <= 'b01001111;
        -1: SEG[7:0] <= 'b10000110;
        -2: SEG[7:0] <= 'b11011011;
        -3: SEG[7:0] <= 'b11001111;
      -4: SEG[7:0] <= 'b11100110;
    endcase
  end

endmodule