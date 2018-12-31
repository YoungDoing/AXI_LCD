`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/26 15:48:04
// Design Name: 
// Module Name: core_LCD_Sender
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module core_LCD_Sender#(
parameter PSEND_CMD ='d1,
parameter PSEND_PARA='d2
)
(
//signal for LCD
	odata,
	odcx,
	ordx,
	owrx,
//signal for control
	iclk,
	irstn,
	idata,
	icmd,
	ostatus
);
output reg[15:0] odata;
output reg	 odcx;
output reg	 ordx;
output reg	 owrx;
output reg[ 7:0] ostatus;

input wire	 iclk;
input wire	 irstn;
input wire[15:0] idata;
input wire[ 7:0] icmd;

reg[7:0] state;
parameter IDLE		='d0;
parameter SEND_CMD	='d1;
parameter SEND_PARA	='d2;

integer cnt;

always @ (posedge iclk or negedge irstn)
if(!irstn)begin
	state<=IDLE;
	owrx<=1;
	ordx<=0;
end else case(state)
	IDLE:begin
		case(icmd)
		PSEND_CMD:begin
			state<=SEND_CMD;
			ostatus<=8'b0000_0001;
			cnt<=0;
		end
		PSEND_PARA:begin
			state<=SEND_PARA;
			ostatus<=8'b0000_0010;
			cnt<=0;
		end
		default:begin
			state<=IDLE;
			owrx<=1;
			ordx<=0;
			ostatus<=8'b0000_0000;
			cnt<=0;
		end
		endcase
	end
	SEND_CMD:begin
		case(cnt)
		'd0:begin
			owrx<=0;
			ordx<=1;
			odcx<=0;
			odata<=idata;
			cnt<=cnt+1;
		end
		'd1:begin
			owrx<=1;
			ostatus<=8'b1000_0001;
			state<=IDLE;
		end
		endcase
	end
	SEND_PARA:begin
		case(cnt)
		'd0:begin
			owrx<=0;
			ordx<=1;
			odcx<=1;
			odata<=idata;
			cnt<=cnt+1;
		end
		'd1:begin
			owrx<=1;
			ostatus<=8'b1000_0010;
			state<=IDLE;
		end
		endcase	
	end
endcase


endmodule

