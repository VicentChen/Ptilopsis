///////////////////////////////////////////////////////////////////////////////////////////////////
//////////               FILE: SphericalHarmonic/EnvmapBackground.glsl                   //////////
////////// NOTE: 1. Add Video "Font 1" in iChannel0.                                     //////////
//////////          Add BufferA in iChannel1.                                            //////////
//////////          Add Cubemap in iChannel2.                                            //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

#define TEXT_CHANNEL iChannel0
#define ENV_MAP_CHANNEL iChannel2

vec4 renderBackground(in vec2 fragCoord, in vec2 fragResolution) {
	float aspect = fragResolution.y / fragResolution.x;
	vec2 pixelUV = fragCoord / fragResolution;
	pixelUV = pixelUV * 2.0 - 1.0;
	pixelUV.y = pixelUV.y * aspect;

	Camera camera = getCameraFromInputState(INPUT_STATE_CHANNEL);
	Ray ray = generatePinholeRay(camera, pixelUV);

	return texture(ENV_MAP_CHANNEL, ray.d * getRotateY(0.25 * iTime));
}

vec4 renderUI(in vec2 fragCoord, in vec2 fragResolution) {
	float aspect = fragResolution.y / fragResolution.x;
	vec2 pixelUV = fragCoord / fragResolution;
	
	if (abs(pixelUV.y - 0.5) < 0.0025) return vec4(1.0);
	if (abs(pixelUV.x - 0.5) < 0.0025) return vec4(1.0);
	if (abs(pixelUV.x - 0.75) < 0.0025) return vec4(1.0);
	
	pixelUV.y = pixelUV.y * aspect;

	const vec4 textColor = vec4(0.0, 1.0, 0.0, 1.0);
	vec4 color = renderBackground(fragCoord, fragResolution);
	vec2 p = vec2(pixelUV.x, pixelUV.y - 0.54) * 40.0;

	int[] sGroundTruth = int[](71, 114, 111, 117, 110, 100, 84, 114, 117, 116, 104);
	DRAW_STRING(sGroundTruth, 11, TEXT_CHANNEL, p, textColor, color);

	p = vec2(pixelUV.x, pixelUV.y - 0.25) * 40.0;
	int[] sSH4 = int[](83, 72, 58, 52);
	DRAW_STRING(sSH4, 4, TEXT_CHANNEL, p, textColor, color);

	p = vec2(pixelUV.x - 0.5, pixelUV.y - 0.54) * 40.0;
	int[] sSH0 = int[](83, 72, 58, 48);
	DRAW_STRING(sSH0, 4, TEXT_CHANNEL, p, textColor, color);
	
	p = vec2(pixelUV.x - 0.75, pixelUV.y - 0.54) * 40.0;
	int[] sSH1 = int[](83, 72, 58, 49);
	DRAW_STRING(sSH1, 4, TEXT_CHANNEL, p, textColor, color);
	
	p = vec2(pixelUV.x - 0.5, pixelUV.y - 0.25) * 40.0;
	int[] sSH2 = int[](83, 72, 58, 50);
	DRAW_STRING(sSH2, 4, TEXT_CHANNEL, p, textColor, color);
	
	p = vec2(pixelUV.x - 0.75, pixelUV.y - 0.25) * 40.0;
	int[] sSH3 = int[](83, 72, 58, 51);
	DRAW_STRING(sSH3, 4, TEXT_CHANNEL, p, textColor, color);

	const vec4 visualizeTextColor = vec4(1.0, 0.0, 0.0, 1.0);
	p = vec2(pixelUV.x, pixelUV.y) * 40.0;
	int[] sEnvirontmentMap = int[](82, 101, 115, 117, 108, 116, 58, 32, 69, 110, 118, 105, 114, 111, 110, 109, 101, 110, 116, 32, 109, 97, 112);
	int[] sError = int[](82, 101, 115, 117, 108, 116, 58, 32, 69, 114, 114, 111, 114, 32, 118, 105, 115, 117, 97, 108, 105, 122, 101);
	#if VISUALIZE_ERROR
		DRAW_STRING(sError, 23, TEXT_CHANNEL, p, visualizeTextColor, color);
	#else
		DRAW_STRING(sEnvirontmentMap, 23, TEXT_CHANNEL, p, visualizeTextColor, color);
	#endif

	return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	fragColor = renderUI(fragCoord, iResolution.xy);
}
