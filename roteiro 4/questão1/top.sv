// Aline de Brito das Neves; 120210474.
// Roteiro 4 - questão 1

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

//Registrado 4bit
  parameter NBITS_DATA = 4;
  logic [NBITS_DATA-1:0] paralelo, saida;
  logic reset;
  logic selecao;
  logic serial;
  
  always_comb reset <= SWI[0];
  always_comb selecao <= SWI[2];
  always_comb serial <= SWI[1];
  always_comb paralelo <= SWI[7:4];
  
  always_ff @(posedge reset or posedge clk_2) begin
    if(reset) begin
        saida <= 0;
        end
    else 
        if (selecao) //serial 
            begin
                saida[3] <= serial;
                saida[2] <= saida[3];
                saida[1] <= saida[2];
                saida[0] <= saida[1];
            end
        else //paralelo
            saida <= paralelo;
  end
  
  always_comb LED[0] <= clk_2;  
  always_comb LED[7:4] <= saida;
  
  //Display de 7 segmentos
always_comb case(saida) 
      4'b0000: SEG <= 'b00111111;
      4'b0001: SEG <= 'b00000110; 
      4'b0010: SEG <= 'b01011011; 
      4'b0011: SEG <= 'b01001111; 
      4'b0100: SEG <= 'b01100110; 
      4'b0101: SEG <= 'b01101101; 
      4'b0110: SEG <= 'b01111101;
      4'b0111: SEG <= 'b00000111; 
      4'b1000: SEG <= 'b01111111; 
      4'b1001: SEG <= 'b01101111;  
      4'b1010: SEG <= 'b01110111; 
      4'b1011: SEG <= 'b01111100; 
      4'b1100: SEG <= 'b00111001; 
      4'b1101: SEG <= 'b01011110;
      4'b1110: SEG <= 'b01111001;
      4'b1111: SEG <= 'b01110001; 
    endcase

endmodule