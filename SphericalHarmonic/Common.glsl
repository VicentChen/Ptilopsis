///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                      FILE: SphericalHarmonic/Common.glsl                      //////////
////////// NOTE: 1. Copy this file to the Image tab                                      //////////
//////////       2. (x,y,z)=(sinTheta*cosPhi,cosTheta,sinTheta*sinPhi)                   //////////
///////////////////////////////////////////////////////////////////////////////////////////////////


float SHBasis0to4(int l, int m) {
	int index = l * l + l + m;
	return 0.0;
}

#define SHBasisL0(p)     0.282095

#define SHBasisL1M_1(p)  0.488603 * p.z
#define SHBasisL1M0(p)   0.488603 * p.y
#define SHBasisL1M1(p)   0.488603 * p.x

#define SHBasisL2M_2(p)  1.092548 * (p.z * p.x              )
#define SHBasisL2M_1(p)  1.092548 * (p.z * p.y              )
#define SHBasisL2M0(p)   0.315391 * ((3.0 * y * y - 1.0)    )
#define SHBasisL2M1(p)   1.092548 * (p.x * p.y              )
#define SHBasisL2M2(p)   0.546274 * ((p.x * p.x - p.z * p.z))

#define SHBasisL3M_3(p)  0.590044 * (p.z * (3.0 * p.x * p.x- p.z * p.z) )
#define SHBasisL3M_2(p)  2.890611 * (p.x * p.y * p.z                    )
#define SHBasisL3M_1(p)  0.457046 * (p.z * (5.0 * p.y * p.y - 1.0)      )
#define SHBasisL3M0(p)   0.373176 * ((5.0 * p.y * p.y * p.y - 3.0 * p.y))
#define SHBasisL3M1(p)   0.457046 * (p.x * (5.0 * p.y * p.y - 1.0)      )
#define SHBasisL3M2(p)   1.445306 * ((p.x * p.x - p.z * p.z) * p.y      )
#define SHBasisL3M3(p)   0.590044 * (p.x * (p.x * p.x - 3.0 * p.z * p.z))

#define SHBasisL4M_4(p)  2.503343 * (p.x * p.z * (p.x * p.x- p.z * p.z)                                                   )
#define SHBasisL4M_3(p)  1.770131 * (p.z * (3.0 * p.x * p.x- p.z * p.z) * p.y                                             )
#define SHBasisL4M_2(p)  0.946175 * (p.x * p.z * (7.0 * p.y * p.y - 1.0)                                                  )
#define SHBasisL4M_1(p)  0.669047 * (p.z * (7.0 * p.y * p.y * p.y - 3.0 * p.y)                                            )
#define SHBasisL4M0(p)   0.105786 * ((35.0 * p.y * p.y * p.y * p.y - 30.0 * p.y * p.y + 3.0)                              )
#define SHBasisL4M1(p)   0.669047 * (p.x * (7.0 * p.y * p.y * p.y - 3.0 * p.y)                                            )
#define SHBasisL4M2(p)   0.473087 * ((p.x * p.x - p.z * p.z) * (7.0 * p.y * p.y - 1.0)                                    )
#define SHBasisL4M3(p)   1.770131 * (p.x * (p.x * p.x - 3.0 * p.z * p.z) * p.y                                            )
#define SHBasisL4M4(p)   0.625836 * (p.x * p.x * (p.x * p.x - 3.0 * p.z * p.z) - p.z * p.z * (3.0 * p.x * p.x - p.z * p.z))

float SHBasis(int i, vec3 p) {
	if (i == 0) return SHBasisL0(p);

	else if (i == 1) return SHBasisL1M_1(p);
	else if (i == 2) return SHBasisL1M0(p);
	else if (i == 3) return SHBasisL1M1(p);

	else if (i == 4) return SHBasisL2M_2(p);
	else if (i == 5) return SHBasisL2M_1(p);
	else if (i == 6) return SHBasisL2M0(p);
	else if (i == 7) return SHBasisL2M1(p);
	else if (i == 8) return SHBasisL2M2(p);

	else if (i == 9)  return SHBasisL3M_3(p);
	else if (i == 10) return SHBasisL3M_2(p);
	else if (i == 11) return SHBasisL3M_1(p);
	else if (i == 12) return SHBasisL3M0(p);
	else if (i == 13) return SHBasisL3M1(p);
	else if (i == 14) return SHBasisL3M2(p);
	else if (i == 15) return SHBasisL3M3(p);


	else if (i == 16) return SHBasisL4M_4(p);
	else if (i == 17) return SHBasisL4M_3(p);
	else if (i == 18) return SHBasisL4M_2(p);
	else if (i == 19) return SHBasisL4M_1(p);
	else if (i == 20) return SHBasisL4M0(p);
	else if (i == 21) return SHBasisL4M1(p);
	else if (i == 22) return SHBasisL4M2(p);
	else if (i == 23) return SHBasisL4M3(p);
	else if (i == 24) return SHBasisL4M4(p);
	else if (i == 25) return SHBasisL4M4(p);

	return 0.0;
}
