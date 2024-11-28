// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module ofifo
  (clk, in, out, rd, wr, o_full, reset, o_ready, o_valid);

  parameter col  = 8;
  parameter bw = 4;
  parameter psum_bw = 16;

  input  clk;
  input  wr;
  input  rd;
  input  reset;
  input  [col*psum_bw-1:0] in;
  output [col*psum_bw-1:0] out;
  output o_full;
  output o_ready;
  output o_valid;

  wire [col-1:0] empty;
  wire [col-1:0] full;
  reg  [col-1:0] wr_en;
  reg [col*psum_bw-1:0] in_buffer;

  wire wr_aux;
  genvar i;

  assign o_ready = !o_full;
  assign o_full  = |full;
  assign o_valid = wr_en[col-1];

  parameter IDLE = 2'b00;
  parameter W_BUFF = 2'b01;
  parameter W_MAIN = 2'b10;
  parameter W_LAST = 2'b11;

  reg rd_buff, rd_buff_nxt;
  reg wr_main, wr_main_nxt;
  reg [1:0] state, state_nxt;
  reg [3:0] cnt, cnt_nxt;
  wire [72:0]  out_comp;
  wire [127:0] out_decomp;
  wire [72:0] in_main, out_main;
  wire [54:0] in_aux, out_aux;
  wire doable_w, doable_r;
  wire [127:0] out_temp;
  reg  [7:0] cnt_c_nxt, cnt_c;
 
  reg [127:0] fifo_0, fifo_0_nxt;
  reg [111:0] fifo_1, fifo_1_nxt;
  reg [95:0]  fifo_2, fifo_2_nxt;
  reg [79:0]  fifo_3, fifo_3_nxt;
  reg [63:0]  fifo_4, fifo_4_nxt;
  reg [47:0]  fifo_5, fifo_5_nxt;
  reg [31:0]  fifo_6, fifo_6_nxt;
  reg [15:0]  fifo_7, fifo_7_nxt;


  assign out_temp = {fifo_7[15:0], fifo_6[15:0], fifo_5[15:0], fifo_4[15:0], fifo_3[15:0], fifo_2[15:0], fifo_1[15:0], fifo_0[15:0]};
  assign in_main = (doable_w) ? out_comp : out_temp[72:0];
  assign in_aux = out_temp[127:73];
  assign out = (doable_r) ? out_decomp : {out_aux, out_main};
  assign rd_main = rd;
  assign rd_aux = (!rd_main) ? 1'b0: (doable_r) ? 1'b0 : 1'b1;
  assign wr_aux = (doable_w) ? 1'b0 : 1'b1;

  fifo #(.DEPTH(64), .WIDTH(1)) fifo_comp (
	    .rst(reset),
	    .r_clk(clk),
	    .w_clk(clk),
	    .i_read(rd_main),
	    .i_write(wr_main),
	    .i_data(doable_w),
	    .o_data(doable_r),
	    .o_full(),
	    .o_empty()
 	);

  fifo #(.DEPTH(64), .WIDTH(73)) fifo_main (
	    .rst(reset),
	    .r_clk(clk),
	    .w_clk(clk),
	    .i_read(rd_main),
	    .i_write(wr_main),
	    .i_data(in_main),
	    .o_data(out_main),
	    .o_full(),
	    .o_empty()
 	);

  fifo #(.DEPTH(32), .WIDTH(55)) fifo_aux (
	    .rst(reset),
	    .r_clk(clk),
	    .w_clk(clk),
	    .i_read(rd_aux),
	    .i_write(wr_aux),
	    .i_data(in_aux),
	    .o_data(out_aux),
	    .o_full(),
	    .o_empty()
 	);

  compress   compress_inst(.in(out_temp), .out(out_comp), .doable(doable_w));
  decompress decompress_inst(.in(out_main), .out(out_decomp));
  
  always @ (*) begin
     if (wr_en[0]) fifo_0_nxt = {in_buffer[15:0], fifo_0[127:16]};
     else          fifo_0_nxt = fifo_0;
     if (wr_en[1]) fifo_1_nxt = {in_buffer[31:16], fifo_1[111:16]};
     else          fifo_1_nxt = fifo_1;
     if (wr_en[2]) fifo_2_nxt = {in_buffer[47:32], fifo_2[95:16]};
     else          fifo_2_nxt = fifo_2;
     if (wr_en[3]) fifo_3_nxt = {in_buffer[63:48], fifo_3[79:16]};
     else          fifo_3_nxt = fifo_3;
     if (wr_en[4]) fifo_4_nxt = {in_buffer[79:64], fifo_4[63:16]};
     else          fifo_4_nxt = fifo_4;
     if (wr_en[5]) fifo_5_nxt = {in_buffer[95:80], fifo_5[47:16]};
     else          fifo_5_nxt = fifo_5;
     if (wr_en[6]) fifo_6_nxt = {in_buffer[111:96], fifo_6[31:16]};
     else          fifo_6_nxt = fifo_6;
     if (wr_en[7]) fifo_7_nxt = {in_buffer[127:112]};
     else          fifo_7_nxt = fifo_7;
  end

  always @(*) begin
    if (wr_main && !doable_w) cnt_c_nxt = cnt_c + 1;
    else                      cnt_c_nxt = cnt_c;
    case(state)
      IDLE: begin
        if (wr) begin
          state_nxt = W_BUFF;
          cnt_nxt = 4'd0;
	  cnt_c_nxt = 0;
        end
        else begin
          state_nxt = state;
          cnt_nxt = 4'd0;
        end
      end
      W_BUFF: begin
        if (cnt == 4'd7) begin
          state_nxt = W_MAIN;
          cnt_nxt = 4'd0;
	  wr_main_nxt = 1'b1;
        end
        else begin
          state_nxt = state;
          cnt_nxt = cnt + 4'd1;
	  wr_main_nxt = 1'b0;
        end
      end
      W_MAIN: begin
	wr_main_nxt = 1'b1;
	cnt_nxt = cnt;
        if (!wr) begin
          state_nxt = W_LAST;
        end
        else begin
          state_nxt = state;
        end
      end
      W_LAST: begin
        if (cnt > 7) begin
          state_nxt = IDLE;
	  wr_main_nxt = 1'b0;
	  cnt_nxt = 0;
        end
        else begin
          state_nxt = state;
	  wr_main_nxt = 1'b1;
	  cnt_nxt = cnt + 1;
        end
      end
    endcase
  end

  always @ (posedge clk) begin
    if (reset) begin
      wr_en <= 0;
      in_buffer <= 0;
      fifo_0 <= 0;
      fifo_1 <= 0;
      fifo_2 <= 0;
      fifo_3 <= 0;
      fifo_4 <= 0;
      fifo_5 <= 0;
      fifo_6 <= 0;
      fifo_7 <= 0;
      wr_main <= 0;
      state <= IDLE;
      cnt <= 0;
      cnt_c <= 0;
    end
    else begin
      in_buffer <= in;
      if(wr) wr_en <= {wr_en[col-2:0], 1'b1};
      else   wr_en <= {wr_en[col-2:0], 1'b0};
      fifo_0 <= fifo_0_nxt;
      fifo_1 <= fifo_1_nxt;
      fifo_2 <= fifo_2_nxt;
      fifo_3 <= fifo_3_nxt;
      fifo_4 <= fifo_4_nxt;
      fifo_5 <= fifo_5_nxt;
      fifo_6 <= fifo_6_nxt;
      fifo_7 <= fifo_7_nxt;
      wr_main <= wr_main_nxt;     
      state <= state_nxt;
      cnt <= cnt_nxt;
      cnt_c <= cnt_c_nxt;
    end
  end


 

endmodule
