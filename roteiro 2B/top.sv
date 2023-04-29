// Aline de Brito das Neves, 120210474.
// Roteiro 2B 

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

// questão 1
logic cofre;

logic gerente; 

logic relogio;

always_comb begin

    cofre <= SWI[0];
    relogio <= SWI[1];
    gerente <= SWI[2];

    if (cofre == 1 & relogio == 1 & gerente == 1) 
        LED[1] <= 1;

    else if (cofre == 1 & relogio == 0 & gerente == 1)
        LED[1] <= 1;

    else if (cofre == 1 & relogio == 0 & gerente == 0)
        LED[1] <= 1;

    else 
        LED[1] <= 0;
end

// questão 2
logic sensor1;
logic sensor2;

always_comb begin

    sensor1 <= SWI[6];
    sensor2 <= SWI[7];

    LED[6] <= !sensor1 & !sensor2; // aquecedor
    LED[7] <= sensor1 & sensor2; // resfriador
    SEG[7] <= !sensor1 & sensor2; //alarme

end
endmodule