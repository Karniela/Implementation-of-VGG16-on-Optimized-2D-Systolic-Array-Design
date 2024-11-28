module compress #(
	parameter IN_WIDTH = 128,
	parameter OUT_WIDTH = 73
)
(
	in, 
	out,
	doable
);
	
	input  [IN_WIDTH-1:0] in;
	output [OUT_WIDTH-1:0] out;
	output reg                 doable;

	reg [7:0] comp;
	wire [15:0] org [0:7];

	wire [3:0] count;
	reg [7:0] comped;
	reg [OUT_WIDTH-1:0] out_temp;
	integer i;

	assign count = comped[0] + comped[1] + comped[2] + comped[3] + comped[4] + comped[5] + comped[6] + comped[7];
	// assign doable = (count >= 4'd4) ? 1'b1 : 1'b0;


	assign out = out_temp;

	assign org[0] = in[15:0];
	assign org[1] = in[31:16];
	assign org[2] = in[47:32];
	assign org[3] = in[63:48];
	assign org[4] = in[79:64];
	assign org[5] = in[95:80];
	assign org[6] = in[111:96];
	assign org[7] = in[127:112];

	always @ (*) begin
		case(in[15:0])
			16'h0000: begin comp[0] = 1'b0; comped[0] = 1'b1; end
			16'hFFFF: begin comp[0] = 1'b1; comped[0] = 1'b1; end
			default:  begin comp[0] = 1'b0; comped[0] = 1'b0; end
		endcase
		case(in[31:16])
			16'h0000: begin comp[1] = 1'b0; comped[1] = 1'b1; end
			16'hFFFF: begin comp[1] = 1'b1; comped[1] = 1'b1; end
			default:  begin comp[1] = 1'b0; comped[1] = 1'b0; end
		endcase
		case(in[47:32])
			16'h0000: begin comp[2] = 1'b0; comped[2] = 1'b1; end
			16'hFFFF: begin comp[2] = 1'b1; comped[2] = 1'b1; end
			default:  begin comp[2] = 1'b0; comped[2] = 1'b0; end
		endcase
		case(in[63:48])
			16'h0000: begin comp[3] = 1'b0; comped[3] = 1'b1; end
			16'hFFFF: begin comp[3] = 1'b1; comped[3] = 1'b1; end
			default:  begin comp[3] = 1'b0; comped[3] = 1'b0; end
		endcase
		case(in[79:64])
			16'h0000: begin comp[4] = 1'b0; comped[4] = 1'b1; end
			16'hFFFF: begin comp[4] = 1'b1; comped[4] = 1'b1; end
			default:  begin comp[4] = 1'b0; comped[4] = 1'b0; end
		endcase
		case(in[95:80])
			16'h0000: begin comp[5] = 1'b0; comped[5] = 1'b1; end
			16'hFFFF: begin comp[5] = 1'b1; comped[5] = 1'b1; end
			default:  begin comp[5] = 1'b0; comped[5] = 1'b0; end
		endcase
		case(in[111:96])
			16'h0000: begin comp[6] = 1'b0; comped[6] = 1'b1; end
			16'hFFFF: begin comp[6] = 1'b1; comped[6] = 1'b1; end
			default:  begin comp[6] = 1'b0; comped[6] = 1'b0; end
		endcase
		case(in[127:112])
			16'h0000: begin comp[7] = 1'b0; comped[7] = 1'b1; end
			16'hFFFF: begin comp[7] = 1'b1; comped[7] = 1'b1; end
			default:  begin comp[7] = 1'b0; comped[7] = 1'b0; end
		endcase
	end

	always @ (*) begin
		if (comped[3:0] == 4'b1111)          begin out_temp = {1'b0, org[7], org[6], org[5], org[4], comp[3], comp[2], comp[1], comp[0], 4'b0000}; doable = 1'b1; end 
		else if (comped[4:0] == 5'b11110)    begin out_temp = {1'b0, org[7], org[6], org[5], org[0], comp[4], comp[3], comp[2], comp[1], 4'b0001}; doable = 1'b1; end 
		else if (comped[4:0] == 5'b11101)    begin out_temp = {1'b0, org[7], org[6], org[5], org[1], comp[4], comp[3], comp[2], comp[0], 4'b0010}; doable = 1'b1; end 
		else if (comped[4:0] == 5'b11011)    begin out_temp = {1'b0, org[7], org[6], org[5], org[2], comp[4], comp[3], comp[1], comp[0], 4'b0011}; doable = 1'b1; end 
		else if (comped[4:0] == 5'b10111)    begin out_temp = {1'b0, org[7], org[6], org[5], org[3], comp[4], comp[2], comp[1], comp[0], 4'b0100}; doable = 1'b1; end 
		else if (comped[5:0] == 6'b111100)   begin out_temp = {1'b0, org[7], org[6], org[1], org[0], comp[5], comp[4], comp[3], comp[2], 4'b0101}; doable = 1'b1; end 
		else if (comped[5:0] == 6'b111010)   begin out_temp = {1'b0, org[7], org[6], org[2], org[0], comp[5], comp[4], comp[3], comp[1], 4'b0110}; doable = 1'b1; end
		else if (comped[5:0] == 6'b111001)   begin out_temp = {1'b0, org[7], org[6], org[2], org[1], comp[5], comp[4], comp[3], comp[0], 4'b0111}; doable = 1'b1; end 
		else if (comped[5:0] == 6'b110110)   begin out_temp = {1'b0, org[7], org[6], org[3], org[0], comp[5], comp[4], comp[2], comp[1], 4'b1000}; doable = 1'b1; end 
		else if (comped[5:0] == 6'b110101)   begin out_temp = {1'b0, org[7], org[6], org[3], org[1], comp[5], comp[4], comp[2], comp[0], 4'b1001}; doable = 1'b1; end 
		else if (comped[5:0] == 6'b110011)   begin out_temp = {1'b0, org[7], org[6], org[3], org[2], comp[5], comp[4], comp[1], comp[0], 4'b1010}; doable = 1'b1; end
		else if (comped[5:0] == 6'b101110)   begin out_temp = {1'b0, org[7], org[6], org[4], org[0], comp[5], comp[3], comp[2], comp[1], 4'b1011}; doable = 1'b1; end 
		else if (comped[5:0] == 6'b101101)   begin out_temp = {1'b0, org[7], org[6], org[4], org[1], comp[5], comp[3], comp[2], comp[0], 4'b1100}; doable = 1'b1; end
		else if (comped[5:0] == 6'b101011)   begin out_temp = {1'b0, org[7], org[6], org[4], org[2], comp[5], comp[3], comp[1], comp[0], 4'b1101}; doable = 1'b1; end 
		else if (comped[5:0] == 6'b100111)   begin out_temp = {1'b0, org[7], org[6], org[4], org[3], comp[5], comp[2], comp[1], comp[0], 4'b1110}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1110001)  begin out_temp = {1'b0, org[7], org[3], org[2], org[1], comp[6], comp[5], comp[4], comp[0], 4'b1111}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1110010)  begin out_temp = {1'b1, org[7], org[3], org[2], org[0], comp[6], comp[5], comp[4], comp[1], 4'b0000}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1110100)  begin out_temp = {1'b1, org[7], org[3], org[1], org[0], comp[6], comp[5], comp[4], comp[2], 4'b0001}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1111000)  begin out_temp = {1'b1, org[7], org[2], org[1], org[0], comp[6], comp[5], comp[4], comp[3], 4'b0010}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1100011)  begin out_temp = {1'b1, org[7], org[4], org[3], org[2], comp[6], comp[5], comp[1], comp[0], 4'b0011}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1100101)  begin out_temp = {1'b0, org[7], org[4], org[3], org[1], comp[6], comp[5], comp[2], comp[0], 4'b0100}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1100110)  begin out_temp = {1'b1, org[7], org[4], org[3], org[0], comp[6], comp[5], comp[2], comp[1], 4'b0101}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1101001)  begin out_temp = {1'b1, org[7], org[4], org[2], org[1], comp[6], comp[5], comp[3], comp[0], 4'b0110}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1101010)  begin out_temp = {1'b1, org[7], org[4], org[2], org[0], comp[6], comp[5], comp[3], comp[1], 4'b0111}; doable = 1'b1; end 
		else if (comped[6:0] == 7'b1101100)  begin out_temp = {1'b1, org[7], org[4], org[1], org[0], comp[6], comp[5], comp[3], comp[2], 4'b1000}; doable = 1'b1; end 
		else if (comped[7:0] == 8'b11110000) begin out_temp = {1'b1, org[3], org[2], org[1], org[0], comp[7], comp[6], comp[5], comp[4], 4'b1001}; doable = 1'b1; end 
		else if (comped[7:0] == 8'b10001110) begin out_temp = {1'b1, org[6], org[5], org[4], org[0], comp[7], comp[3], comp[2], comp[1], 4'b1010}; doable = 1'b1; end 
		else if (comped[7:0] == 8'b10110100) begin out_temp = {1'b1, org[6], org[3], org[1], org[0], comp[7], comp[5], comp[4], comp[2], 4'b1011}; doable = 1'b1; end 
		else if (comped[7:0] == 8'b10110001) begin out_temp = {1'b1, org[6], org[3], org[2], org[1], comp[7], comp[5], comp[4], comp[0], 4'b1100}; doable = 1'b1; end 
		else if (comped[7:0] == 8'b10001110) begin out_temp = {1'b1, org[6], org[5], org[4], org[0], comp[7], comp[3], comp[2], comp[1], 4'b1101}; doable = 1'b1; end 
		
		else                                 begin out_temp = in[71:0];  doable = 1'b0; end
	end
endmodule

module decompress #(
	parameter IN_WIDTH = 73,
	parameter OUT_WIDTH = 128
)
(
	in, 
	out
);
	
	input  [IN_WIDTH-1:0] in;
	output [OUT_WIDTH-1:0] out;
	
	wire [15:0] org [0:3];
	reg [OUT_WIDTH-1:0] out_temp;
	assign out = out_temp;

	assign org[0] = in[23:8];
	assign org[1] = in[39:24];
	assign org[2] = in[55:40];
	assign org[3] = in[71:56];


	always @ (*) begin
		case ({in[72], in[3:0]})
		    5'b00000: out_temp = {org[3],     org[2],     org[1],      org[0],     {16{in[7]}}, {16{in[6]}},  {16{in[5]}}, {16{in[4]}}}; 
		    5'b00001: out_temp = {org[3],     org[2],     org[1],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}},  {16{in[4]}},  org[0]}   ; 
		    5'b00010: out_temp = {org[3],     org[2],     org[1],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}},   org[0],    {16{in[4]}}}; 
		    5'b00011: out_temp = {org[3],     org[2],     org[1],     {16{in[7]}}, {16{in[6]}},   org[0],     {16{in[5]}}, {16{in[4]}}}; 
		    5'b00100: out_temp = {org[3],     org[2],     org[1],     {16{in[7]}},  org[0],    {16{in[6]}},   {16{in[5]}}, {16{in[4]}}}; 
		    5'b00101: out_temp = {org[3],     org[2],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}}, {16{in[4]}},  org[1],     org[0]}; 
		    5'b00110: out_temp = {org[3],     org[2],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}},  org[1],     {16{in[4]}},  org[0]}; 
		    5'b00111: out_temp = {org[3],     org[2],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}},  org[1],      org[0],    {16{in[4]}}}; 
		    5'b01000: out_temp = {org[3],     org[2],     {16{in[7]}}, {16{in[6]}},  org[1],    {16{in[5]}},  {16{in[4]}},  org[0]};
		    5'b01001: out_temp = {org[3],     org[2],     {16{in[7]}}, {16{in[6]}},  org[1],    {16{in[5]}},   org[0],    {16{in[4]}}}; 
		    5'b01010: out_temp = {org[3],     org[2],     {16{in[7]}}, {16{in[6]}},  org[1],     org[0],      {16{in[5]}}, {16{in[4]}}}; 
		    5'b01011: out_temp = {org[3],     org[2],     {16{in[7]}},  org[1],     {16{in[6]}}, {16{in[5]}}, {16{in[4]}}, org[0] }; 
		    5'b01100: out_temp = {org[3],     org[2],     {16{in[7]}},   org[1],     {16{in[6]}}, {16{in[5]}},  org[0],      {16{in[4]}}};
			5'b01101: out_temp = {org[3],     org[2],     {16{in[7]}},   org[1],     {16{in[6]}},  org[0],     {16{in[5]}},   {16{in[4]}}};
			5'b01110: out_temp = {org[3],     org[2],     {16{in[7]}},   org[1],      org[0],     {16{in[6]}}, {16{in[5]}},   {16{in[4]}}};
			5'b01111: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}},  org[2],     org[1],     org[0],    {16{in[4]}}}; 
		    5'b10000: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}},  org[2],     org[1],    {16{in[4]}},  org[0]}; 
		    5'b10001: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}},  org[3],    {16{in[4]}},  org[1],     org[0]}; 
		    5'b10010: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}}, {16{in[5]}}, {16{in[4]}},  org[2],     org[1],     org[0]};
			5'b10011: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}},   org[2],     org[1],     org[0],    {16{in[5]}}, {16{in[4]}}  };
			5'b10100: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}},   org[2],     org[1],    {16{in[5]}},    org[0],   {16{in[4]}}  };
			5'b10101: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}},   org[2],     org[1],    {16{in[5]}},   {16{in[4]}},   org[0]};
			5'b10110: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}},   org[2],   {16{in[5]}},  org[1],         org[0],  {16{in[4]}}  };
			5'b10111: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}},   org[2],   {16{in[5]}},  org[1],       {16{in[4]}},    org[0] };
			5'b11000: out_temp = {org[3],     {16{in[7]}}, {16{in[6]}},   org[2],   {16{in[5]}},   {16{in[4]}},    org[1],    org[0] };
			5'b11001: out_temp = {{16{in[7]}}, {16{in[6]}}, {16{in[5]}}, {16{in[4]}},   org[3],    org[2],     org[1],     org[0]}; 
			5'b11010: out_temp = {{16{in[7]}},  org[3],    org[2],         org[1],   {16{in[6]}},    {16{in[5]}},   {16{in[4]}},       org[0] };
			5'b11011: out_temp = {{16{in[7]}},  org[3],    {16{in[6]}},  {16{in[5]}},   org[2],        {16{in[4]}},  org[1],       org[0] };
			5'b11100: out_temp = {{16{in[7]}},  org[3],    {16{in[6]}},  {16{in[5]}},   org[2],        org[1],       org[0], {16{in[4]}} };
			5'b11100: out_temp = {{16{in[7]}},  org[3],    org[2],        org[1],      {16{in[6]}},  {16{in[5]}},      {16{in[4]}},    org[0]};
		    
		endcase
	end
endmodule
