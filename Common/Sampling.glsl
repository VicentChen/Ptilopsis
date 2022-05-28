///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                      FILE: Common/SH.glsl                                     //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

// Fibonacci spherical sampling reference: https://www.shadertoy.com/view/WslcW4
vec2 fibonacciLattice(int i, int N) { return vec2((float(i)+0.5)/float(N), mod(float(i)/0.853553, 1.));  } // 0.5 * (sqrt(0.5) + 1) = 0.853553

vec3 fibonacciSphere(int i, int N) {
	vec2 xy = fibonacciLattice(i, N);
	vec2 pt = vec2(2.*PI*xy.y, acos(2.*xy.x - 1.) - PI*0.5);
	return vec3(cos(pt.x)*cos(pt.y), sin(pt.x)*cos(pt.y), sin(pt.y)); 
}

// Hammersly hermisphere sampling reference: https://www.shadertoy.com/view/4lscWj
vec2 hammerslySequence(int i, int N) {
	uint b = uint(i);

	b = (b << 16u) | (b >> 16u);
	b = ((b & 0x55555555u) << 1u) | ((b & 0xAAAAAAAAu) >> 1u);
	b = ((b & 0x33333333u) << 2u) | ((b & 0xCCCCCCCCu) >> 2u);
	b = ((b & 0x0F0F0F0Fu) << 4u) | ((b & 0xF0F0F0F0u) >> 4u);
	b = ((b & 0x00FF00FFu) << 8u) | ((b & 0xFF00FF00u) >> 8u);

	float radicalInverseVDC = float(b) * 2.3283064365386963e-10;

	return vec2(float(i) / float(N), radicalInverseVDC);
} 

vec3 hammerslyHemisphere(int i, int N) {
	// Returns a 3D sample vector orientated around (0.0, 1.0, 0.0)
	// For practical use, must rotate with a rotation matrix (or whatever
	// your preferred approach is) for use with normals, etc.

	vec2 xi = hammerslySequence(i, N);

	float phi      = xi.y * 2.0 * PI;
	float cosTheta = 1.0 - xi.x;
	float sinTheta = sqrt(1.0 - cosTheta * cosTheta);

	return vec3(cos(phi) * sinTheta, cosTheta, sin(phi) * sinTheta);
}

