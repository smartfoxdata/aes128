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

module if_sm(/*AUTOARG*/
   // Outputs
   oStartKey, oStart, oValid, oReady, oEnd,
   // Inputs
   iClk, iRstN, iStart, iCont, iBlkEnd
   );
   //
   input iClk, iRstN;
   input iStart, iCont, iBlkEnd;
   //
   output oStartKey, oStart, oValid, oReady, oEnd;
   //
   reg 	  oStartKey, oStart, oValid, oReady, oEnd;
   
   reg 	  valid;
   reg 	  oValidQ;
   
   //
   reg [2:0] cur_st;
   reg [2:0] nxt_st;
   
   parameter st_idle = 0;
   parameter st_run  = 1;
   parameter st_next = 2;

   parameter IDLE  = 3'h1;
   parameter RUN   = 3'h2;   
   parameter NEXT  = 3'h4;
   
   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 cur_st <= IDLE;
      end
      else begin
	 cur_st <= nxt_st;
      end
   end
   //
   always @(posedge iClk or negedge iRstN) begin
      if(~iRstN) begin
	 oValid  <= 1'b0;
	 oValidQ <= 1'b0;
	 oReady <= 1'b0;

      end
      else begin
	 oValid <= valid;
	 oValidQ <= oValid;

	 if(nxt_st[st_idle])
	   oReady <= 1'b1;
	 else
	   oReady <= 1'b0;
      end
   end
   //
   always @* begin
      oStartKey = 1'b0;
      oStart    = 1'b0;
      oEnd      = 1'b0;

      valid = 1'b0;
      //
      if(cur_st[st_idle]) begin
	 if(iStart) begin
	    oStartKey = 1'b1;
	    oStart = 1'b1;

	    nxt_st = RUN;
	 end
	 else
	    nxt_st = IDLE;

      end
      //
      if(cur_st[st_run]) begin
	 if(iBlkEnd) begin
	    valid = 1'b1;
	    nxt_st = NEXT;
	 end
	 else
	   nxt_st = RUN;	   
      end      
      //
      if(cur_st[st_next]) begin
	 if(oValidQ) begin
	    if(iCont) begin
	       oStart = 1'b1;
	       nxt_st = RUN;
	    end
	    else begin
	       oEnd   = 1'b1;
	       nxt_st = IDLE;
	    end
	 end
	 else
	   nxt_st = NEXT;	   
      end
   end
   
endmodule

//module temp;
//if_sm if_sm(/*AUTOINST*/);
//endmodule
