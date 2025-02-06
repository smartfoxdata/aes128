////////////////////////////////////////////////////////////////////////////////
//
// MIT License
//
// Copyright (c) 2025 Smartfox Data Solutions Inc.
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

module cipher(/*AUTOARG*/
   // Outputs
   oEncBlkEnd, oEncData,
   // Inputs
   iClk, iRstN, iEncStart, iEncData, iEncKeyRoundReady,
   iEncKeyRound00, iEncKeyRound01, iEncKeyRound02, iEncKeyRound03,
   iEncKeyRound04, iEncKeyRound05, iEncKeyRound06, iEncKeyRound07,
   iEncKeyRound08, iEncKeyRound09, iEncKeyRound10
   );
   //input
   input iClk, iRstN;
   input iEncStart;
   input [127:0] iEncData;   
   input [10:0]  iEncKeyRoundReady;
   input [127:0] iEncKeyRound00;
   input [127:0] iEncKeyRound01;
   input [127:0] iEncKeyRound02;
   input [127:0] iEncKeyRound03;
   input [127:0] iEncKeyRound04;
   input [127:0] iEncKeyRound05;
   input [127:0] iEncKeyRound06;
   input [127:0] iEncKeyRound07;
   input [127:0] iEncKeyRound08;
   input [127:0] iEncKeyRound09;
   input [127:0] iEncKeyRound10;
   //output
   output 	  oEncBlkEnd;
   output [127:0] oEncData;

   wire 	  oEncBlkEnd;   
   reg [127:0] 	  oEncData;
   
   // parameter
   parameter Nr = 10;
   parameter Nb = 4;
   parameter Nk = 4;
   //
   reg [3:0] round;
   reg [4:0] cur_st;
   reg [4:0] nxt_st;
   
   parameter st_idle  = 0;
   parameter st_start = 1;
   parameter st_run   = 2;
   parameter st_last  = 3;   
   parameter st_wait  = 4;

   parameter IDLE  = 5'h01;
   parameter START = 5'h02;   
   parameter RUN   = 5'h04;
   parameter LAST  = 5'h08;   
   parameter WAIT  = 5'h10;
   //
   int 	     i;
   //
   reg [127:0] data;
   reg [127:0] xdata;
   reg [127:0] data_sub;
   reg [127:0] data_shift;
   reg [127:0] data_mixc;
   
   `include "subtable.sv"
   `include "subbytes.sv"
   `include "gmultable.sv"
   `include "mixcolumns.sv"
   //
   assign oEncBlkEnd = nxt_st[st_idle];


   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 round  <= 4'h0;
	 cur_st <= IDLE;
      end
      else begin
	 if(iEncStart)
	   round <= 4'h0;
	 else if(round < 4'hb)
	   round  <= (iEncKeyRoundReady[round]) ? round + 1 : round;
	 else
	   round  <= round;
	 
	 cur_st <= nxt_st;
      end
   end

   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 data[127:0]  <= 128'h0;
	 oEncData[127:0] <= 128'h0;
      end
      else begin
	 if(nxt_st[st_start])
	   data[127:0] <= iEncData[127:0];
	 else if(nxt_st[st_run] | nxt_st[st_last])
	   data[127:0] <= xdata[127:0];
	 else	 
	   data[127:0] <= data[127:0];

	 if(nxt_st[st_idle])
	   oEncData[127:0] <= xdata[127:0];
	 else
	   oEncData[127:0] <= oEncData[127:0];

      end
   end

   always @* begin
      nxt_st = IDLE;
      //
      xdata[127:0]      = 128'h0;
      data_sub[127:0]   = 128'h0;
      data_shift[127:0] = 128'h0;
      data_mixc[127:0]  = 128'h0;      
      
      //
      if(cur_st[st_idle]) begin
	 if(iEncStart)
	   nxt_st = START;
	 else
	   nxt_st = IDLE;
      end
      //
      if(cur_st[st_start]) begin
	 //AddRoundKey
	 if(iEncKeyRoundReady[0]) begin
	    xdata = data[127:0] ^ iEncKeyRound00[127:0];
	    nxt_st = RUN;	    
	 end
	 else 
	   nxt_st = START;
      end
      //
      if(cur_st[st_run]) begin
	 //SubBytes
	 subbytes(data[07:00], data_sub[07:00]); // 0
	 subbytes(data[15:08], data_sub[15:08]); // 1
	 subbytes(data[23:16], data_sub[23:16]); // 2        
	 subbytes(data[31:24], data_sub[31:24]); // 3
	 subbytes(data[39:32], data_sub[39:32]); // 4        
	 subbytes(data[47:40], data_sub[47:40]); // 5
	 subbytes(data[55:48], data_sub[55:48]); // 6        
	 subbytes(data[63:56], data_sub[63:56]); // 7
	 subbytes(data[71:64], data_sub[71:64]); // 8        
	 subbytes(data[79:72], data_sub[79:72]); // 9
	 subbytes(data[87:80], data_sub[87:80]); // a        
	 subbytes(data[95:88], data_sub[95:88]); // b
	 //
	 subbytes(data[103:96], data_sub[103:96]);   // c	 
	 subbytes(data[111:104], data_sub[111:104]); // d
	 subbytes(data[119:112], data_sub[119:112]); // e	 
	 subbytes(data[127:120], data_sub[127:120]); // f
	 // 	 
	 //ShiftRows
	 // [07:00][39:32][71:64][103:096] =  [07:00]  [39:32]  [71:64] [103:096]
	 // [15:08][47:40][79:72][111:104] =  [47:40]  [79:72] [111:104] [15:08]
	 // [23:16][55:48][87:80][119:112] =  [87:80] [119:112] [23:16]  [55:48]
	 // [31:24][63:56][95:88][127:120] = [127:120] [31:24]  [63:56]  [95:88]
	 {data_shift[07:00],data_shift[39:32],data_shift[71:64],data_shift[103:096]} = {data_sub[07:00],data_sub[39:32],data_sub[71:64],data_sub[103:096]};
	 {data_shift[15:08],data_shift[47:40],data_shift[79:72],data_shift[111:104]} = {data_sub[47:40],data_sub[79:72],data_sub[111:104],data_sub[15:08]};
	 {data_shift[23:16],data_shift[55:48],data_shift[87:80],data_shift[119:112]} = {data_sub[87:80],data_sub[119:112],data_sub[23:16],data_sub[55:48]};
	 {data_shift[31:24],data_shift[63:56],data_shift[95:88],data_shift[127:120]} = {data_sub[127:120],data_sub[31:24],data_sub[63:56],data_sub[95:88]};


	 //MixColumns
	 mixcolumns(data_shift[31:00],data_mixc[31:00]);
	 mixcolumns(data_shift[63:32],data_mixc[63:32]);
	 mixcolumns(data_shift[95:64],data_mixc[95:64]);
	 mixcolumns(data_shift[127:96],data_mixc[127:96]);	 

	 //AddRoundKey
	 case(round)
	     4'h1: xdata[127:0] = iEncKeyRoundReady[01] ? iEncKeyRound01[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h2: xdata[127:0] = iEncKeyRoundReady[02] ? iEncKeyRound02[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h3: xdata[127:0] = iEncKeyRoundReady[03] ? iEncKeyRound03[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h4: xdata[127:0] = iEncKeyRoundReady[04] ? iEncKeyRound04[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h5: xdata[127:0] = iEncKeyRoundReady[05] ? iEncKeyRound05[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h6: xdata[127:0] = iEncKeyRoundReady[06] ? iEncKeyRound06[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h7: xdata[127:0] = iEncKeyRoundReady[07] ? iEncKeyRound07[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h8: xdata[127:0] = iEncKeyRoundReady[08] ? iEncKeyRound08[127:0] ^ data_mixc[127:0] : data[127:0];
	     4'h9: xdata[127:0] = iEncKeyRoundReady[09] ? iEncKeyRound09[127:0] ^ data_mixc[127:0] : data[127:0];
	    default: xdata[127:0] = data[127:0];
	 endcase // case (round)	 
	 //
 	 if(round == 4'h9)
	   nxt_st = LAST;
	 else if (iEncKeyRoundReady[round]) 
	   nxt_st = RUN;
	 else
	   nxt_st = WAIT;
      end
      //
      if(cur_st[st_wait]) begin
	 xdata[127:0] = data[127:0];
	 
	 if (iEncKeyRoundReady[round]) 
	   nxt_st = RUN;
	 else
	   nxt_st = WAIT;
      end      
      //
      if(cur_st[st_last]) begin
	 //SubBytes
	 subbytes(data[07:00], data_sub[07:00]); // 0
	 subbytes(data[15:08], data_sub[15:08]); // 1
	 subbytes(data[23:16], data_sub[23:16]); // 2	 
	 subbytes(data[31:24], data_sub[31:24]); // 3
	 subbytes(data[39:32], data_sub[39:32]); // 4	 
	 subbytes(data[47:40], data_sub[47:40]); // 5
	 subbytes(data[55:48], data_sub[55:48]); // 6	 
	 subbytes(data[63:56], data_sub[63:56]); // 7
	 subbytes(data[71:64], data_sub[71:64]); // 8	 
	 subbytes(data[79:72], data_sub[79:72]); // 9
	 subbytes(data[87:80], data_sub[87:80]); // a	 
	 subbytes(data[95:88], data_sub[95:88]); // b
	 //
	 subbytes(data[103:96], data_sub[103:96]);   // c	 
	 subbytes(data[111:104], data_sub[111:104]); // d
	 subbytes(data[119:112], data_sub[119:112]); // e	 
	 subbytes(data[127:120], data_sub[127:120]); // f
	 //ShiftRows
	 {data_shift[07:00],data_shift[39:32],data_shift[71:64],data_shift[103:096]} = {data_sub[07:00],data_sub[39:32],data_sub[71:64],data_sub[103:096]};
	 {data_shift[15:08],data_shift[47:40],data_shift[79:72],data_shift[111:104]} = {data_sub[47:40],data_sub[79:72],data_sub[111:104],data_sub[15:08]};
	 {data_shift[23:16],data_shift[55:48],data_shift[87:80],data_shift[119:112]} = {data_sub[87:80],data_sub[119:112],data_sub[23:16],data_sub[55:48]};
	 {data_shift[31:24],data_shift[63:56],data_shift[95:88],data_shift[127:120]} = {data_sub[127:120],data_sub[31:24],data_sub[63:56],data_sub[95:88]};
	 //AddRoundKey
	 xdata[127:0] = iEncKeyRoundReady[10] ? iEncKeyRound10[127:0] ^ data_shift[127:0] : data[127:0];

 	 if(round == 4'ha)
	   nxt_st = IDLE;
	 else 
	   nxt_st = LAST;
      end      
   end
endmodule // cipher

//module temp;
//cipher cipher(/*AUTOINST*/);
//endmodule
