// Aline de Brito das Neves; 120210474.
// Roteiro 5 - questão 2
// Contador síncrono 

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

    parameter NUMERO_DE_BITS = 4;
    logic [NUMERO_DE_BITS-1:0] contador;
    logic reset, load;
    
    always_comb reset <= SWI[0];
    always_comb load <= SWI[3];
        
    always_ff @(posedge clk_2) begin
        if(reset)
            contador <= 1;
        else if (load)
            contador <= 1;
        else
            if(contador[NUMERO_DE_BITS-1]) contador <= 1; 
            else contador <= contador << 1; 
    end
    
    always_comb begin 
        LED[0] <= clk_2;      
        LED[7:4] <= contador;
    
        //Display de 7 segmentos
        unique case(contador) 
            1: SEG <= 'b00000110; 
            2: SEG <= 'b01011011; 
            4: SEG <= 'b01100110; 
            8: SEG <= 'b01111111; 
        
        endcase
    end
endmodule

