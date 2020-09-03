// ====================
// 8位乘法器模块设计
// ====================
module Multi_8bits(
	input CLK_50M,
	input rst_n,
	input key2,
	input key3,
	input key5,
	input [7:0] x,
	input [7:0] y,
	output  reg [15:0] cout
	);
	
	reg [7:0]x_reg, y_reg;	// 乘数与被乘数寄存器
	reg [15:0]out_reg0;		// 乘积寄存器
	reg [15:0]out_reg1;
	reg [15:0]out_reg2;
	reg [15:0]out_reg3;
	reg [15:0]out_reg4;
	reg [15:0]out_reg5;
	reg [15:0]out_reg6;
	reg [15:0]out_reg7;
	
	reg [15:0]out_reg01;
	reg [15:0]out_reg23;
	reg [15:0]out_reg45;
	reg [15:0]out_reg67;
	reg [15:0]out_reg0123;
	reg [15:0]out_reg4567;
	
		
	localparam			TIME5MS_CNT = 125000;
	reg					clk_5ms;					// 使用clk_5ms处理
	integer				clk_cnt;

	// =================================
	// 产生5ms周期信号
	// =================================
	always@(posedge CLK_50M or negedge rst_n) begin
		if(!rst_n) begin 
			clk_5ms <= 1'b0;
			clk_cnt <= 0;
		end
		else if(clk_cnt == TIME5MS_CNT-1) begin
			clk_cnt <= 0;
			clk_5ms <= !clk_5ms;
		end
		else clk_cnt <= clk_cnt + 1;
	end
	
	
	
	// ========================
	// 流水线8位乘法器
	// ========================
	always@(posedge clk_5ms, negedge rst_n) begin
		if(!rst_n)								//复位信号
		begin
			cout <= 16'b0;
		end
		else begin
				out_reg0 <= y[0]?{8'b0,x}:16'b0;
				out_reg1 <= y[1]?{7'b0,x,1'b0}:16'b0;
				out_reg2 <= y[2]?{6'b0,x,2'b0}:16'b0;
				out_reg3 <= y[3]?{5'b0,x,3'b0}:16'b0;
				out_reg4 <= y[4]?{4'b0,x,4'b0}:16'b0;
				out_reg5 <= y[5]?{3'b0,x,5'b0}:16'b0;
				out_reg6 <= y[6]?{2'b0,x,6'b0}:16'b0;
				out_reg7 <= y[7]?{1'b0,x,7'b0}:16'b0;
				out_reg01 <= out_reg0+out_reg1;
				out_reg23 <= out_reg2+out_reg3;
				out_reg45 <= out_reg4+out_reg5;
				out_reg67 <= out_reg6+out_reg7;
				out_reg0123 <= out_reg01+out_reg23;
				out_reg4567 <= out_reg45+out_reg67;
				cout <= out_reg0123+out_reg4567;
		end
	end
	
endmodule
	