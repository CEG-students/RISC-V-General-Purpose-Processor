module datamem (
    input  wire        clk,
    input  wire [31:0] address,
    input  wire        write_en,
    input  wire [2:0]  func3,
    input  wire [31:0] data_in,
    output reg  [31:0] data_out
);

    // 32-bit word-addressed RAM (1024 words = 4 KB)
    reg [31:0] ram [0:1023];

    wire [9:0] word_addr = address[11:2];   // word index
    wire [1:0] byte_sel  = address[1:0];    // byte select

    wire [31:0] word = ram[word_addr];      // ASYNC READ (key point)

    // ---------------- WRITE (sync) ----------------
    always @(posedge clk) begin
        if (write_en && !address[31:12]) begin
            case (func3)

                // SB
                3'b000: begin
                    case (byte_sel)
                        2'b00: ram[word_addr][7:0]   <= data_in[7:0];
                        2'b01: ram[word_addr][15:8]  <= data_in[7:0];
                        2'b10: ram[word_addr][23:16] <= data_in[7:0];
                        2'b11: ram[word_addr][31:24] <= data_in[7:0];
                    endcase
                end

                // SH
                3'b001: begin
                    if (!byte_sel[0]) begin
                        ram[word_addr][15:0]  <= data_in[15:0];
                    end else begin
                        ram[word_addr][31:16] <= data_in[15:0];
                    end
                end

                // SW
                3'b010: begin
                    ram[word_addr] <= data_in;
                end

            endcase
        end
    end

    // ---------------- READ (ASYNC) ----------------
    always @(*) begin
		

		if (!write_en && !address[31:12]) begin
			case (func3)

				// LB
				3'b000: begin
					case (byte_sel)
						2'b00: data_out = {{24{word[7]}},   word[7:0]};
						2'b01: data_out = {{24{word[15]}},  word[15:8]};
						2'b10: data_out = {{24{word[23]}},  word[23:16]};
						2'b11: data_out = {{24{word[31]}},  word[31:24]};
					endcase
				end

				// LH
				3'b001: begin
					case (byte_sel[0])
						1'b0: data_out = {{16{word[15]}}, word[15:0]};
						1'b1: data_out = {{16{word[31]}}, word[31:16]};
					endcase
				end

				// LW
				3'b010: data_out = word;

				// LBU
				3'b100: begin
					case (byte_sel)
						2'b00: data_out = {24'b0, word[7:0]};
						2'b01: data_out = {24'b0, word[15:8]};
						2'b10: data_out = {24'b0, word[23:16]};
						2'b11: data_out = {24'b0, word[31:24]};
					endcase
				end

				// LHU 
				3'b101: begin
					case (byte_sel[0])
						1'b0: data_out = {16'b0, word[15:0]};
						1'b1: data_out = {16'b0, word[31:16]};
					endcase
				end

			endcase
		end
	end
endmodule
