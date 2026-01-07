`timescale 1ns/1ps

module tb_datamem;

    reg         clk;
    reg  [31:0] address;
    reg         write_en;
    reg  [2:0]  func3;
    reg  [31:0] data_in;
    wire [31:0] data_out;

    // Instantiate DUT
    datamem DUT (
        .clk      (clk),
        .address  (address),
        .write_en (write_en),
        .func3    (func3),
        .data_in  (data_in),
        .data_out (data_out)
    );

    // Clock generation
    always #1 clk = ~clk;

    initial begin
        // Init
        clk      = 0;
        write_en = 0;
        address  = 0;
        func3    = 0;
        data_in  = 0;

        // -----------------------------
        // 1. STORE WORD (SW)
        // -----------------------------
        @(posedge clk);
        address  = 32'h0000_0004;   // word index = 1
        data_in  = 32'hAABB_CCDD;
        func3    = 3'b010;          // SW
        write_en = 1;

        @(posedge clk);
        write_en = 0;

        #1; // async read delay
        $display("SW Read = %h (expected AABBCCDD)", data_out);

        // -----------------------------
        // 2. LOAD WORD (LW)
        // -----------------------------
        func3 = 3'b010;             // LW
        #1.1;
        $display("LW = %h (expected AABBCCDD)", data_out);

        // -----------------------------
        // 3. STORE BYTE (SB) @ byte[1]
        // -----------------------------
        @(posedge clk);
        address  = 32'h0000_0005;   // same word, byte_sel = 01
        data_in  = 32'h0000_00EE;
        func3    = 3'b000;          // SB
        write_en = 1;

        @(posedge clk);
        write_en = 0;
		
		@(posedge clk);
        func3 = 3'b010;             // LW
        $display("After SB = %h (ffffffee)", data_out);

        // -----------------------------
        // 4. LOAD BYTE SIGNED (LB)
        // -----------------------------
		@(posedge clk);
        address = 32'h0000_0005;
        func3   = 3'b000;           // LB
        #1.1;
        $display("LB = %h (expected FFFFFFEE)", data_out);

        // -----------------------------
        // 5. LOAD BYTE UNSIGNED (LBU)
        // -----------------------------
		@(posedge clk);
        func3 = 3'b100;             // LBU
        #1.1;
        $display("LBU = %h (expected 000000EE)", data_out);

        // -----------------------------
        // 6. STORE HALFWORD (SH)
        // -----------------------------
        @(posedge clk);
        address  = 32'h0000_0006;   // halfword upper
        data_in  = 32'h0000_1234;
        func3    = 3'b001;          // SH
        write_en = 1;

        @(posedge clk);
        write_en = 0;

        @(posedge clk);
        func3 = 3'b010;		// LW
		#1.1;
        $display("After SH = %h (expected aabb1234)", data_out);

        // -----------------------------
        // 7. LOAD HALFWORD SIGNED (LH)
        // -----------------------------
		@(posedge clk);
        func3 = 3'b001;             // LH
        #1.1;
        $display("LH = %h", data_out);

        // -----------------------------
        // 8. LOAD HALFWORD UNSIGNED (LHU)
        // -----------------------------
		@(posedge clk);
        func3 = 3'b101;             // LHU
        #1.1;
        $display("LHU = %h", data_out);

        // -----------------------------
        // DONE
        // -----------------------------
        #10;
        $display("TESTBENCH FINISHED");
        $finish;
    end

endmodule
