///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                           FILE: Common/Common.glsl                            //////////
////////// NOTE: 1. Copy this file to the Common tab                                     //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

/******************************
 *           Common           *
 ******************************/
vec4 fetch(sampler2D channel, ivec2 pixel) { return texelFetch(channel, pixel, 0); }

/******************************
 *            Math            *
 ******************************/
#define PI        3.1415927
#define PI_INV    0.3183099
#define PI_2      6.2831853
#define PI_2_INV  0.1591549
#define PI_4     12.5663706
#define PI_4_INV  0.0795775

int[] FACT_TABLE = int[]( 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800 );
int factorial10(int x) { return FACT_TABLE[x]; }

int[] DOUBLE_FACT_TABLE = int[]( 1, 1, 2, 3, 8, 15, 48, 105, 384, 945, 3840, 10395, 46080, 135135, 645120, 2027025, 10321920, 34459425, 185794560, 654729075, 3715891200 );
int doubleFactorial20(int x) { return DOUBLE_FACT_TABLE[x]; }
