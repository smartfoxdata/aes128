////////////////////////////////////////////////////////////////////////////////
//
// MIT License
//
// Copyright (c) 2017 Smartfox Data Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

module invcipher(/*AUTOARG*/
   // Outputs
   oDecBlkEnd, oDecData,
   // Inputs
   iClk, iRstN, iDecStart, iDecData, iDecKeyRoundReady,
   iDecKeyRound00, iDecKeyRound01, iDecKeyRound02, iDecKeyRound03,
   iDecKeyRound04, iDecKeyRound05, iDecKeyRound06, iDecKeyRound07,
   iDecKeyRound08, iDecKeyRound09, iDecKeyRound10
   );
   //input
   input iClk, iRstN;
   input iDecStart;
   input [127:0] iDecData;   
   input [10:0]  iDecKeyRoundReady;
   input [127:0] iDecKeyRound00;
   input [127:0] iDecKeyRound01;
   input [127:0] iDecKeyRound02;
   input [127:0] iDecKeyRound03;
   input [127:0] iDecKeyRound04;
   input [127:0] iDecKeyRound05;
   input [127:0] iDecKeyRound06;
   input [127:0] iDecKeyRound07;
   input [127:0] iDecKeyRound08;
   input [127:0] iDecKeyRound09;
   input [127:0] iDecKeyRound10;
   //output
   output 	  oDecBlkEnd;
   output [127:0] oDecData;

   wire 	  oDecBlkEnd;   
   reg [127:0] 	  oDecData;
   
   // parameter
   parameter Nr = 10;
   parameter Nb = 4;
   parameter Nk = 4;
   //
   reg [3:0] round;
   reg [3:0] cur_st;
   reg [3:0] nxt_st;
   
   parameter st_idle  = 0;
   parameter st_start = 1;
   parameter st_run   = 2;
   parameter st_last  = 3;

   parameter IDLE  = 4'h01;
   parameter START = 4'h02;   
   parameter RUN   = 4'h04;
   parameter LAST  = 4'h08;   
   //
   int 	     i;
   //
   reg [127:0] data;
   reg [127:0] xdata;
   reg [127:0] data_sub;
   reg [127:0] data_shift;
   reg [127:0] data_addr;
   
   `include "invsubtable.sv"
   `include "invsubbytes.sv"
   `include "invgmultable.sv"
   `include "invmixcolumns.sv"
   //
   assign oDecBlkEnd = nxt_st[st_idle];


   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 round  <= 4'h0;
	 cur_st <= IDLE;
      end
      else begin
	 if(iDecStart)
	   round <= 4'h0;
	 else if(round < 4'hb)
	   round  <= (iDecKeyRoundReady[10]) ? round + 1 : round;
	 else
	   round  <= round;
	 
	 cur_st <= nxt_st;
      end
   end

   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 data[127:0]  <= 128'h0;
	 oDecData[127:0] <= 128'h0;
      end
      else begin
	 if(nxt_st[st_start])
	   data[127:0] <= iDecData[127:0];
	 else if(nxt_st[st_run] | nxt_st[st_last])
	   data[127:0] <= xdata[127:0];
	 else	 
	   data[127:0] <= data[127:0];

	 if(nxt_st[st_idle])
	   oDecData[127:0] <= xdata[127:0];
	 else
	   oDecData[127:0] <= oDecData[127:0];

      end
   end

   always @* begin
      nxt_st = IDLE;
      //
      xdata[127:0]      = 128'h0;
      data_sub[127:0]   = 128'h0;
      data_shift[127:0] = 128'h0;
      data_addr[127:0]  = 128'h0;      
      
      //
      if(cur_st[st_idle]) begin
	 if(iDecStart)
	   nxt_st = START;
	 else
	   nxt_st = IDLE;
      end
      //
      if(cur_st[st_start]) begin
	 //AddRoundKey
	 if(iDecKeyRoundReady[10]) begin
	    xdata = data[127:0] ^ iDecKeyRound10[127:0];
	    nxt_st = RUN;	    
	 end
	 else 
	   nxt_st = START;
      end
      //
      if(cur_st[st_run]) begin
	 //InvShiftRows
	 // [07:00][39:32][71:64][103:096] =  [07:00]  [39:32]  [71:64] [103:096]
	 // [15:08][47:40][79:72][111:104] = [111:104] [15:08]  [47:40]  [79:72]
	 // [23:16][55:48][87:80][119:112] =  [87:80] [119:112] [23:16]  [55:48]
	 // [31:24][63:56][95:88][127:120] =  [63:56]  [95:88] [127:120] [31:24]
	 {data_shift[07:00],data_shift[39:32],data_shift[71:64],data_shift[103:096]} = {data[07:00]  ,data[39:32]  ,data[71:64]  ,data[103:096]};
	 {data_shift[15:08],data_shift[47:40],data_shift[79:72],data_shift[111:104]} = {data[111:104],data[15:08]  ,data[47:40]  ,data[79:72]};
	 {data_shift[23:16],data_shift[55:48],data_shift[87:80],data_shift[119:112]} = {data[87:80]  ,data[119:112],data[23:16]  ,data[55:48]};
	 {data_shift[31:24],data_shift[63:56],data_shift[95:88],data_shift[127:120]} = {data[63:56]  ,data[95:88]  ,data[127:120],data[31:24]};
	 //InvSubBytes
	 invsubbytes(data_shift[07:00], data_sub[07:00]); // 0
	 invsubbytes(data_shift[15:08], data_sub[15:08]); // 1
	 invsubbytes(data_shift[23:16], data_sub[23:16]); // 2        
	 invsubbytes(data_shift[31:24], data_sub[31:24]); // 3
	 invsubbytes(data_shift[39:32], data_sub[39:32]); // 4        
	 invsubbytes(data_shift[47:40], data_sub[47:40]); // 5
	 invsubbytes(data_shift[55:48], data_sub[55:48]); // 6        
	 invsubbytes(data_shift[63:56], data_sub[63:56]); // 7
	 invsubbytes(data_shift[71:64], data_sub[71:64]); // 8        
	 invsubbytes(data_shift[79:72], data_sub[79:72]); // 9
	 invsubbytes(data_shift[87:80], data_sub[87:80]); // a        
	 invsubbytes(data_shift[95:88], data_sub[95:88]); // b
	 //
	 invsubbytes(data_shift[103:96],  data_sub[103:96]);  // c	 
	 invsubbytes(data_shift[111:104], data_sub[111:104]); // d
	 invsubbytes(data_shift[119:112], data_sub[119:112]); // e	 
	 invsubbytes(data_shift[127:120], data_sub[127:120]); // f
	 //AddRoundKey
	 case(round)
	     4'h1: data_addr[127:0] = iDecKeyRound09[127:0] ^ data_sub[127:0];
	     4'h2: data_addr[127:0] = iDecKeyRound08[127:0] ^ data_sub[127:0];
	     4'h3: data_addr[127:0] = iDecKeyRound07[127:0] ^ data_sub[127:0];
	     4'h4: data_addr[127:0] = iDecKeyRound06[127:0] ^ data_sub[127:0];
	     4'h5: data_addr[127:0] = iDecKeyRound05[127:0] ^ data_sub[127:0];
	     4'h6: data_addr[127:0] = iDecKeyRound04[127:0] ^ data_sub[127:0];
	     4'h7: data_addr[127:0] = iDecKeyRound03[127:0] ^ data_sub[127:0];
	     4'h8: data_addr[127:0] = iDecKeyRound02[127:0] ^ data_sub[127:0];
	     4'h9: data_addr[127:0] = iDecKeyRound01[127:0] ^ data_sub[127:0];
	    default: xdata[127:0] = data[127:0];
	 endcase // case (round)	 
	 //InvMixColumns
	 invmixcolumns(data_addr[31:00], xdata[31:00]);
	 invmixcolumns(data_addr[63:32], xdata[63:32]);
	 invmixcolumns(data_addr[95:64], xdata[95:64]);
	 invmixcolumns(data_addr[127:96],xdata[127:96]);	 
	 //
 	 if(round == 4'h9)
	   nxt_st = LAST;
	 else
	   nxt_st = RUN;
      end
      //
      if(cur_st[st_last]) begin
	 //InvShiftRows
	 {data_shift[07:00],data_shift[39:32],data_shift[71:64],data_shift[103:096]} = {data[07:00]  ,data[39:32]  ,data[71:64]  ,data[103:096]};
	 {data_shift[15:08],data_shift[47:40],data_shift[79:72],data_shift[111:104]} = {data[111:104],data[15:08]  ,data[47:40]  ,data[79:72]};
	 {data_shift[23:16],data_shift[55:48],data_shift[87:80],data_shift[119:112]} = {data[87:80]  ,data[119:112],data[23:16]  ,data[55:48]};
	 {data_shift[31:24],data_shift[63:56],data_shift[95:88],data_shift[127:120]} = {data[63:56]  ,data[95:88]  ,data[127:120],data[31:24]};
	 //InvSubBytes
	 invsubbytes(data_shift[07:00], data_sub[07:00]); // 0
	 invsubbytes(data_shift[15:08], data_sub[15:08]); // 1
	 invsubbytes(data_shift[23:16], data_sub[23:16]); // 2	 
	 invsubbytes(data_shift[31:24], data_sub[31:24]); // 3
	 invsubbytes(data_shift[39:32], data_sub[39:32]); // 4	 
	 invsubbytes(data_shift[47:40], data_sub[47:40]); // 5
	 invsubbytes(data_shift[55:48], data_sub[55:48]); // 6	 
	 invsubbytes(data_shift[63:56], data_sub[63:56]); // 7
	 invsubbytes(data_shift[71:64], data_sub[71:64]); // 8	 
	 invsubbytes(data_shift[79:72], data_sub[79:72]); // 9
	 invsubbytes(data_shift[87:80], data_sub[87:80]); // a	 
	 invsubbytes(data_shift[95:88], data_sub[95:88]); // b
	 //
	 invsubbytes(data_shift[103:96], data_sub[103:96]);   // c	 
	 invsubbytes(data_shift[111:104], data_sub[111:104]); // d
	 invsubbytes(data_shift[119:112], data_sub[119:112]); // e	 
	 invsubbytes(data_shift[127:120], data_sub[127:120]); // f
	 //AddRoundKey
	 xdata[127:0] = iDecKeyRound00[127:0] ^ data_sub[127:0];

 	 if(round == 4'ha)
	   nxt_st = IDLE;
	 else 
	   nxt_st = LAST;
      end      
   end
endmodule

//module temp;
//invcipher invcipher(/*AUTOINST*/);
//endmodule
