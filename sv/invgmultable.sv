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

// 0e 0b 0d 09

   wire [7:0] gMul9[0:15][0:15] = '{
   '{8'h00,8'h09,8'h12,8'h1b,8'h24,8'h2d,8'h36,8'h3f,8'h48,8'h41,8'h5a,8'h53,8'h6c,8'h65,8'h7e,8'h77},
   '{8'h90,8'h99,8'h82,8'h8b,8'hb4,8'hbd,8'ha6,8'haf,8'hd8,8'hd1,8'hca,8'hc3,8'hfc,8'hf5,8'hee,8'he7},
   '{8'h3b,8'h32,8'h29,8'h20,8'h1f,8'h16,8'h0d,8'h04,8'h73,8'h7a,8'h61,8'h68,8'h57,8'h5e,8'h45,8'h4c},
   '{8'hab,8'ha2,8'hb9,8'hb0,8'h8f,8'h86,8'h9d,8'h94,8'he3,8'hea,8'hf1,8'hf8,8'hc7,8'hce,8'hd5,8'hdc},
   '{8'h76,8'h7f,8'h64,8'h6d,8'h52,8'h5b,8'h40,8'h49,8'h3e,8'h37,8'h2c,8'h25,8'h1a,8'h13,8'h08,8'h01},
   '{8'he6,8'hef,8'hf4,8'hfd,8'hc2,8'hcb,8'hd0,8'hd9,8'hae,8'ha7,8'hbc,8'hb5,8'h8a,8'h83,8'h98,8'h91},
   '{8'h4d,8'h44,8'h5f,8'h56,8'h69,8'h60,8'h7b,8'h72,8'h05,8'h0c,8'h17,8'h1e,8'h21,8'h28,8'h33,8'h3a},
   '{8'hdd,8'hd4,8'hcf,8'hc6,8'hf9,8'hf0,8'heb,8'he2,8'h95,8'h9c,8'h87,8'h8e,8'hb1,8'hb8,8'ha3,8'haa},
   '{8'hec,8'he5,8'hfe,8'hf7,8'hc8,8'hc1,8'hda,8'hd3,8'ha4,8'had,8'hb6,8'hbf,8'h80,8'h89,8'h92,8'h9b},
   '{8'h7c,8'h75,8'h6e,8'h67,8'h58,8'h51,8'h4a,8'h43,8'h34,8'h3d,8'h26,8'h2f,8'h10,8'h19,8'h02,8'h0b},
   '{8'hd7,8'hde,8'hc5,8'hcc,8'hf3,8'hfa,8'he1,8'he8,8'h9f,8'h96,8'h8d,8'h84,8'hbb,8'hb2,8'ha9,8'ha0},
   '{8'h47,8'h4e,8'h55,8'h5c,8'h63,8'h6a,8'h71,8'h78,8'h0f,8'h06,8'h1d,8'h14,8'h2b,8'h22,8'h39,8'h30},
   '{8'h9a,8'h93,8'h88,8'h81,8'hbe,8'hb7,8'hac,8'ha5,8'hd2,8'hdb,8'hc0,8'hc9,8'hf6,8'hff,8'he4,8'hed},
   '{8'h0a,8'h03,8'h18,8'h11,8'h2e,8'h27,8'h3c,8'h35,8'h42,8'h4b,8'h50,8'h59,8'h66,8'h6f,8'h74,8'h7d},
   '{8'ha1,8'ha8,8'hb3,8'hba,8'h85,8'h8c,8'h97,8'h9e,8'he9,8'he0,8'hfb,8'hf2,8'hcd,8'hc4,8'hdf,8'hd6},
   '{8'h31,8'h38,8'h23,8'h2a,8'h15,8'h1c,8'h07,8'h0e,8'h79,8'h70,8'h6b,8'h62,8'h5d,8'h54,8'h4f,8'h46}
				    };

   wire [7:0] gMulB[0:15][0:15] = '{
   '{8'h00,8'h0b,8'h16,8'h1d,8'h2c,8'h27,8'h3a,8'h31,8'h58,8'h53,8'h4e,8'h45,8'h74,8'h7f,8'h62,8'h69},
   '{8'hb0,8'hbb,8'ha6,8'had,8'h9c,8'h97,8'h8a,8'h81,8'he8,8'he3,8'hfe,8'hf5,8'hc4,8'hcf,8'hd2,8'hd9},
   '{8'h7b,8'h70,8'h6d,8'h66,8'h57,8'h5c,8'h41,8'h4a,8'h23,8'h28,8'h35,8'h3e,8'h0f,8'h04,8'h19,8'h12},
   '{8'hcb,8'hc0,8'hdd,8'hd6,8'he7,8'hec,8'hf1,8'hfa,8'h93,8'h98,8'h85,8'h8e,8'hbf,8'hb4,8'ha9,8'ha2},
   '{8'hf6,8'hfd,8'he0,8'heb,8'hda,8'hd1,8'hcc,8'hc7,8'hae,8'ha5,8'hb8,8'hb3,8'h82,8'h89,8'h94,8'h9f},
   '{8'h46,8'h4d,8'h50,8'h5b,8'h6a,8'h61,8'h7c,8'h77,8'h1e,8'h15,8'h08,8'h03,8'h32,8'h39,8'h24,8'h2f},
   '{8'h8d,8'h86,8'h9b,8'h90,8'ha1,8'haa,8'hb7,8'hbc,8'hd5,8'hde,8'hc3,8'hc8,8'hf9,8'hf2,8'hef,8'he4},
   '{8'h3d,8'h36,8'h2b,8'h20,8'h11,8'h1a,8'h07,8'h0c,8'h65,8'h6e,8'h73,8'h78,8'h49,8'h42,8'h5f,8'h54},
   '{8'hf7,8'hfc,8'he1,8'hea,8'hdb,8'hd0,8'hcd,8'hc6,8'haf,8'ha4,8'hb9,8'hb2,8'h83,8'h88,8'h95,8'h9e},
   '{8'h47,8'h4c,8'h51,8'h5a,8'h6b,8'h60,8'h7d,8'h76,8'h1f,8'h14,8'h09,8'h02,8'h33,8'h38,8'h25,8'h2e},
   '{8'h8c,8'h87,8'h9a,8'h91,8'ha0,8'hab,8'hb6,8'hbd,8'hd4,8'hdf,8'hc2,8'hc9,8'hf8,8'hf3,8'hee,8'he5},
   '{8'h3c,8'h37,8'h2a,8'h21,8'h10,8'h1b,8'h06,8'h0d,8'h64,8'h6f,8'h72,8'h79,8'h48,8'h43,8'h5e,8'h55},
   '{8'h01,8'h0a,8'h17,8'h1c,8'h2d,8'h26,8'h3b,8'h30,8'h59,8'h52,8'h4f,8'h44,8'h75,8'h7e,8'h63,8'h68},
   '{8'hb1,8'hba,8'ha7,8'hac,8'h9d,8'h96,8'h8b,8'h80,8'he9,8'he2,8'hff,8'hf4,8'hc5,8'hce,8'hd3,8'hd8},
   '{8'h7a,8'h71,8'h6c,8'h67,8'h56,8'h5d,8'h40,8'h4b,8'h22,8'h29,8'h34,8'h3f,8'h0e,8'h05,8'h18,8'h13},
   '{8'hca,8'hc1,8'hdc,8'hd7,8'he6,8'hed,8'hf0,8'hfb,8'h92,8'h99,8'h84,8'h8f,8'hbe,8'hb5,8'ha8,8'ha3}
				    };

   wire [7:0] gMulD[0:15][0:15] = '{
   '{8'h00,8'h0d,8'h1a,8'h17,8'h34,8'h39,8'h2e,8'h23,8'h68,8'h65,8'h72,8'h7f,8'h5c,8'h51,8'h46,8'h4b},
   '{8'hd0,8'hdd,8'hca,8'hc7,8'he4,8'he9,8'hfe,8'hf3,8'hb8,8'hb5,8'ha2,8'haf,8'h8c,8'h81,8'h96,8'h9b},
   '{8'hbb,8'hb6,8'ha1,8'hac,8'h8f,8'h82,8'h95,8'h98,8'hd3,8'hde,8'hc9,8'hc4,8'he7,8'hea,8'hfd,8'hf0},
   '{8'h6b,8'h66,8'h71,8'h7c,8'h5f,8'h52,8'h45,8'h48,8'h03,8'h0e,8'h19,8'h14,8'h37,8'h3a,8'h2d,8'h20},
   '{8'h6d,8'h60,8'h77,8'h7a,8'h59,8'h54,8'h43,8'h4e,8'h05,8'h08,8'h1f,8'h12,8'h31,8'h3c,8'h2b,8'h26},
   '{8'hbd,8'hb0,8'ha7,8'haa,8'h89,8'h84,8'h93,8'h9e,8'hd5,8'hd8,8'hcf,8'hc2,8'he1,8'hec,8'hfb,8'hf6},
   '{8'hd6,8'hdb,8'hcc,8'hc1,8'he2,8'hef,8'hf8,8'hf5,8'hbe,8'hb3,8'ha4,8'ha9,8'h8a,8'h87,8'h90,8'h9d},
   '{8'h06,8'h0b,8'h1c,8'h11,8'h32,8'h3f,8'h28,8'h25,8'h6e,8'h63,8'h74,8'h79,8'h5a,8'h57,8'h40,8'h4d},
   '{8'hda,8'hd7,8'hc0,8'hcd,8'hee,8'he3,8'hf4,8'hf9,8'hb2,8'hbf,8'ha8,8'ha5,8'h86,8'h8b,8'h9c,8'h91},
   '{8'h0a,8'h07,8'h10,8'h1d,8'h3e,8'h33,8'h24,8'h29,8'h62,8'h6f,8'h78,8'h75,8'h56,8'h5b,8'h4c,8'h41},
   '{8'h61,8'h6c,8'h7b,8'h76,8'h55,8'h58,8'h4f,8'h42,8'h09,8'h04,8'h13,8'h1e,8'h3d,8'h30,8'h27,8'h2a},
   '{8'hb1,8'hbc,8'hab,8'ha6,8'h85,8'h88,8'h9f,8'h92,8'hd9,8'hd4,8'hc3,8'hce,8'hed,8'he0,8'hf7,8'hfa},
   '{8'hb7,8'hba,8'had,8'ha0,8'h83,8'h8e,8'h99,8'h94,8'hdf,8'hd2,8'hc5,8'hc8,8'heb,8'he6,8'hf1,8'hfc},
   '{8'h67,8'h6a,8'h7d,8'h70,8'h53,8'h5e,8'h49,8'h44,8'h0f,8'h02,8'h15,8'h18,8'h3b,8'h36,8'h21,8'h2c},
   '{8'h0c,8'h01,8'h16,8'h1b,8'h38,8'h35,8'h22,8'h2f,8'h64,8'h69,8'h7e,8'h73,8'h50,8'h5d,8'h4a,8'h47},
   '{8'hdc,8'hd1,8'hc6,8'hcb,8'he8,8'he5,8'hf2,8'hff,8'hb4,8'hb9,8'hae,8'ha3,8'h80,8'h8d,8'h9a,8'h97}
				    };

   wire [7:0] gMulE[0:15][0:15] = '{
   '{8'h00,8'h0e,8'h1c,8'h12,8'h38,8'h36,8'h24,8'h2a,8'h70,8'h7e,8'h6c,8'h62,8'h48,8'h46,8'h54,8'h5a},
   '{8'he0,8'hee,8'hfc,8'hf2,8'hd8,8'hd6,8'hc4,8'hca,8'h90,8'h9e,8'h8c,8'h82,8'ha8,8'ha6,8'hb4,8'hba},
   '{8'hdb,8'hd5,8'hc7,8'hc9,8'he3,8'hed,8'hff,8'hf1,8'hab,8'ha5,8'hb7,8'hb9,8'h93,8'h9d,8'h8f,8'h81},
   '{8'h3b,8'h35,8'h27,8'h29,8'h03,8'h0d,8'h1f,8'h11,8'h4b,8'h45,8'h57,8'h59,8'h73,8'h7d,8'h6f,8'h61},
   '{8'had,8'ha3,8'hb1,8'hbf,8'h95,8'h9b,8'h89,8'h87,8'hdd,8'hd3,8'hc1,8'hcf,8'he5,8'heb,8'hf9,8'hf7},
   '{8'h4d,8'h43,8'h51,8'h5f,8'h75,8'h7b,8'h69,8'h67,8'h3d,8'h33,8'h21,8'h2f,8'h05,8'h0b,8'h19,8'h17},
   '{8'h76,8'h78,8'h6a,8'h64,8'h4e,8'h40,8'h52,8'h5c,8'h06,8'h08,8'h1a,8'h14,8'h3e,8'h30,8'h22,8'h2c},
   '{8'h96,8'h98,8'h8a,8'h84,8'hae,8'ha0,8'hb2,8'hbc,8'he6,8'he8,8'hfa,8'hf4,8'hde,8'hd0,8'hc2,8'hcc},
   '{8'h41,8'h4f,8'h5d,8'h53,8'h79,8'h77,8'h65,8'h6b,8'h31,8'h3f,8'h2d,8'h23,8'h09,8'h07,8'h15,8'h1b},
   '{8'ha1,8'haf,8'hbd,8'hb3,8'h99,8'h97,8'h85,8'h8b,8'hd1,8'hdf,8'hcd,8'hc3,8'he9,8'he7,8'hf5,8'hfb},
   '{8'h9a,8'h94,8'h86,8'h88,8'ha2,8'hac,8'hbe,8'hb0,8'hea,8'he4,8'hf6,8'hf8,8'hd2,8'hdc,8'hce,8'hc0},
   '{8'h7a,8'h74,8'h66,8'h68,8'h42,8'h4c,8'h5e,8'h50,8'h0a,8'h04,8'h16,8'h18,8'h32,8'h3c,8'h2e,8'h20},
   '{8'hec,8'he2,8'hf0,8'hfe,8'hd4,8'hda,8'hc8,8'hc6,8'h9c,8'h92,8'h80,8'h8e,8'ha4,8'haa,8'hb8,8'hb6},
   '{8'h0c,8'h02,8'h10,8'h1e,8'h34,8'h3a,8'h28,8'h26,8'h7c,8'h72,8'h60,8'h6e,8'h44,8'h4a,8'h58,8'h56},
   '{8'h37,8'h39,8'h2b,8'h25,8'h0f,8'h01,8'h13,8'h1d,8'h47,8'h49,8'h5b,8'h55,8'h7f,8'h71,8'h63,8'h6d},
   '{8'hd7,8'hd9,8'hcb,8'hc5,8'hef,8'he1,8'hf3,8'hfd,8'ha7,8'ha9,8'hbb,8'hb5,8'h9f,8'h91,8'h83,8'h8d}
				    };
