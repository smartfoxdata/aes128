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

module aes_top(/*AUTOARG*/
   // Outputs
   oEncValid, oEncReady, oEncData, oDecValid, oDecReady, oDecData,
   // Inputs
   iClk, iRstN, iEncStart, iEncCont, iDecStart, iDecCont, iEncKey,
   iEncData, iDecKey, iDecData
   );

   input iClk, iRstN;
   input iEncStart, iEncCont;
   input iDecStart, iDecCont;
   
   input [127:0] iEncKey;
   input [127:0] iEncData;

   input [127:0] iDecKey;
   input [127:0] iDecData;

   output 	  oEncValid;
   output 	  oEncReady;   
   output [127:0] oEncData;

   output 	  oDecValid;
   output 	  oDecReady;   
   output [127:0] oDecData;
   //
   wire 	  oEncValid;
   wire 	  oEncReady;   
   wire [127:0]   oEncData;
   //
   wire 	  oDecValid;
   wire 	  oDecReady;   
   wire [127:0]   oDecData;
   //
   wire [10:0]  encKeyRoundReady;
   wire [127:0] encKeyRound00;
   wire [127:0] encKeyRound01;
   wire [127:0] encKeyRound02;
   wire [127:0] encKeyRound03;
   wire [127:0] encKeyRound04;
   wire [127:0] encKeyRound05;
   wire [127:0] encKeyRound06;
   wire [127:0] encKeyRound07;
   wire [127:0] encKeyRound08;
   wire [127:0] encKeyRound09;
   wire [127:0] encKeyRound10; 
   
   wire 	encStartKey;
   wire 	encStart;
   wire 	encEnd;
   wire 	encBlkEnd;
   //
   wire [10:0]  decKeyRoundReady;
   wire [127:0] decKeyRound00;
   wire [127:0] decKeyRound01;
   wire [127:0] decKeyRound02;
   wire [127:0] decKeyRound03;
   wire [127:0] decKeyRound04;
   wire [127:0] decKeyRound05;
   wire [127:0] decKeyRound06;
   wire [127:0] decKeyRound07;
   wire [127:0] decKeyRound08;
   wire [127:0] decKeyRound09;
   wire [127:0] decKeyRound10; 
   	
   wire 	decStartKey;
   wire 	decStart;
   wire 	decEnd;
   wire 	decBlkEnd;

   //----------------------- ENCRYPT -----------------------
   if_sm if_sm_enc(
		   // Outputs
		   .oStartKey	(encStartKey),
		   .oStart	(encStart),
		   .oValid	(oEncValid),
		   .oReady	(oEncReady),
		   .oEnd	(encEnd),
		   // Inputs
		   .iClk	(iClk),
		   .iRstN	(iRstN),
		   .iStart	(iEncStart),
		   .iCont	(iEncCont),
		   .iBlkEnd	(encBlkEnd));   

   keyexp keyexp_enc(
		     // Outputs
		     .oKeyRoundReady    (encKeyRoundReady[10:0]),
		     .oKeyRound00	(encKeyRound00[127:0]),
		     .oKeyRound01	(encKeyRound01[127:0]),
		     .oKeyRound02	(encKeyRound02[127:0]),
		     .oKeyRound03	(encKeyRound03[127:0]),
		     .oKeyRound04	(encKeyRound04[127:0]),
		     .oKeyRound05	(encKeyRound05[127:0]),
		     .oKeyRound06	(encKeyRound06[127:0]),
		     .oKeyRound07	(encKeyRound07[127:0]),
		     .oKeyRound08	(encKeyRound08[127:0]),
		     .oKeyRound09	(encKeyRound09[127:0]),
		     .oKeyRound10	(encKeyRound10[127:0]),
		     // Inputs
		     .iClk	(iClk),
		     .iRstN	(iRstN),
		     .iStartKey	(encStartKey),
		     .iEnd	(encEnd),
		     .iKey	(iEncKey[127:0]));


   cipher cipher(
		 // Outputs
		 .oEncBlkEnd		(encBlkEnd),
		 .oEncData		(oEncData[127:0]),
		 // Inputs
		 .iClk			(iClk),
		 .iRstN			(iRstN),
		 .iEncStart		(encStart),
		 .iEncData		(iEncData[127:0]),
		 .iEncKeyRoundReady	(encKeyRoundReady[10:0]),
		 .iEncKeyRound00	(encKeyRound00[127:0]),
		 .iEncKeyRound01	(encKeyRound01[127:0]),
		 .iEncKeyRound02	(encKeyRound02[127:0]),
		 .iEncKeyRound03	(encKeyRound03[127:0]),
		 .iEncKeyRound04	(encKeyRound04[127:0]),
		 .iEncKeyRound05	(encKeyRound05[127:0]),
		 .iEncKeyRound06	(encKeyRound06[127:0]),
		 .iEncKeyRound07	(encKeyRound07[127:0]),
		 .iEncKeyRound08	(encKeyRound08[127:0]),
		 .iEncKeyRound09	(encKeyRound09[127:0]),
		 .iEncKeyRound10	(encKeyRound10[127:0]));

   //----------------------- DECRYPT -----------------------
   if_sm if_sm_dec(
		 // Outputs
		 .oStartKey	(decStartKey),
		 .oStart	(decStart),
		 .oValid	(oDecValid),
		 .oReady	(oDecReady),
		 .oEnd		(decEnd),
		 // Inputs
		 .iClk		(iClk),
		 .iRstN		(iRstN),
		 .iStart	(iDecStart),
		 .iCont		(iDecCont),
		 .iBlkEnd	(decBlkEnd));  

   keyexp keyexp_dec(
		     // Outputs
		     .oKeyRoundReady    (decKeyRoundReady[10:0]),
		     .oKeyRound00	(decKeyRound00[127:0]),
		     .oKeyRound01	(decKeyRound01[127:0]),
		     .oKeyRound02	(decKeyRound02[127:0]),
		     .oKeyRound03	(decKeyRound03[127:0]),
		     .oKeyRound04	(decKeyRound04[127:0]),
		     .oKeyRound05	(decKeyRound05[127:0]),
		     .oKeyRound06	(decKeyRound06[127:0]),
		     .oKeyRound07	(decKeyRound07[127:0]),
		     .oKeyRound08	(decKeyRound08[127:0]),
		     .oKeyRound09	(decKeyRound09[127:0]),
		     .oKeyRound10	(decKeyRound10[127:0]),
		     // Inputs
		     .iClk	(iClk),
		     .iRstN	(iRstN),
		     .iStartKey	(decStartKey),
		     .iEnd	(decEnd),
		     .iKey	(iDecKey[127:0]));

   invcipher invcipher(
		 // Outputs
		 .oDecBlkEnd		(decBlkEnd),
		 .oDecData		(oDecData[127:0]),
		 // Inputs
		 .iClk			(iClk),
		 .iRstN			(iRstN),
		 .iDecStart		(decStart),
		 .iDecData		(iDecData[127:0]),
		 .iDecKeyRoundReady	(decKeyRoundReady[10:0]),
		 .iDecKeyRound00	(decKeyRound00[127:0]),
		 .iDecKeyRound01	(decKeyRound01[127:0]),
		 .iDecKeyRound02	(decKeyRound02[127:0]),
		 .iDecKeyRound03	(decKeyRound03[127:0]),
		 .iDecKeyRound04	(decKeyRound04[127:0]),
		 .iDecKeyRound05	(decKeyRound05[127:0]),
		 .iDecKeyRound06	(decKeyRound06[127:0]),
		 .iDecKeyRound07	(decKeyRound07[127:0]),
		 .iDecKeyRound08	(decKeyRound08[127:0]),
		 .iDecKeyRound09	(decKeyRound09[127:0]),
		 .iDecKeyRound10	(decKeyRound10[127:0]));
   
endmodule

//module temp;
//aes_top aes_top(/*AUTOINST*/);
//endmodule





