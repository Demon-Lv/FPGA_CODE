// ====================
// 顶层程序设计
// ====================
module main(
	input 		CLK_50M,				// 系统时钟信号50MHz
	input		Rst_n,					// 复位
	input 		[7:1] BUT,				// 按键值
	output	reg [8:1] LED,				// LED灯
	output	reg	[6 : 1]	SEG_NCS,		// 6个数码管的片选（LOW），LSB对应最左边
	output	reg	[7 : 0]	SEG_LED			// 共阳，bit0点、1中间、2左上、3左下、4下、5右下、6右上、7上
	);
	
	wire key1, key2, key3, key4, key5, key6, key7;
	reg [7:0] x, y;
	wire [15:0] cout;
	reg [1:0] state_cur;

	
	wire   [3:0]              data0    ;        // x个位数
	wire   [3:0]              data1    ;        // x十位数
	wire   [3:0]              data2    ;        // y个位数
	wire   [3:0]              data3    ;        // y十位数
	wire   [7:0]              data4    ;        // cout个位数
	wire   [7:0]              data5    ;        // cout十位数
	wire   [7:0]              data6    ;
	
	
	//提取显示数值所对应的十进制数的各个位
	assign  data0 = x[3:0];       // 个位数
	assign  data1 = x[7:4];       // 十位数
	
	assign  data2 = y[3:0];       // 个位数
	assign  data3 = y[7:4];       // 十位数
	
	assign  data4 = cout[7:0];    // 个位数
	assign  data5 = cout[15:8];   // 十位数
	
	reg    [3:0] num_disp;        // 当前数码管显示的数据
	
	reg flag_1, flag_4, flag_5, flag_6; 	//设置标志位
	reg [1:0]flag_2, flag_3; 
	reg [23:0]	counter;					// 计数器，用于计时200ms
	reg [2:0]	count;
	reg [2:0]	count_1;


	localparam			TIME2MS_CNT = 50000;
	reg					clk_2ms;					// 使用clk_2m处理
	integer				clk_cnt_2ms	;
	
	localparam			TIME200MS_CNT = 1000_0000;	//1000_0000;
	reg					clk_200ms;				 	// 使用clk_200ms处理
	integer				cnt_200ms;

	localparam			TIME8MS_CNT = 200000;
	reg					clk_8ms;					// 使用clk_8m处理
	integer				clk_cnt_8ms;
	
	
	localparam			TIME400MS_CNT = 2000_0000;	
	reg					clk_400ms;					// 使用clk_400ms处理
	integer				cnt;
	
	localparam			TIME5MS_CNT = 125000;
	reg					clk_5ms;					// 使用clk_5ms处理
	integer				clk_cnt;


	// =================================
	// 产生5ms周期信号
	// =================================
	always@(posedge CLK_50M or negedge Rst_n) begin
		if(!Rst_n) begin 
			clk_5ms <= 1'b0;
			clk_cnt <= 0;
		end
		else if(clk_cnt == TIME5MS_CNT-1) begin
			clk_cnt <= 0;
			clk_5ms <= !clk_5ms;
		end
		else clk_cnt <= clk_cnt + 1;
	end
	
	// =================================
	// 产生400ms周期信号
	// =================================
	always@(posedge CLK_50M or negedge Rst_n) begin
		if(!Rst_n) begin 
			clk_400ms <= 1'b0;
			cnt <= 0;
		end
		else if(cnt == TIME400MS_CNT-1) begin
			cnt <= 0;
			clk_400ms <= !clk_400ms;
		end
		else cnt <= cnt + 1;
	end
	
	// =================================
	// 得到周期为8ms的时钟
	// =================================
	always @(posedge CLK_50M or negedge Rst_n) begin
		if(!Rst_n) begin 
			clk_8ms <= 1'b0;
			clk_cnt_8ms <= 0;
		end
		else if(clk_cnt_8ms == TIME8MS_CNT-1) begin
			clk_cnt_8ms <= 0;
			clk_8ms <= ~clk_8ms;
		end
		else clk_cnt_8ms <= clk_cnt_8ms + 1;
	end
	
	// =================================
	// 产生200ms周期信号
	// =================================
	always@(posedge CLK_50M or negedge Rst_n) begin
		if(!Rst_n) begin 
			clk_200ms <= 1'b0;
			cnt_200ms <= 0;
		end
		else if(cnt_200ms == TIME200MS_CNT-1) begin
			cnt_200ms <= 0;
			clk_200ms <= !clk_200ms;
		end
		else cnt_200ms <= cnt_200ms + 1;
	end

	// =================================
	// 得到周期为2ms的时钟
	// =================================
	always @(posedge CLK_50M or negedge Rst_n) begin
	if(!Rst_n) begin 
		clk_2ms <= 1'b0;
		clk_cnt_2ms <= 0;
	end
	else if(clk_cnt_2ms == TIME2MS_CNT-1) begin
		clk_cnt_2ms <= 0;
		clk_2ms <= !clk_2ms;
	end
	else clk_cnt_2ms <= clk_cnt_2ms + 1;
end



	always @(posedge clk_8ms)	begin
		if(key1) 		flag_1 <= ~flag_1;
		if(key2)		flag_2 <= flag_2 + 1'b1;
		else if(flag_2 == 2'b11)	flag_2 <= 0;
		if(key3)		flag_3 <= flag_3 + 1'b1;
		else if(flag_3 == 2'b11)	flag_3 <= 0;
		if(key4)		flag_4 <= ~flag_4;
		if(key5) 		flag_5 <= ~flag_5;
		if(key6)		flag_6 <= ~flag_6;
	end


// ==============================================================
// 流水灯程序
// 通过移位寄存器控制IO口的高低电平，从而改变LED的显示状态,流水灯
// ==============================================================
always @(posedge clk_200ms or negedge Rst_n) begin
    if (!Rst_n)
        LED <= 8'hff;
	else begin
		if (flag_1) begin
		case(LED)
			8'b1111_1111: LED <= 8'b1111_1110;
			8'b1111_1110: LED <= 8'b1111_1101;
			8'b1111_1101: LED <= 8'b1111_1011;
			8'b1111_1011: LED <= 8'b1111_0111;
			8'b1111_0111: LED <= 8'b1110_1111;
			8'b1110_1111: LED <= 8'b1101_1111;
			8'b1101_1111: LED <= 8'b1011_1111;
			8'b1011_1111: LED <= 8'b0111_1111;
			default: LED <= 8'hff;
		endcase
		end
		if(!flag_1) 	LED <= 8'hff;
		if(flag_6) begin
			case(count)
				3'h0: begin
					LED <= 8'b0111_1110;
					count <= count + 1'b1;
				end
				3'h1: begin
					LED <= 8'b0011_1100;
					count <= count + 1'b1;
				end
				3'h2: begin
					LED <= 8'b0001_1000;
					count <= count + 1'b1;
				end
				3'h3: begin
					LED <= 8'b0000_0000;
					count <= count + 1'b1;
				end
				3'h4: begin
					LED <= 8'b1110_0111;
					count <= count + 1'b1;
				end
				3'h5: begin
					LED <= 8'b1100_0011;
					count <= count + 1'b1;
				end
				3'h6: begin
					LED <= 8'b1000_0001;
					count <= count + 1'b1;
				end
				3'h7: begin
					LED <= 8'b0000_0000;
					count <= count + 1'b1;
				end
				default:	count <= 4'h0;
			endcase
		end
	end
end


// ==============================
// 数码管显示程序
// ==============================
reg [2:0]cnt_seg;
always @(posedge clk_2ms or negedge Rst_n)	begin
	if(!Rst_n) begin
		SEG_NCS  <= 6'b1111_11;
		SEG_LED <= 8'hFF;
		cnt_seg  <= 0;
	end
	else begin
		if(flag_1) begin
			case(cnt_seg)
				3'h0: begin 
							SEG_NCS  <= 6'b1111_10;		// 数码管，左1
							SEG_LED <= 8'b0000_1101;
							cnt_seg <= cnt_seg + 1'b1;
							end
				3'h1: begin
							SEG_NCS  <= 6'b1111_01;		// 数码管，左2
							SEG_LED <= 8'b0000_1101;
							cnt_seg <= cnt_seg + 1'b1;
							end
				3'h2: begin
							SEG_NCS  <= 6'b1110_11;		// 数码管，左3
							SEG_LED <= 8'b1001_1001;
							cnt_seg <= cnt_seg + 1'b1;
							end
				3'h3: begin
							SEG_NCS  <= 6'b1101_11;		// 数码管，左4
							SEG_LED <= 8'b0000_0011;
							cnt_seg <= cnt_seg + 1'b1;
							end
				3'h4: begin
							SEG_NCS  <= 6'b1011_11;		// 数码管，左5
							SEG_LED <= 8'b1001_1111;
							cnt_seg <= cnt_seg + 1'b1;
							end
				3'h5: begin
							SEG_NCS  <= 6'b0111_11;		// 数码管，左6
							SEG_LED <= 8'b1001_1001;
							cnt_seg <= 0;
							end
				default: 	begin
							SEG_NCS  <= 6'b1111_11;
							cnt_seg  <= 0;
							end
			endcase	
		end
		else if(!flag_1)	SEG_NCS <= 6'b1111_11;
		if((flag_2 == 2'b01) || (flag_2 == 2'b10)) begin
			case(SEG_NCS)
				6'b1111_11: begin 
							SEG_NCS  <= 6'b1111_10;		// 数码管，左1
							num_disp <= data0;
							end
				6'b1111_10: begin
							SEG_NCS  <= 6'b1111_01;		// 数码管，左2
							num_disp <= data1;
							end
				default:	SEG_NCS  <= 6'b1111_11;
			endcase
		end
		else if(flag_2 == 2'b11)	SEG_NCS <= 6'b1111_11;
		if((flag_3 == 2'b01) || (flag_3 == 2'b10)) begin
			case(SEG_NCS)
				6'b1111_11: begin 
							SEG_NCS  <= 6'b1111_10;		// 数码管，左1
							num_disp <= data0;
							end
				6'b1111_10: begin
							SEG_NCS  <= 6'b1111_01;		// 数码管，左2
							num_disp <= data3;
							end
				6'b1111_01: begin
							SEG_NCS  <= 6'b1110_11;		// 数码管，左3
							num_disp <= data2;
							end
				6'b1110_11: begin
							SEG_NCS  <= 6'b1101_11;		// 数码管，左4
							num_disp <= data1;
							end
				default:	SEG_NCS  <= 6'b1111_11;
			endcase
		end
		else if(flag_3 == 2'b11)	SEG_NCS <= 6'b1111_11;
		if(flag_4) begin
			case(SEG_NCS)
				6'b1111_11: begin
							SEG_NCS  <= 6'b1110_11;		// 数码管，左3
							num_disp <= data5[3:0];
							end
				6'b1110_11: begin
							SEG_NCS  <= 6'b1101_11;		// 数码管，左4
							num_disp <= data4[7:4];
							end
				6'b1101_11: begin
							SEG_NCS  <= 6'b1011_11;		// 数码管，左5
							num_disp <= data4[3:0];
							end
				6'b1011_11: begin
							SEG_NCS  <= 6'b0111_11;		// 数码管，左6
							num_disp <= data5[7:4];
							end
				default:	SEG_NCS  <= 6'b1111_11;
			endcase
		end
		if(flag_5) begin
			case(SEG_NCS)
				6'b1111_11: begin
							SEG_NCS  <= 6'b1111_10;
							num_disp <= data0;
							end
				6'b1111_10: begin
							SEG_NCS  <= 6'b1111_01;
							num_disp <= data3;
							end			
				6'b1111_01: begin
							SEG_NCS  <= 6'b1110_11;
							num_disp <= data2;
							end			
				6'b1110_11: begin
							SEG_NCS  <= 6'b1101_11;
							num_disp <= data4[7:4];
							end		
				6'b1101_11: begin
							SEG_NCS  <= 6'b1011_11;
							num_disp <= data4[3:0];
							end			
				6'b1011_11: begin
							SEG_NCS  <= 6'b0111_11;
							num_disp <= data1;
							end		
				default:	SEG_NCS  <= 6'b1111_11;
			endcase
		end
		if((flag_2 || flag_3 || flag_4 || flag_5)) begin
			case(num_disp)
				4'd0:  SEG_LED <= 8'b0000_0011;		// 0
				4'd1:  SEG_LED <= 8'b1001_1111;		// 1
				4'd2:  SEG_LED <= 8'b0010_0101;		// 2
				4'd3:  SEG_LED <= 8'b0000_1101;		// 3
				4'd4:  SEG_LED <= 8'b1001_1001;		// 4
				4'd5:  SEG_LED <= 8'b0100_1001;		// 5
				4'd6:  SEG_LED <= 8'b0100_0001;		// 6
				4'd7:  SEG_LED <= 8'b0001_1111;		// 7
				4'd8:  SEG_LED <= 8'b0000_0001;		// 8
				4'd9:  SEG_LED <= 8'b0000_1001;		// 9
				4'd10: SEG_LED <= 8'b0001_1001;		// a
				4'd11: SEG_LED <= 8'b1100_0001;		// b
				4'd12: SEG_LED <= 8'b0110_0011;		// c
				4'd13: SEG_LED <= 8'b1000_0101;		// d
				4'd14: SEG_LED <= 8'b0110_0001;		// E
				4'd15: SEG_LED <= 8'b0111_0001;		// F
				default: SEG_LED <= 8'b0000_0011;		// 0
			endcase
		end
	
	end
end


// =================================
// 8位乘法器模块
// =================================

	//判断键值，若按下则自加1
	always@(posedge clk_400ms, negedge Rst_n) begin
		if(!Rst_n) begin								//复位信号
			x <= 8'b0000_0000;
			y <= 8'b0000_0000;
		end
		else  begin
			if((flag_2 == 2'b01))	x <= x + 1'b1;
			else if((flag_2 == 2'b10)) x <= x;
			if((flag_3 == 2'b01))	y <= y + 1'b1;
			else if((flag_3 == 2'b10)) y <= y;
			if(flag_5 && (state_cur == 2'b11)) begin
				x <= x + 1'b1;
				y <= y + 1'b1;
				state_cur <= 2'b00;
			end
			else if((state_cur != 2'b11)) begin
				state_cur <= state_cur + 1'b1;
			end
		end
	end

Multi_8bits Multi_8bits_U1(
	.CLK_50M			(CLK_50M),
	.rst_n				(Rst_n),
	.key2				(key2),
	.key3				(key3),
	.key5				(key5),
	.x					(x),
	.y					(y),
	.cout				(cout),
);





// =================================
// 调用按键消抖模块
// =================================

key_handle key1_u(
	.rst_n				(Rst_n			),			// 复位key7(BUT[8])
	.clk_8ms			(clk_8ms			),			
	.key				(BUT[1]			),			// 单个按键
	.rst_sync			(key7				),
	.key_handled		(key1				)
);
key_handle key2_u(
	.rst_n				(Rst_n			),			// 复位key7(BUT[8])
	.clk_8ms			(clk_8ms			),			
	.key				(BUT[2]			),			// 单个按键
	.rst_sync			(key7				),
	.key_handled		(key2				)
);
key_handle key3_u(
	.rst_n				(Rst_n			),			// 复位key7(BUT[8])
	.clk_8ms			(clk_8ms			),			
	.key				(BUT[3]			),			// 单个按键
	.rst_sync			(key7				),
	.key_handled		(key3				)
);
key_handle key4_u(
	.rst_n				(Rst_n			),			// 复位key7(BUT[8])
	.clk_8ms			(clk_8ms			),			
	.key				(BUT[4]			),			// 单个按键
	.rst_sync			(key7				),
	.key_handled		(key4				)
);
key_handle key5_u(
	.rst_n				(Rst_n			),			// 复位key7(BUT[8])
	.clk_8ms			(clk_8ms			),			
	.key				(BUT[5]			),			// 单个按键
	.rst_sync			(key7				),
	.key_handled		(key5				)
);
key_handle key6_u(
	.rst_n				(Rst_n			),			// 复位key7(BUT[8])
	.clk_8ms			(clk_8ms			),			
	.key				(BUT[6]			),			// 单个按键
	.rst_sync			(key7				),
	.key_handled		(key6				)
);
key_handle key7_u(
	.rst_n				(Rst_n			),			// 复位key7(BUT[8])
	.clk_8ms			(clk_8ms			),			
	.key				(BUT[7]			),			// 单个按键
	.rst_sync			(1'b0				),
	.key_handled		(key7				)
);


endmodule
	
