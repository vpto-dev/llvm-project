//===- ValueTypes.td - ValueType definitions ---------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// ValueTypes.td - list of ValueType instances supported by the the
// CodeGen infrastructure.
//
//===----------------------------------------------------------------------===//

class ValueType<int size, int value> {
  string Namespace = "MVT";
  string LLVMName = NAME;
  int Size = size;
  int Value = value;
  int nElem = 1;
  ValueType ElementType = ?;
  bit isOverloaded = false;
  bit isInteger = false;
  bit isFP = false;
  bit isVector = false;
  bit isScalable = false;
  int NF = 0;
  bit isRISCVVecTuple = false;
  // Indicates this VT should be included in the
  // [FIRST_VALUETYPE,LAST_VALUETYPE] range.
  bit isNormalValueType = true;
}

class VTAny<int value> : ValueType<0, value> {
  let isOverloaded = true;
}

class VTInt<int size, int value>
    : ValueType<size, value> {
  let isInteger = true;
}

class VTFP<int size, int value>
    : ValueType<size, value> {
  let isFP = true;
}

class VTVec<int nelem, ValueType elt, int value>
    : ValueType<!mul(nelem, elt.Size), value> {
  let nElem = nelem;
  let ElementType = elt;
  let isInteger = elt.isInteger;
  let isFP = elt.isFP;
  let isVector = true;
}

class VTScalableVec<int nelem, ValueType elt, int value>
    : VTVec<nelem, elt, value> {
  let isScalable = true;
}

class VTVecTup<int size, int nf, ValueType dummy_elt, int value>
    : ValueType<size, value> {
  let NF = nf;
  let ElementType = dummy_elt;
  let isRISCVVecTuple = true;
}

defset list<ValueType> ValueTypes = {

def OtherVT : ValueType<0,   1> {  // "Other" value
  let LLVMName = "Other";
}

def i1      : VTInt<1,   2>;  // One bit boolean value
def i2      : VTInt<2,   3>;  // 2-bit integer value
def i4      : VTInt<4,   4>;  // 4-bit integer value
def i8      : VTInt<8,   5>;  // 8-bit integer value
def i16     : VTInt<16,  6>;  // 16-bit integer value
def i32     : VTInt<32,  7>;  // 32-bit integer value
def i64     : VTInt<64,  8>;  // 64-bit integer value
def i128    : VTInt<128, 9>;  // 128-bit integer value

def bf16    : VTFP<16,  10>;  // 16-bit brain floating point value
def f16     : VTFP<16,  11>;  // 16-bit floating point value
def f32     : VTFP<32,  12>;  // 32-bit floating point value
def f64     : VTFP<64,  13>;  // 64-bit floating point value
def f80     : VTFP<80,  14>;  // 80-bit floating point value
def f128    : VTFP<128, 15>;  // 128-bit floating point value
def ppcf128 : VTFP<128, 16>;  // PPC 128-bit floating point value

// Backend-only storage types used to distinguish fp8/fp4 encodings that LLVM
// IR cannot represent natively. They are lowered through same-width integer IR
// types when an IR type is required.
def f4e2m1x2 : ValueType<8, 17>;
def f4e1m2x2 : ValueType<8, 18>;
def hif4x2   : ValueType<8, 19>;
def hif8     : ValueType<8, 20>;
def f8e4m3   : ValueType<8, 21>;
def f8e5m2   : ValueType<8, 22>;
def f8e8m0   : ValueType<8, 23>;

def v1i1    : VTVec<1,    i1, 24>;  //    1 x i1 vector value
def v2i1    : VTVec<2,    i1, 25>;  //    2 x i1 vector value
def v3i1    : VTVec<3,    i1, 26>;  //    3 x i1 vector value
def v4i1    : VTVec<4,    i1, 27>;  //    4 x i1 vector value
def v8i1    : VTVec<8,    i1, 28>;  //    8 x i1 vector value
def v16i1   : VTVec<16,   i1, 29>;  //   16 x i1 vector value
def v32i1   : VTVec<32,   i1, 30>;  //   32 x i1 vector value
def v64i1   : VTVec<64,   i1, 31>;  //   64 x i1 vector value
def v128i1  : VTVec<128,  i1, 32>;  //  128 x i1 vector value
def v256i1  : VTVec<256,  i1, 33>;  //  256 x i1 vector value
def v512i1  : VTVec<512,  i1, 34>;  //  512 x i1 vector value
def v1024i1 : VTVec<1024, i1, 35>;  // 1024 x i1 vector value
def v2048i1 : VTVec<2048, i1, 36>;  // 2048 x i1 vector value
def v4096i1 : VTVec<4096, i1, 37>;  // 4096 x i1 vector value

def v128i2  : VTVec<128,  i2, 38>;   //  128 x i2 vector value
def v256i2  : VTVec<256,  i2, 39>;   //  256 x i2 vector value

def v64i4   : VTVec<64,   i4, 40>;   //   64 x i4 vector value
def v128i4  : VTVec<128,  i4, 41>;   //  128 x i4 vector value

def v1i8    : VTVec<1,    i8, 42>;  //    1 x i8 vector value
def v2i8    : VTVec<2,    i8, 43>;  //    2 x i8 vector value
def v3i8    : VTVec<3,    i8, 44>;  //    3 x i8 vector value
def v4i8    : VTVec<4,    i8, 45>;  //    4 x i8 vector value
def v8i8    : VTVec<8,    i8, 46>;  //    8 x i8 vector value
def v16i8   : VTVec<16,   i8, 47>;  //   16 x i8 vector value
def v32i8   : VTVec<32,   i8, 48>;  //   32 x i8 vector value
def v64i8   : VTVec<64,   i8, 49>;  //   64 x i8 vector value
def v128i8  : VTVec<128,  i8, 50>;  //  128 x i8 vector value
def v256i8  : VTVec<256,  i8, 51>;  //  256 x i8 vector value
def v512i8  : VTVec<512,  i8, 52>;  //  512 x i8 vector value
def v1024i8 : VTVec<1024, i8, 53>;  // 1024 x i8 vector value

def v1i16    : VTVec<1,    i16, 54>;  //    1 x i16 vector value
def v2i16    : VTVec<2,    i16, 55>;  //    2 x i16 vector value
def v3i16    : VTVec<3,    i16, 56>;  //    3 x i16 vector value
def v4i16    : VTVec<4,    i16, 57>;  //    4 x i16 vector value
def v8i16    : VTVec<8,    i16, 58>;  //    8 x i16 vector value
def v16i16   : VTVec<16,   i16, 59>;  //   16 x i16 vector value
def v32i16   : VTVec<32,   i16, 60>;  //   32 x i16 vector value
def v64i16   : VTVec<64,   i16, 61>;  //   64 x i16 vector value
def v128i16  : VTVec<128,  i16, 62>;  //  128 x i16 vector value
def v256i16  : VTVec<256,  i16, 63>;  //  256 x i16 vector value
def v512i16  : VTVec<512,  i16, 64>;  //  512 x i16 vector value
def v4096i16 : VTVec<4096, i16, 65>;  // 4096 x i16 vector value

def v1i32    : VTVec<1,    i32, 66>;  //    1 x i32 vector value
def v2i32    : VTVec<2,    i32, 67>;  //    2 x i32 vector value
def v3i32    : VTVec<3,    i32, 68>;  //    3 x i32 vector value
def v4i32    : VTVec<4,    i32, 69>;  //    4 x i32 vector value
def v5i32    : VTVec<5,    i32, 70>;  //    5 x i32 vector value
def v6i32    : VTVec<6,    i32, 71>;  //    6 x f32 vector value
def v7i32    : VTVec<7,    i32, 72>;  //    7 x f32 vector value
def v8i32    : VTVec<8,    i32, 73>;  //    8 x i32 vector value
def v9i32    : VTVec<9,    i32, 74>;  //    9 x i32 vector value
def v10i32   : VTVec<10,   i32, 75>;  //   10 x i32 vector value
def v11i32   : VTVec<11,   i32, 76>;  //   11 x i32 vector value
def v12i32   : VTVec<12,   i32, 77>;  //   12 x i32 vector value
def v16i32   : VTVec<16,   i32, 78>;  //   16 x i32 vector value
def v32i32   : VTVec<32,   i32, 79>;  //   32 x i32 vector value
def v64i32   : VTVec<64,   i32, 80>;  //   64 x i32 vector value
def v128i32  : VTVec<128,  i32, 81>;  //  128 x i32 vector value
def v256i32  : VTVec<256,  i32, 82>;  //  256 x i32 vector value
def v512i32  : VTVec<512,  i32, 83>;  //  512 x i32 vector value
def v1024i32 : VTVec<1024, i32, 84>;  // 1024 x i32 vector value
def v2048i32 : VTVec<2048, i32, 85>;  // 2048 x i32 vector value
def v4096i32 : VTVec<4096, i32, 86>;  // 4096 x i32 vector value

def v1i64   : VTVec<1,   i64, 87>;  //   1 x i64 vector value
def v2i64   : VTVec<2,   i64, 88>;  //   2 x i64 vector value
def v3i64   : VTVec<3,   i64, 89>;  //   3 x i64 vector value
def v4i64   : VTVec<4,   i64, 90>;  //   4 x i64 vector value
def v8i64   : VTVec<8,   i64, 91>;  //   8 x i64 vector value
def v16i64  : VTVec<16,  i64, 92>;  //  16 x i64 vector value
def v32i64  : VTVec<32,  i64, 93>;  //  32 x i64 vector value
def v64i64  : VTVec<64,  i64, 94>;  //  64 x i64 vector value
def v128i64 : VTVec<128, i64, 95>;  // 128 x i64 vector value
def v256i64 : VTVec<256, i64, 96>;  // 256 x i64 vector value

def v1i128  : VTVec<1,  i128, 97>;  //  1 x i128 vector value

def v1f16    : VTVec<1,    f16,  98>;  //    1 x f16 vector value
def v2f16    : VTVec<2,    f16,  99>;  //    2 x f16 vector value
def v3f16    : VTVec<3,    f16,  100>;  //    3 x f16 vector value
def v4f16    : VTVec<4,    f16,  101>;  //    4 x f16 vector value
def v8f16    : VTVec<8,    f16,  102>;  //    8 x f16 vector value
def v16f16   : VTVec<16,   f16,  103>;  //   16 x f16 vector value
def v32f16   : VTVec<32,   f16,  104>;  //   32 x f16 vector value
def v64f16   : VTVec<64,   f16,  105>;  //   64 x f16 vector value
def v128f16  : VTVec<128,  f16,  106>;  //  128 x f16 vector value
def v256f16  : VTVec<256,  f16, 107>;  //  256 x f16 vector value
def v512f16  : VTVec<512,  f16, 108>;  //  512 x f16 vector value
def v4096f16 : VTVec<4096, f16, 109>;  // 4096 x f16 vector value

def v1bf16    : VTVec<1,    bf16, 110>;  //    1 x bf16 vector value
def v2bf16    : VTVec<2,    bf16, 111>;  //    2 x bf16 vector value
def v3bf16    : VTVec<3,    bf16, 112>;  //    3 x bf16 vector value
def v4bf16    : VTVec<4,    bf16, 113>;  //    4 x bf16 vector value
def v8bf16    : VTVec<8,    bf16, 114>;  //    8 x bf16 vector value
def v16bf16   : VTVec<16,   bf16, 115>;  //   16 x bf16 vector value
def v32bf16   : VTVec<32,   bf16, 116>;  //   32 x bf16 vector value
def v64bf16   : VTVec<64,   bf16, 117>;  //   64 x bf16 vector value
def v128bf16  : VTVec<128,  bf16, 118>;  //  128 x bf16 vector value
def v4096bf16 : VTVec<4096, bf16, 119>;  // 4096 x bf16 vector value

def v1f32    : VTVec<1,    f32, 120>;  //    1 x f32 vector value
def v2f32    : VTVec<2,    f32, 121>;  //    2 x f32 vector value
def v3f32    : VTVec<3,    f32, 122>;  //    3 x f32 vector value
def v4f32    : VTVec<4,    f32, 123>;  //    4 x f32 vector value
def v5f32    : VTVec<5,    f32, 124>;  //    5 x f32 vector value
def v6f32    : VTVec<6,    f32, 125>;  //    6 x f32 vector value
def v7f32    : VTVec<7,    f32, 126>;  //    7 x f32 vector value
def v8f32    : VTVec<8,    f32, 127>;  //    8 x f32 vector value
def v9f32    : VTVec<9,    f32, 128>;  //    9 x f32 vector value
def v10f32   : VTVec<10,   f32, 129>;  //   10 x f32 vector value
def v11f32   : VTVec<11,   f32, 130>;  //   11 x f32 vector value
def v12f32   : VTVec<12,   f32, 131>;  //   12 x f32 vector value
def v16f32   : VTVec<16,   f32, 132>;  //   16 x f32 vector value
def v32f32   : VTVec<32,   f32, 133>;  //   32 x f32 vector value
def v64f32   : VTVec<64,   f32, 134>;  //   64 x f32 vector value
def v128f32  : VTVec<128,  f32, 135>;  //  128 x f32 vector value
def v256f32  : VTVec<256,  f32, 136>;  //  256 x f32 vector value
def v512f32  : VTVec<512,  f32, 137>;  //  512 x f32 vector value
def v1024f32 : VTVec<1024, f32, 138>;  // 1024 x f32 vector value
def v2048f32 : VTVec<2048, f32, 139>;  // 2048 x f32 vector value

def v1f64    : VTVec<1,    f64, 140>;  //    1 x f64 vector value
def v2f64    : VTVec<2,    f64, 141>;  //    2 x f64 vector value
def v3f64    : VTVec<3,    f64, 142>;  //    3 x f64 vector value
def v4f64    : VTVec<4,    f64, 143>;  //    4 x f64 vector value
def v8f64    : VTVec<8,    f64, 144>;  //    8 x f64 vector value
def v16f64   : VTVec<16,   f64, 145>;  //   16 x f64 vector value
def v32f64   : VTVec<32,   f64, 146>;  //   32 x f64 vector value
def v64f64   : VTVec<64,   f64, 147>;  //   64 x f64 vector value
def v128f64  : VTVec<128,  f64, 148>;  //  128 x f64 vector value
def v256f64  : VTVec<256,  f64, 149>;  //  256 x f64 vector value

def v2f4e2m1x2 : VTVec<2, f4e2m1x2, 150>;  //    2 x f4e2m1x2 vector value
def v256f4e2m1x2 : VTVec<256, f4e2m1x2, 151>;  //  256 x f4e2m1x2 vector value
def v512f4e2m1x2 : VTVec<512, f4e2m1x2, 152>;  //  512 x f4e2m1x2 vector value
def v2f4e1m2x2 : VTVec<2, f4e1m2x2, 153>;  //    2 x f4e1m2x2 vector value
def v256f4e1m2x2 : VTVec<256, f4e1m2x2, 154>;  //  256 x f4e1m2x2 vector value
def v512f4e1m2x2 : VTVec<512, f4e1m2x2, 155>;  //  512 x f4e1m2x2 vector value
def v2hif4x2   : VTVec<2, hif4x2, 156>;  //    2 x hif4x2 vector value
def v256hif4x2 : VTVec<256, hif4x2, 157>;  //  256 x hif4x2 vector value
def v512hif4x2 : VTVec<512, hif4x2, 158>;  //  512 x hif4x2 vector value
def v2hif8     : VTVec<2, hif8, 159>;  //    2 x hif8 vector value
def v256hif8   : VTVec<256, hif8, 160>;  //  256 x hif8 vector value
def v512hif8   : VTVec<512, hif8, 161>;  //  512 x hif8 vector value
def v2f8e4m3   : VTVec<2, f8e4m3, 162>;  //    2 x f8e4m3 vector value
def v256f8e4m3 : VTVec<256, f8e4m3, 163>;  //  256 x f8e4m3 vector value
def v512f8e4m3 : VTVec<512, f8e4m3, 164>;  //  512 x f8e4m3 vector value
def v2f8e5m2   : VTVec<2, f8e5m2, 165>;  //    2 x f8e5m2 vector value
def v256f8e5m2 : VTVec<256, f8e5m2, 166>;  //  256 x f8e5m2 vector value
def v512f8e5m2 : VTVec<512, f8e5m2, 167>;  //  512 x f8e5m2 vector value
def v2f8e8m0   : VTVec<2, f8e8m0, 168>;  //    2 x f8e8m0 vector value
def v256f8e8m0 : VTVec<256, f8e8m0, 169>;  //  256 x f8e8m0 vector value
def v512f8e8m0 : VTVec<512, f8e8m0, 170>;  //  512 x f8e8m0 vector value

def nxv1i1  : VTScalableVec<1,  i1, 171>;  // n x  1 x i1  vector value
def nxv2i1  : VTScalableVec<2,  i1, 172>;  // n x  2 x i1  vector value
def nxv4i1  : VTScalableVec<4,  i1, 173>;  // n x  4 x i1  vector value
def nxv8i1  : VTScalableVec<8,  i1, 174>;  // n x  8 x i1  vector value
def nxv16i1 : VTScalableVec<16, i1, 175>;  // n x 16 x i1  vector value
def nxv32i1 : VTScalableVec<32, i1, 176>;  // n x 32 x i1  vector value
def nxv64i1 : VTScalableVec<64, i1, 177>;  // n x 64 x i1  vector value

def nxv1i8  : VTScalableVec<1,  i8, 178>;  // n x  1 x i8  vector value
def nxv2i8  : VTScalableVec<2,  i8, 179>;  // n x  2 x i8  vector value
def nxv4i8  : VTScalableVec<4,  i8, 180>;  // n x  4 x i8  vector value
def nxv8i8  : VTScalableVec<8,  i8, 181>;  // n x  8 x i8  vector value
def nxv16i8 : VTScalableVec<16, i8, 182>;  // n x 16 x i8  vector value
def nxv32i8 : VTScalableVec<32, i8, 183>;  // n x 32 x i8  vector value
def nxv64i8 : VTScalableVec<64, i8, 184>;  // n x 64 x i8  vector value

def nxv1i16  : VTScalableVec<1,  i16, 185>;  // n x  1 x i16 vector value
def nxv2i16  : VTScalableVec<2,  i16, 186>;  // n x  2 x i16 vector value
def nxv4i16  : VTScalableVec<4,  i16, 187>;  // n x  4 x i16 vector value
def nxv8i16  : VTScalableVec<8,  i16, 188>;  // n x  8 x i16 vector value
def nxv16i16 : VTScalableVec<16, i16, 189>;  // n x 16 x i16 vector value
def nxv32i16 : VTScalableVec<32, i16, 190>;  // n x 32 x i16 vector value

def nxv1i32  : VTScalableVec<1,  i32, 191>;  // n x  1 x i32 vector value
def nxv2i32  : VTScalableVec<2,  i32, 192>;  // n x  2 x i32 vector value
def nxv4i32  : VTScalableVec<4,  i32, 193>;  // n x  4 x i32 vector value
def nxv8i32  : VTScalableVec<8,  i32, 194>;  // n x  8 x i32 vector value
def nxv16i32 : VTScalableVec<16, i32, 195>;  // n x 16 x i32 vector value
def nxv32i32 : VTScalableVec<32, i32, 196>;  // n x 32 x i32 vector value

def nxv1i64  : VTScalableVec<1,  i64, 197>;  // n x  1 x i64 vector value
def nxv2i64  : VTScalableVec<2,  i64, 198>;  // n x  2 x i64 vector value
def nxv4i64  : VTScalableVec<4,  i64, 199>;  // n x  4 x i64 vector value
def nxv8i64  : VTScalableVec<8,  i64, 200>;  // n x  8 x i64 vector value
def nxv16i64 : VTScalableVec<16, i64, 201>;  // n x 16 x i64 vector value
def nxv32i64 : VTScalableVec<32, i64, 202>;  // n x 32 x i64 vector value

def nxv1f16  : VTScalableVec<1,  f16, 203>;  // n x  1 x  f16 vector value
def nxv2f16  : VTScalableVec<2,  f16, 204>;  // n x  2 x  f16 vector value
def nxv4f16  : VTScalableVec<4,  f16, 205>;  // n x  4 x  f16 vector value
def nxv8f16  : VTScalableVec<8,  f16, 206>;  // n x  8 x  f16 vector value
def nxv16f16 : VTScalableVec<16, f16, 207>;  // n x 16 x  f16 vector value
def nxv32f16 : VTScalableVec<32, f16, 208>;  // n x 32 x  f16 vector value

def nxv1bf16  : VTScalableVec<1,  bf16, 209>;  // n x  1 x bf16 vector value
def nxv2bf16  : VTScalableVec<2,  bf16, 210>;  // n x  2 x bf16 vector value
def nxv4bf16  : VTScalableVec<4,  bf16, 211>;  // n x  4 x bf16 vector value
def nxv8bf16  : VTScalableVec<8,  bf16, 212>;  // n x  8 x bf16 vector value
def nxv16bf16 : VTScalableVec<16, bf16, 213>;  // n x 16 x bf16 vector value
def nxv32bf16 : VTScalableVec<32, bf16, 214>;  // n x 32 x bf16 vector value

def nxv1f32  : VTScalableVec<1,  f32, 215>;  // n x  1 x  f32 vector value
def nxv2f32  : VTScalableVec<2,  f32, 216>;  // n x  2 x  f32 vector value
def nxv4f32  : VTScalableVec<4,  f32, 217>;  // n x  4 x  f32 vector value
def nxv8f32  : VTScalableVec<8,  f32, 218>;  // n x  8 x  f32 vector value
def nxv16f32 : VTScalableVec<16, f32, 219>;  // n x 16 x  f32 vector value

def nxv1f64  : VTScalableVec<1,  f64, 220>;  // n x  1 x  f64 vector value
def nxv2f64  : VTScalableVec<2,  f64, 221>;  // n x  2 x  f64 vector value
def nxv4f64  : VTScalableVec<4,  f64, 222>;  // n x  4 x  f64 vector value
def nxv8f64  : VTScalableVec<8,  f64, 223>;  // n x  8 x  f64 vector value

// Sz = NF * MinNumElts * 8(bits)
def riscv_nxv1i8x2   : VTVecTup<16,  2, i8, 224>;  // RISCV vector tuple(min_num_elts=1,  nf=2)
def riscv_nxv1i8x3   : VTVecTup<24,  3, i8, 225>;  // RISCV vector tuple(min_num_elts=1,  nf=3)
def riscv_nxv1i8x4   : VTVecTup<32,  4, i8, 226>;  // RISCV vector tuple(min_num_elts=1,  nf=4)
def riscv_nxv1i8x5   : VTVecTup<40,  5, i8, 227>;  // RISCV vector tuple(min_num_elts=1,  nf=5)
def riscv_nxv1i8x6   : VTVecTup<48,  6, i8, 228>;  // RISCV vector tuple(min_num_elts=1,  nf=6)
def riscv_nxv1i8x7   : VTVecTup<56,  7, i8, 229>;  // RISCV vector tuple(min_num_elts=1,  nf=7)
def riscv_nxv1i8x8   : VTVecTup<64,  8, i8, 230>;  // RISCV vector tuple(min_num_elts=1,  nf=8)
def riscv_nxv2i8x2   : VTVecTup<32,  2, i8, 231>;  // RISCV vector tuple(min_num_elts=2,  nf=2)
def riscv_nxv2i8x3   : VTVecTup<48,  3, i8, 232>;  // RISCV vector tuple(min_num_elts=2,  nf=3)
def riscv_nxv2i8x4   : VTVecTup<64,  4, i8, 233>;  // RISCV vector tuple(min_num_elts=2,  nf=4)
def riscv_nxv2i8x5   : VTVecTup<80,  5, i8, 234>;  // RISCV vector tuple(min_num_elts=2,  nf=5)
def riscv_nxv2i8x6   : VTVecTup<96,  6, i8, 235>;  // RISCV vector tuple(min_num_elts=2,  nf=6)
def riscv_nxv2i8x7   : VTVecTup<112, 7, i8, 236>;  // RISCV vector tuple(min_num_elts=2,  nf=7)
def riscv_nxv2i8x8   : VTVecTup<128, 8, i8, 237>;  // RISCV vector tuple(min_num_elts=2,  nf=8)
def riscv_nxv4i8x2   : VTVecTup<64,  2, i8, 238>;  // RISCV vector tuple(min_num_elts=4,  nf=2)
def riscv_nxv4i8x3   : VTVecTup<96,  3, i8, 239>;  // RISCV vector tuple(min_num_elts=4,  nf=3)
def riscv_nxv4i8x4   : VTVecTup<128, 4, i8, 240>;  // RISCV vector tuple(min_num_elts=4,  nf=4)
def riscv_nxv4i8x5   : VTVecTup<160, 5, i8, 241>;  // RISCV vector tuple(min_num_elts=4,  nf=5)
def riscv_nxv4i8x6   : VTVecTup<192, 6, i8, 242>;  // RISCV vector tuple(min_num_elts=4,  nf=6)
def riscv_nxv4i8x7   : VTVecTup<224, 7, i8, 243>;  // RISCV vector tuple(min_num_elts=4,  nf=7)
def riscv_nxv4i8x8   : VTVecTup<256, 8, i8, 244>;  // RISCV vector tuple(min_num_elts=4,  nf=8)
def riscv_nxv8i8x2   : VTVecTup<128, 2, i8, 245>;  // RISCV vector tuple(min_num_elts=8,  nf=2)
def riscv_nxv8i8x3   : VTVecTup<192, 3, i8, 246>;  // RISCV vector tuple(min_num_elts=8,  nf=3)
def riscv_nxv8i8x4   : VTVecTup<256, 4, i8, 247>;  // RISCV vector tuple(min_num_elts=8,  nf=4)
def riscv_nxv8i8x5   : VTVecTup<320, 5, i8, 248>;  // RISCV vector tuple(min_num_elts=8,  nf=5)
def riscv_nxv8i8x6   : VTVecTup<384, 6, i8, 249>;  // RISCV vector tuple(min_num_elts=8,  nf=6)
def riscv_nxv8i8x7   : VTVecTup<448, 7, i8, 250>;  // RISCV vector tuple(min_num_elts=8,  nf=7)
def riscv_nxv8i8x8   : VTVecTup<512, 8, i8, 251>;  // RISCV vector tuple(min_num_elts=8,  nf=8)
def riscv_nxv16i8x2  : VTVecTup<256, 2, i8, 252>;  // RISCV vector tuple(min_num_elts=16, nf=2)
def riscv_nxv16i8x3  : VTVecTup<384, 3, i8, 253>;  // RISCV vector tuple(min_num_elts=16, nf=3)
def riscv_nxv16i8x4  : VTVecTup<512, 4, i8, 254>;  // RISCV vector tuple(min_num_elts=16, nf=4)
def riscv_nxv32i8x2  : VTVecTup<512, 2, i8, 255>;  // RISCV vector tuple(min_num_elts=32, nf=2)

def x86mmx    : ValueType<64,   256>;  // X86 MMX value
def Glue      : ValueType<0,    257>;  // Pre-RA sched glue
def isVoid    : ValueType<0,    258>;  // Produces no value
def untyped   : ValueType<8,    259> { // Produces an untyped value
  let LLVMName = "Untyped";
}
def funcref   : ValueType<0,    260>;  // WebAssembly's funcref type
def externref : ValueType<0,    261>;  // WebAssembly's externref type
def exnref    : ValueType<0,    262>;  // WebAssembly's exnref type
def x86amx    : ValueType<8192, 263>;  // X86 AMX value
def i64x8     : ValueType<512,  264>;  // 8 Consecutive GPRs (AArch64)
def aarch64svcount
              : ValueType<16,  265>;  // AArch64 predicate-as-counter
def spirvbuiltin : ValueType<0, 266>; // SPIR-V's builtin type
// AMDGPU buffer fat pointer, buffer rsrc + offset, rewritten before MIR translation.
// FIXME: Remove this and the getPointerType() override if MVT::i160 is added.
def amdgpuBufferFatPointer : ValueType<160, 267>;
// AMDGPU buffer strided pointer, buffer rsrc + index + offset, doesn't reach MIR.
// FIXME: Remove this and the getPointerType() override if MVT::i82 is added.
def amdgpuBufferStridedPointer : ValueType<192, 268>;

def aarch64mfp8 : ValueType<8,  269>;  // 8-bit value in FPR (AArch64)

let isNormalValueType = false in {
def token      : ValueType<0, 504>;  // TokenTy
def MetadataVT : ValueType<0, 505> { // Metadata
  let LLVMName = "Metadata";
}

// Pseudo valuetype to represent "pointer to any address space"
// Should only be used in TableGen.
def pAny       : VTAny<506>;

// Pseudo valuetype to represent "vector of any size"
// Should only be used in TableGen.
def vAny       : VTAny<507>;

// Pseudo valuetype to represent "float of any format"
// Should only be used in TableGen.
def fAny       : VTAny<508>;

// Pseudo valuetype to represent "integer of any bit width"
// Should only be used in TableGen.
def iAny       : VTAny<509>;

// Pseudo valuetype mapped to the current pointer size.
// Should only be used in TableGen.
def iPTR       : ValueType<0, 510>;

// Pseudo valuetype to represent "any type of any size".
// Should only be used in TableGen.
def Any        : VTAny<511>;

} // isNormalValueType = false

} // end defset ValueTypes

/// This class is for targets that want to use pointer types in patterns
/// with the GlobalISelEmitter.  Targets must define their own pointer
/// derived from this class.  The scalar argument should be an
/// integer type with the same bit size as the pointer.
/// e.g. def p0 : PtrValueType <i64, 0>;

class PtrValueType <ValueType scalar, int addrspace> :
    ValueType<scalar.Size, scalar.Value> {
  int AddrSpace = addrspace;
}
