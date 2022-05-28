///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                         FILE: Atmosphere/Common.glsl                          //////////
///////////////////////////////////////////////////////////////////////////////////////////////////


/******************************
 *   Atmosphere Parameters    *
 ******************************/

/*-----------------------------*
 |   Ray Marching Parameters   |
 *-----------------------------*/
#define I0_STEP 16 // Number of steps marching I0 scattering
#define I1_STEP 8  // Number of steps marching I1 scattering
#define TERRAIN_STEP 100 // Number of steps marching terrain

/*-----------------------------*
 |   Astronomical Parameters   |
 *-----------------------------*/
// Unit: Meter
const float kMaxAltitudeDifference = 150.0; // 500M
const float kEarthRadius = 6360E3; // 6360KM
const float kSunRadius = 696342E3; // 696,342KM
const float kAtmosphereDepth = 60E3; // 60KM
const float kEarthSunDistance = 1.496E11;
const float seaLevelMolecularNumberDensity = 2.504E25;
const float airIndexOfRefraction = 1.00029;
const float hazeCofficient = 0.7;

/*-----------------------------*
 |      Other Parameters       |
 *-----------------------------*/
const float kRayleighH0 = 8E3;
// Formula (8 * pi^3 * (n^2-1)^2) / (3 * Ns * lambda ^ 4) with R = 680nm, G = 550nm, B = 440nm
const vec3 kRayleighAttenuationCofficient = vec3(0.00000519673, 0.0000121427, 0.0000296453);
const float kMieH0 = 1.2E3;
const float kMieU = 0.75;

/*-----------------------------*
 |      Helper Functions       |
 *-----------------------------*/
float height(Sphere earth, vec3 point) { return distance(earth.c, point) - earth.r; }

