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

task invmixcolumns;
   input [31:0] iWord;
   output [31:0] oWord;

   reg [31:0] oWord;
   
   begin
      oWord[31:00] = 32'h0;
      // 0e 0b 0d 09
      oWord[07:00] = gMulE[iWord[07:04]][iWord[03:00]] ^ gMulB[iWord[15:12]][iWord[11:08]] ^ gMulD[iWord[23:20]][iWord[19:16]] ^ gMul9[iWord[31:28]][iWord[27:24]];
      // 09 0e 0b 0d
      oWord[15:08] = gMul9[iWord[07:04]][iWord[03:00]] ^ gMulE[iWord[15:12]][iWord[11:08]] ^ gMulB[iWord[23:20]][iWord[19:16]] ^ gMulD[iWord[31:28]][iWord[27:24]];
      // 0d 09 0e 0b
      oWord[23:16] = gMulD[iWord[07:04]][iWord[03:00]] ^ gMul9[iWord[15:12]][iWord[11:08]] ^ gMulE[iWord[23:20]][iWord[19:16]] ^ gMulB[iWord[31:28]][iWord[27:24]];
      // 0b 0d 09 0e
      oWord[31:24] = gMulB[iWord[07:04]][iWord[03:00]] ^ gMulD[iWord[15:12]][iWord[11:08]] ^ gMul9[iWord[23:20]][iWord[19:16]] ^ gMulE[iWord[31:28]][iWord[27:24]];
   end        

endtask // mixcolumns
