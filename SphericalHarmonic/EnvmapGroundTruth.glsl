///////////////////////////////////////////////////////////////////////////////////////////////////
//////////           FILE: SphericalHarmonic/PrecomputeEnvironmentLighting.glsl          //////////
////////// NOTE: 1. iChannel1: Environtment map                                          //////////
//////////          iChannel2: CubemapA                                                  //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

#define CUBEMAP_CHANNEL iChannel0
#define ENV_MAP_CHANNEL iChannel1

vec3 precompute(in vec3 d) {
	if (iFrame > 0) return texture(CUBEMAP_CHANNEL, d).xyz;

	vec3 irradiance = vec3(0.0);  
	vec3 n = d;

	vec3 up    = vec3(0.0, 1.0, 0.0);
	vec3 yAxis = n;
	vec3 xAxis = cross(yAxis, up);
	vec3 zAxis = cross(xAxis, yAxis);

	const int sampleCount = 2000;
	for (int i = 0; i < sampleCount; i++) {
		vec3 tangentSample = hammerslyHemisphere(i, sampleCount);
		vec3 sampleVec = tangentSample.x * xAxis + tangentSample.y * yAxis + tangentSample.z * zAxis;
		irradiance += texture(ENV_MAP_CHANNEL, sampleVec).xyz * tangentSample.y * sqrt(1.0 - tangentSample.y * tangentSample.y);
	}
	irradiance = PI * irradiance / float(sampleCount);

	return irradiance;
}

void mainCubemap( out vec4 fragColor, in vec2 fragCoord, in vec3 rayOri, in vec3 rayDir ) {
	fragColor = vec4(precompute(rayDir),1.0);
}

