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

task mixcolumns;
   input [31:0] iWord;
   output [31:0] oWord;

   reg [31:0] oWord;

   begin
      oWord[31:00] = 32'h0;
      // 02 03 01 01
      oWord[07:00] = gMul2[iWord[07:04]][iWord[03:00]] ^ gMul3[iWord[15:12]][iWord[11:08]] ^ iWord[23:16] ^ iWord[31:24];
      // 01 02 03 01
      oWord[15:08] = iWord[07:00] ^ gMul2[iWord[15:12]][iWord[11:08]] ^ gMul3[iWord[23:20]][iWord[19:16]] ^ iWord[31:24];
      // 01 01 02 03
      oWord[23:16] = iWord[07:00] ^ iWord[15:08] ^ gMul2[iWord[23:20]][iWord[19:16]] ^ gMul3[iWord[31:28]][iWord[27:24]];
      // 03 01 01 02
      oWord[31:24] = gMul3[iWord[07:04]][iWord[03:00]] ^ iWord[15:08] ^ iWord[23:16] ^ gMul2[iWord[31:28]][iWord[27:24]];      	    
   end        

endtask // mixcolumns
