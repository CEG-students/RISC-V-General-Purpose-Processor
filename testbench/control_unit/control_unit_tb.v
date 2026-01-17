`timescale 1ns/1ps

module control_unit_tb;

reg [6:0] opcode;
reg [2:0] funct3;
reg [6:0] funct7;
reg zero;

wire [1:0] Pc_src;
wire [1:0] Result_src;
wire mem_write;
wire reg_write;
wire [3:0] ALU_control;
wire ALU_src;
wire [2:0] imm_select;
wire branch;
wire JAL;
wire JALR;
wire [1:0] loadwidth;
wire loadunsigned;

control_unit dut (
    opcode, funct3, funct7, zero,
    Pc_src, Result_src, mem_write, reg_write,
    ALU_control, ALU_src, imm_select,
    branch, JAL, JALR,
    loadwidth, loadunsigned
);

initial begin

    
    opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000; zero = 0; #10;

    funct7 = 7'b0100000; #10;

   
    opcode = 7'b0010011; funct3 = 3'b000; #10;

 
    opcode = 7'b0000011; funct3 = 3'b010; #10;

   
    funct3 = 3'b100; #10;

  
    opcode = 7'b0100011; funct3 = 3'b010; #10;

  
    opcode = 7'b1100011; funct3 = 3'b000; zero = 1; #10;


    funct3 = 3'b001; zero = 0; #10;

  
    opcode = 7'b1101111; #10;


    opcode = 7'b1100111; funct3 = 3'b000; #10;

    
    $finish;
end

endmodule