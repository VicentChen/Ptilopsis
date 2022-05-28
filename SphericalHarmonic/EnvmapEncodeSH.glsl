///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                      FILE: SphericalHarmonic/Common.glsl                      //////////
////////// NOTE: 1. (x,y,z)=(sinTheta*cosPhi,cosTheta,sinTheta*sinPhi)                   //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

#define CUBEMAP_CHANNEL iChannel0
#define SH_CHANNEL iChannel1

vec3 computeSHCofficient(in vec2 fragCoord) {
	// This file will be copied to BufferX, while the Cubemap(Cube A) pass will be executed
	// after BufferX, therefore we need to execute this pass after generating cubemap.
	if (iFrame != 1) return texelFetch(SH_CHANNEL, ivec2(fragCoord), 0).xyz;

	vec3 SHCofficient = vec3(0.0);
	int i = int(fragCoord.x);
	if (i < 25) {
		const int sampleCount = 400;
		for (int s = 0; s < sampleCount; s++) {
			// Remember to use uniform spherical sampling. Sample with spherical coordinates 
			// will lead to much more error.
			vec3 dir = fibonacciSphere(s, sampleCount);
			SHCofficient += SHBasis(i, dir) * texture(CUBEMAP_CHANNEL, dir).xyz;
		}
		SHCofficient *= PI_4 / float(sampleCount);
	}
	return SHCofficient;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	fragColor = vec4(computeSHCofficient(fragCoord), 1.0);
}

