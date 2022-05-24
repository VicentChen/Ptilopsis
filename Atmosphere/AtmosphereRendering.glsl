///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                   FILE: Atmosphere/AtmosphereRendering.glsl                   //////////
////////// NOTE: 1. Copy this file to the Image tab                                      //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

float atmosphereDensity(float h, float H0) { return exp(-h / H0); }

float opticalDepth(float h, float H0, float stepSize) { return atmosphereDensity(h, H0) * stepSize; }

vec3 mieAttenuationCofficient(float c) {
	// return vec3(0.758);
	return 0.434 * c * 4.0 * PI * PI * PI / (vec3(680e-6, 550e-6, 440e-6) * vec3(680e-6, 550e-6, 440e-6)) * vec3(0.686,0.678,0.663);
}

float mieG(float u) {
	float u2 = u * u;
	float x = 5.0 / 9.0 * u + 125.0 / 729.0 * u2 * u + sqrt(64.0/27.0 - 325.0 / 243.0 * u2 + 1250.0 / 2187.0 * u2 * u2);
	float x_1_3 = pow(x, 1.0 / 3.0);
	float g = 5.0 / 9.0 * u - (4.0 / 3.0 - 25.0 / 81.0 * u2) / x_1_3 + x_1_3;
	return g;
}

float miePhase(float g, float cosine) {
	float g2 = g * g;
	float cos2 = cosine * cosine;
	float p = 3.0 / (8.0 * PI) * (1.0 - g2) * (1.0 + cos2) / (2.0 + g2) / pow(1.0 + g2 - 2.0 * g * cosine, 1.5);
	return p;
}

// Phase function with normalized factor, notice that kRayleighAttenuationCofficient already multiply this factor
float rayleighPhase(float cosine) { return 0.05968310365946075 * (1.0 + cosine * cosine); } // 0.05968310365946075 = 3 / (16 * pi)

vec3 renderAtmosphere(Ray primaryRay, float tPrimary, Sphere earth, Sphere atmosphere, Sphere sun) {
	vec3 sunColor = vec3(1.0, 1.0, 1.0) * 22.0;
	vec3 color = vec3(0);
	
	vec3 sunDir = normalize(sun.c - earth.c); // Assume the sun is a parallel light source.
	float g = mieG(0.7);
	vec3 mieAtteunation = mieAttenuationCofficient(5.893e-16);

	float primaryRayleighOpticalDepth = 0.0;
	float primaryMieOpticalDepth = 0.0;
	float primaryStepSize = tPrimary / float(I0_STEP);
	// Ray marching primary ray
	for (int i0 = 0; i0 < I0_STEP; i0++) {    
		vec3 primaryMarchPoint = traverseRay(primaryRay, primaryStepSize * (float(i0) + 0.5));
		primaryRayleighOpticalDepth += opticalDepth(height(earth, primaryMarchPoint), kRayleighH0, primaryStepSize);
		primaryMieOpticalDepth += opticalDepth(height(earth, primaryMarchPoint), kMieH0, primaryStepSize);
		
		Ray scatterRay = createRay(primaryMarchPoint, normalize(sun.c - earth.c));
		if (traceSphere(earth, scatterRay).y < 0.0) {
			float tScatter = traceSphere(atmosphere, scatterRay).y;
			float scatterStepSize = tScatter / float(I1_STEP);
			float scatterRayleighOpticalDepth = 0.0;
			float scatterMieOpticalDepth = 0.0;
			// Ray marching scatter ray
			for (int i1 = 0; i1 < I1_STEP; i1++) {
				vec3 scatterMarchPoint = traverseRay(scatterRay, scatterStepSize * (float(i1)+ 0.5));
				scatterRayleighOpticalDepth += opticalDepth(height(earth, scatterMarchPoint), kRayleighH0, scatterStepSize);
				scatterMieOpticalDepth += opticalDepth(height(earth, scatterMarchPoint), kMieH0, scatterStepSize);
			}

			vec3 rayleigh = exp(-kRayleighAttenuationCofficient * (scatterRayleighOpticalDepth + primaryRayleighOpticalDepth)) * rayleighPhase(dot(primaryRay.d, scatterRay.d)) * kRayleighAttenuationCofficient * opticalDepth(height(earth, primaryMarchPoint), kRayleighH0, primaryStepSize);
			vec3 mie = exp(-mieAtteunation * (scatterMieOpticalDepth + primaryMieOpticalDepth)) * miePhase(g, dot(primaryRay.d, scatterRay.d)) * mieAtteunation * opticalDepth(height(earth, primaryMarchPoint), kMieH0, primaryStepSize);
			color += sunColor * (rayleigh + mie);
		}
	}
	
	color = 1.0 - exp(-1.0 * color);
	return color;
}

vec3 renderSun() {
	return vec3(1.0, 0.0, 0.0);
}

vec3 scene(in vec2 fragCoord, in vec2 fragResolution) {
	float aspect = fragResolution.y / fragResolution.x;
	vec2 pixelUV = fragCoord / fragResolution;
	pixelUV = pixelUV * 2.0 - 1.0;
	pixelUV.y = pixelUV.y * aspect;

	Camera camera = getCameraFromInputState(INPUT_STATE_CHANNEL);
	Ray ray = generatePinholeRay(camera, pixelUV);

	const float camHeight = 100.0; // Camera at 100 meter height.    
	vec3 earthCenter = -vec3(0, kEarthRadius + camHeight, 0);
	// vec3 earthCenter = vec3(0, -sin(PI / 2.5), -cos(PI / 2.5)) * (kEarthRadius + camHeight);
	Sphere earth = createSphere(earthCenter, kEarthRadius);
	Sphere atmosphere = createSphere(earthCenter, kEarthRadius + kAtmosphereDepth);
	vec3 sunCenter = vec3(0, abs(sin(iTime * 0.25 - 0.35)), cos(iTime * 0.25 - 0.35)) * kEarthSunDistance;
	Sphere sun = createSphere(sunCenter + earthCenter, kSunRadius);
	
	AABB terrainAABB = createAABB(vec3(-1000.0, 0.0, -1000.0), vec3(1000.0, kMaxAltitudeDifference, 1000.0));

	vec3 color = vec3(1.0, 1.0, 1.0);
	float t = traceTerrain(terrainAABB, ray);
	if (t > 0.0) {
		color = renderTerrain(ray, t, normalize(sun.c - earth.c), terrainAABB);
	}
	else {
		vec2 tMinMax = traceSphere(sun, ray);
		if (isHit(tMinMax)) {
			color = renderSun();
		}
		else {
			tMinMax = traceSphere(atmosphere, ray);
			color = renderAtmosphere(ray, tMinMax.y, earth, atmosphere, sun);
		}
	}
	return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	fragColor = vec4(scene(fragCoord, iResolution.xy), 1.0);
}

