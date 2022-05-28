///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                           FILE: Common/Common.glsl                            //////////
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

/******************************
 *  Text(Common Characters)   *
 ******************************/
#define C_0             48 //Character 0
#define C_1             49 //Character 1
#define C_2             50 //Character 2
#define C_3             51 //Character 3
#define C_4             52 //Character 4
#define C_5             53 //Character 5
#define C_6             54 //Character 6
#define C_7             55 //Character 7
#define C_8             56 //Character 8
#define C_9             57 //Character 9
#define C_COMMA         44 //Character ,
#define C_PERIOD        46 //Character .
#define C_SEMICOLON     59 //Character ;
#define C_COLON         58 //Character :
#define C_SPACE         32 //Character
#define C_SINGLE_QUOTES 39 //Character '
#define C_QUOTES        34 //Character "

