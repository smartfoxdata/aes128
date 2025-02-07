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

module keyexp(/*AUTOARG*/
   // Outputs
   oKeyRoundReady, oKeyRound00, oKeyRound01, oKeyRound02,
   oKeyRound03, oKeyRound04, oKeyRound05, oKeyRound06,
   oKeyRound07, oKeyRound08, oKeyRound09, oKeyRound10,
   // Inputs
   iClk, iRstN, iStartKey, iEnd, iKey
   );
   // input
   input iClk, iRstN;
   input iStartKey, iEnd;
   input [127:0] iKey;
   // output
   output [10:0]  oKeyRoundReady;
   output [127:0] oKeyRound00;
   output [127:0] oKeyRound01;
   output [127:0] oKeyRound02;
   output [127:0] oKeyRound03;
   output [127:0] oKeyRound04;
   output [127:0] oKeyRound05;
   output [127:0] oKeyRound06;
   output [127:0] oKeyRound07;
   output [127:0] oKeyRound08;
   output [127:0] oKeyRound09;
   output [127:0] oKeyRound10;

   //
   reg [10:0]  oKeyRoundReady;
   reg [127:0] oKeyRound00;
   reg [127:0] oKeyRound01;
   reg [127:0] oKeyRound02;
   reg [127:0] oKeyRound03;
   reg [127:0] oKeyRound04;
   reg [127:0] oKeyRound05;
   reg [127:0] oKeyRound06;
   reg [127:0] oKeyRound07;
   reg [127:0] oKeyRound08;
   reg [127:0] oKeyRound09;
   reg [127:0] oKeyRound10;
   
   // parameter
   parameter Nr = 10;
   parameter Nb = 4;
   parameter Nk = 4;

   // Initialize
   reg [31:0] 	  keyword[3:0];
   int 		  i;
   //
   reg [3:0] round;
   reg [2:0] cur_st;
   reg [2:0] nxt_st;
   
   parameter st_idle  = 0;
   parameter st_run   = 1;
   parameter st_stop  = 2;

   parameter IDLE = 3'h1;
   parameter RUN  = 3'h2;
   parameter STOP = 3'h4;
   //
   reg [31:0] temp;
   reg [31:0] rotw;
   reg [31:0] subb;
   reg [31:0] keyw[3:0];
   
   // Rcon
   wire [7:0] 	  rcon[10:0] = '{8'h36, 8'h1b, 8'h80, 8'h40, 8'h20, 8'h10, 8'h08, 8'h04, 8'h02, 8'h01, 8'h8d};

   `include "subtable.sv"
   `include "subbytes.sv"
   `include "rotword1.sv"

   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 round  <= 4'h0;
	 cur_st <= IDLE;	 
      end
      else begin
	 if(nxt_st[st_idle])
	   round  <= 4'h0;
	 else
	   round  <= (nxt_st[st_run] | cur_st[st_run]) ? round + 1 : round;

	 cur_st <= nxt_st;
      end
   end

   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 for(i=0; i<Nk; i++) begin
	    keyword[i] <= 32'h0;
	 end 
         oKeyRound00[127:0] <= 128'h0;   
         oKeyRound01[127:0] <= 128'h0;   
         oKeyRound02[127:0] <= 128'h0;
         oKeyRound03[127:0] <= 128'h0;   
         oKeyRound04[127:0] <= 128'h0;
         oKeyRound05[127:0] <= 128'h0;   
         oKeyRound06[127:0] <= 128'h0;
         oKeyRound07[127:0] <= 128'h0;   
         oKeyRound08[127:0] <= 128'h0;
         oKeyRound09[127:0] <= 128'h0;   
         oKeyRound10[127:0] <= 128'h0;

	 oKeyRoundReady[10:0] <= 10'h0;
      end
      else begin
	if (iStartKey) begin
	   keyword[0] <= iKey[31:00];
	   keyword[1] <= iKey[63:32];
	   keyword[2] <= iKey[95:64];
	   keyword[3] <= iKey[127:96];	   
	end
	else begin
	   for(i=0; i<Nk; i++) begin
	      keyword[i] <= keyw[i];
	   end
	end

	if (cur_st[st_run] | nxt_st[st_run]) begin
	   case(round)
	     4'h0: oKeyRound00[127:0] <= iKey[127:0];
	     4'h1: oKeyRound01[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h2: oKeyRound02[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h3: oKeyRound03[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h4: oKeyRound04[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h5: oKeyRound05[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h6: oKeyRound06[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h7: oKeyRound07[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h8: oKeyRound08[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'h9: oKeyRound09[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     4'ha: oKeyRound10[127:0] <= {keyw[3],keyw[2],keyw[1],keyw[0]};
	     default: begin
		oKeyRound00[127:0] <= oKeyRound00[127:0];
		oKeyRound01[127:0] <= oKeyRound01[127:0];
		oKeyRound02[127:0] <= oKeyRound02[127:0];
		oKeyRound03[127:0] <= oKeyRound03[127:0];
		oKeyRound04[127:0] <= oKeyRound04[127:0];
		oKeyRound05[127:0] <= oKeyRound05[127:0];
		oKeyRound06[127:0] <= oKeyRound06[127:0];
		oKeyRound07[127:0] <= oKeyRound07[127:0];
		oKeyRound08[127:0] <= oKeyRound08[127:0];
		oKeyRound09[127:0] <= oKeyRound09[127:0];
		oKeyRound10[127:0] <= oKeyRound10[127:0];
	     end
	   endcase // case (round)
	end // if (cur_st[st_run])

	 if(nxt_st[st_idle]) begin
	    oKeyRoundReady[10:0] <= 10'h0;
	 end
	 else if(nxt_st[st_run] | cur_st[st_run]) begin
	    case(round)
	     4'h0: oKeyRoundReady[00] <= 1'b1;
	     4'h1: oKeyRoundReady[01] <= 1'b1;
	     4'h2: oKeyRoundReady[02] <= 1'b1;
	     4'h3: oKeyRoundReady[03] <= 1'b1;
	     4'h4: oKeyRoundReady[04] <= 1'b1;
	     4'h5: oKeyRoundReady[05] <= 1'b1;
	     4'h6: oKeyRoundReady[06] <= 1'b1;
	     4'h7: oKeyRoundReady[07] <= 1'b1;
	     4'h8: oKeyRoundReady[08] <= 1'b1;
	     4'h9: oKeyRoundReady[09] <= 1'b1;
	     4'ha: oKeyRoundReady[10] <= 1'b1;
	     default: oKeyRoundReady[10:0] <= oKeyRoundReady[10:0];
	    endcase
	 end
      end // else: !if(~iRstN)
   end // always @ (posedge iClk or negedge iRstN)
   
   
   always @* begin
      nxt_st = IDLE;
      
      temp = 32'h0;
      rotw = 32'h0;      
      subb = 32'h0;

      keyw[3] = 32'h0;
      keyw[2] = 32'h0;
      keyw[1] = 32'h0;
      keyw[0] = 32'h0;
      //
      if(cur_st[st_idle]) begin
	 if(iStartKey)
	   nxt_st = RUN;
	 else
	   nxt_st = IDLE;
      end
      //
      if(cur_st[st_run]) begin
	 //
	 rotword1(keyword[3], rotw);
	 //
	 subbytes(rotw[07:00], subb[07:00]);
	 subbytes(rotw[15:08], subb[15:08]);
	 subbytes(rotw[23:16], subb[23:16]);
	 subbytes(rotw[31:24], subb[31:24]);
	 //
	 temp = subb[31:0] ^ {{24{1'b0}}, rcon[round]};
	 
	 keyw[0] = keyword[0] ^ temp;
	 keyw[1] = keyword[1] ^ keyw[0];
	 keyw[2] = keyword[2] ^ keyw[1];
	 keyw[3] = keyword[3] ^ keyw[2];

	 if(round == Nr)
	   nxt_st = STOP;
	 else
	   nxt_st = RUN;
      end
      //
      if(cur_st[st_stop]) begin
	 if(iEnd)
	   nxt_st = IDLE;
	 else
	   nxt_st = STOP;
      end
   end // always @ *


endmodule

//module temp;
//keyexp keyexp(/*AUTOINST*/);
//endmodule
