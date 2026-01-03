module control_unit(opcode,funct3,funct7,zero,Pc_src,Result_src,mem_write,reg_write,ALU_control,ALU_src,imm_select,branch,JAL,JALR,loadwidth,loadunsigned);

input [6:0] opcode;
input [2:0] funct3;
input [6:0] funct7;
input zero;

output reg [1:0] Pc_src;
output reg [1:0] Result_src;
output reg mem_write;
output reg reg_write;
output reg [3:0] ALU_control;
output reg ALU_src;
output reg [2:0] imm_select;
output reg branch;
output reg JAL;
output reg JALR;
output reg [1:0] loadwidth;
output reg loadunsigned;

//opcodes
localparam OP_RTYPE  = 7'b0110011;
localparam OP_ITYPE  = 7'b0010011;
localparam OP_LOAD   = 7'b0000011;
localparam OP_STORE  = 7'b0100011;
localparam OP_LUI    = 7'b0110111;
localparam OP_AUIPC  = 7'b0010111;
localparam OP_BRANCH = 7'b1100011;
localparam OP_JAL    = 7'b1101111;
localparam OP_JALR   = 7'b1100111;

//ALU ENCODING

localparam ALU_ADD  = 4'b0000;
localparam ALU_SUB  = 4'b0001;
localparam ALU_SLL  = 4'b0010;
localparam ALU_SLT  = 4'b0011;
localparam ALU_SLTU = 4'b0100;
localparam ALU_XOR  = 4'b0101;
localparam ALU_SRL  = 4'b0110;
localparam ALU_SRA  = 4'b0111;
localparam ALU_OR   = 4'b1000;
localparam ALU_AND  = 4'b1001;
localparam ALU_PASS = 4'b1010;



always @(*) begin
    //default values
    Pc_src       = 0;
    Result_src   = 2'b00;
    mem_write    = 0;
    reg_write    = 0;
    ALU_control  = ALU_ADD;
    ALU_src      = 0;
    imm_select   = 3'b000;
    branch       = 0;
    JAL          = 0;
    JALR         = 0;
    loadwidth    = 2'b10;
    loadunsigned = 0;    

case(opcode)
     OP_RTYPE: begin
        reg_write = 1;

        case (funct3)
            3'b000: begin
                 if (funct7 == 7'b0000000)
                        ALU_control = ALU_ADD;
                  else if (funct7 == 7'b0100000)
                        ALU_control = ALU_SUB;
            end
            3'b001: ALU_control = ALU_SLL;
            3'b010: ALU_control = ALU_SLT;
            3'b011: ALU_control = ALU_SLTU;
            3'b100: ALU_control = ALU_XOR;
            3'b101:begin
                 if (funct7 == 7'b0000000)
                        ALU_control = ALU_SRL;
                  else if (funct7 == 7'b0100000)
                        ALU_control = ALU_SRA;
            end
            3'b110: ALU_control = ALU_OR;
            3'b111: ALU_control = ALU_AND;
        endcase
     end
     OP_ITYPE: begin
        reg_write = 1;
        ALU_src   = 1;
        imm_select = 3'b000;
        case (funct3)
            3'b000: ALU_control = ALU_ADD;
            3'b001: ALU_control = ALU_SLL;
            3'b010: ALU_control = ALU_SLT;
            3'b011: ALU_control = ALU_SLTU;
            3'b100: ALU_control = ALU_XOR;
            3'b110: ALU_control = ALU_OR;
            3'b111: ALU_control = ALU_AND;
            3'b101: begin
                if (funct7 == 7'b0000000)
                    ALU_control = ALU_SRL;
                else if (funct7 == 7'b0100000)
                    ALU_control = ALU_SRA;
            end
            default: ALU_control = ALU_ADD;
        endcase
     end

     OP_LOAD: begin
        reg_write    =1'b1;
        ALU_src      =1'b1;
        imm_select   =3'b000;
        Result_src   =2'b01;
        case (funct3)
            3'b000: begin
                loadwidth    = 2'b00; //LB
                loadunsigned = 0;
            end
             3'b001: begin
                loadwidth    = 2'b01; //LH
                loadunsigned = 0;
            end
             3'b010: begin
                loadwidth    = 2'b10; //LW
                loadunsigned = 0;
            end
             3'b100: begin
                loadwidth    = 2'b00; //LB
                loadunsigned = 1;
            end
             3'b101: begin
                loadwidth    = 2'b01; //LH
                loadunsigned = 1;
            end
                default: begin
                    loadwidth    = 2'b10; //LW
                    loadunsigned = 0;
                end
        endcase
     end

        OP_STORE: begin
            mem_write  = 1'b1;
            ALU_src    = 1'b1;
            imm_select = 3'b001;

            case (funct3)
                3'b000: loadwidth = 2'b00;
                3'b001: loadwidth = 2'b01;
                3'b010: loadwidth = 2'b10;
                default: loadwidth = 2'b10;
            endcase
        end

        OP_LUI: begin
            reg_write  = 1'b1;
            ALU_src    = 1'b1;
            imm_select = 3'b011;
            ALU_control = ALU_PASS;
            Result_src = 2'b11;
        end

        OP_AUIPC: begin
            reg_write   = 1'b1;
            ALU_src     = 1'b1;
            imm_select  = 3'b011;
            ALU_control = ALU_ADD;
            Result_src  = 2'b11;
        end

        OP_BRANCH: begin
            branch      = 1'b1;
            imm_select  = 3'b010;
            ALU_control = ALU_SUB;
            ALU_src     = 1'b0;
            Pc_src      = 1'b0;
        end

        OP_JAL: begin
            reg_write  = 1'b1;
            JAL        = 1'b1;
            Pc_src     = 2'b10;
            imm_select = 3'b100;
            Result_src = 2'b10;
        end

        OP_JALR: begin
            reg_write  = 1'b1;
            JALR       = 1'b1;
            Pc_src     = 2'b10;
            ALU_src    = 1'b1;
            imm_select = 3'b000;
            Result_src = 2'b10;
        end
          default: begin
            // Unknown opcode: keep defaults (no writes)
        end
endcase
end