///////////////////////////////////////////////////////////////////////////////////////////////////
//////////               FILE: SphericalHarmonic/Envmap.glsl                             //////////
////////// NOTE: 1. Add Video "Font 1" in iChannel2.                                     //////////
//////////       2. Add the environment lighting cubemap in iChannel3.                   //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

#define CUBEMAP_CHANNEL iChannel0
#define BACKGROUND_CHANNEL iChannel2
#define SH_CHANNEL iChannel3

#if VISUALIZE_ERROR
	const float kErrorAmplifyCoefficient = 30.0;
#endif

vec3 renderBackground(in vec2 uv) { return texelFetch(BACKGROUND_CHANNEL, ivec2(uv), 0).xyz; }

vec3 renderGroundTruth(in Ray ray, in Sphere s, in vec3 backgroundColor) {
	vec2 tMinMax = traceSphere(s, ray);
	if (isHit(tMinMax)) {
		float t = min(max(tMinMax.x, 0.0), tMinMax.y);
		vec3 p = traverseRay(ray, t);
		vec3 n = normalize(p - s.c) * getEnvmapRotationMatrix();
		return texture(CUBEMAP_CHANNEL, n).xyz;
	}
	return backgroundColor;
}

vec3 renderSH0(in Ray ray, in Sphere s, in vec3 backgroundColor) {
	vec2 tMinMax = traceSphere(s, ray);
	if (isHit(tMinMax)) {
		float t = min(max(tMinMax.x, 0.0), tMinMax.y);
		vec3 p = traverseRay(ray, t);
		vec3 n = normalize(p - s.c) * getEnvmapRotationMatrix();;
		vec3 color = SHBasis(0, n) * texelFetch(SH_CHANNEL, ivec2(0, 0), 0).xyz;
		#if VISUALIZE_ERROR
			color = abs(color - texture(CUBEMAP_CHANNEL, n).xyz) * kErrorAmplifyCoefficient;
		#endif
		return color;
	}
	return backgroundColor;
}

vec3 renderSH1(in Ray ray, in Sphere s, in vec3 backgroundColor) {
	vec2 tMinMax = traceSphere(s, ray);
	if (isHit(tMinMax)) {
		float t = min(max(tMinMax.x, 0.0), tMinMax.y);
		vec3 p = traverseRay(ray, t);
		vec3 n = normalize(p - s.c) * getEnvmapRotationMatrix();
		vec3 color = vec3(0);
		for (int i = 0; i < 4; i++) color += SHBasis(i, n) * texelFetch(SH_CHANNEL, ivec2(i, 0), 0).xyz;
		#if VISUALIZE_ERROR
			color = abs(color - texture(CUBEMAP_CHANNEL, n).xyz) * kErrorAmplifyCoefficient;
		#endif
		return color;
	}
	return backgroundColor;
}

vec3 renderSH2(in Ray ray, in Sphere s, in vec3 backgroundColor) {
	vec2 tMinMax = traceSphere(s, ray);
	if (isHit(tMinMax)) {
		float t = min(max(tMinMax.x, 0.0), tMinMax.y);
		vec3 p = traverseRay(ray, t);
		vec3 n = normalize(p - s.c) * getEnvmapRotationMatrix();;
		vec3 color = vec3(0);
		for (int i = 0; i < 9; i++) color += SHBasis(i, n) * texelFetch(SH_CHANNEL, ivec2(i, 0), 0).xyz;
		#if VISUALIZE_ERROR
			color = abs(color - texture(CUBEMAP_CHANNEL, n).xyz) * kErrorAmplifyCoefficient;
		#endif
		return color;
	}
	return backgroundColor;
}

vec3 renderSH3(in Ray ray, in Sphere s, in vec3 backgroundColor) {
	vec2 tMinMax = traceSphere(s, ray);
	if (isHit(tMinMax)) {
		float t = min(max(tMinMax.x, 0.0), tMinMax.y);
		vec3 p = traverseRay(ray, t);
		vec3 n = normalize(p - s.c) * getEnvmapRotationMatrix();;
		vec3 color = vec3(0);
		for (int i = 0; i < 16; i++) color += SHBasis(i, n) * texelFetch(SH_CHANNEL, ivec2(i, 0), 0).xyz;
		#if VISUALIZE_ERROR
			color = abs(color - texture(CUBEMAP_CHANNEL, n).xyz) * kErrorAmplifyCoefficient;
		#endif
		return color;
	}
	return backgroundColor;
}

vec3 renderSH4(in Ray ray, in Sphere s, in vec3 backgroundColor) {
	vec2 tMinMax = traceSphere(s, ray);
	if (isHit(tMinMax)) {
		float t = min(max(tMinMax.x, 0.0), tMinMax.y);
		vec3 p = traverseRay(ray, t);
		vec3 n = normalize(p - s.c) * getEnvmapRotationMatrix();;
		vec3 color = vec3(0);
		for (int i = 0; i < 25; i++) color += SHBasis(i, n) * texelFetch(SH_CHANNEL, ivec2(i, 0), 0).xyz;
		#if VISUALIZE_ERROR
			color = abs(color - texture(CUBEMAP_CHANNEL, n).xyz) * kErrorAmplifyCoefficient;
		#endif
		return color;
	}
	return backgroundColor;
}

vec3 envmap(in vec2 fragCoord, in vec2 fragResolution) {
	float aspect = fragResolution.y / fragResolution.x;
	vec2 pixelUV = fragCoord / fragResolution;
	pixelUV = pixelUV * 2.0 - 1.0;
	pixelUV.y = pixelUV.y * aspect;

	Camera camera = getCameraFromInputState(INPUT_STATE_CHANNEL);
	Ray ray = generatePinholeRay(camera, pixelUV);
	Sphere s = createSphere(vec3(0.0, 0.0, 2.0), 0.8);

	vec3 color = renderBackground(fragCoord);
	if (pixelUV.x < 0.0) {
		if (pixelUV.y < 0.0) {
			pixelUV = (pixelUV - vec2(-0.5, -0.5 * aspect)) * 2.0;
			Ray ray = generatePinholeRay(camera, pixelUV);
			color = renderSH4(ray, s, color);
		}
		else {
			pixelUV = (pixelUV - vec2(-0.5, 0.5 * aspect)) * 2.0;
			Ray ray = generatePinholeRay(camera, pixelUV);
			color = renderGroundTruth(ray, s, color);
		}
	}
	else if (pixelUV.x < 0.5) {
		if (pixelUV.y < 0.0) {
			pixelUV = (pixelUV - vec2(0.25, -0.5 * aspect)) * 2.0;
			Ray ray = generatePinholeRay(camera, pixelUV);
			color = renderSH2(ray, s, color);
		}
		else {
			pixelUV = (pixelUV - vec2(0.25, 0.5 * aspect)) * 2.0;
			Ray ray = generatePinholeRay(camera, pixelUV);
			color = renderSH0(ray, s, color);
		}
	}
	else {
		if (pixelUV.y < 0.0) {
			pixelUV = (pixelUV - vec2(0.75, -0.5 * aspect)) * 2.0;
			Ray ray = generatePinholeRay(camera, pixelUV);
			color = renderSH3(ray, s, color);
		}
		else {
			pixelUV = (pixelUV - vec2(0.75, 0.5 * aspect)) * 2.0;
			Ray ray = generatePinholeRay(camera, pixelUV);
			color = renderSH1(ray, s, color);
		}
	}

	return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	fragColor = vec4(envmap(fragCoord, iResolution.xy), 1.0);
}

