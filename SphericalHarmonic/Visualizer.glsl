///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                    FILE: SphericalHarmonic/Visualizer.glsl                    //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

vec3 visualize(in vec2 fragCoord, in vec2 fragResolution) {
	float aspect = fragResolution.y / fragResolution.x;
	vec2 pixelUV = fragCoord / fragResolution;
	pixelUV = pixelUV * 2.0 - 1.0;
	pixelUV.y = pixelUV.y * aspect;

	Camera camera = getCameraFromInputState(INPUT_STATE_CHANNEL);
	Ray ray = generatePinholeRay(camera, pixelUV);

	Sphere l0m0  = createSphere(vec3( 0.0, 2.0, 5.0),0.5);
	Sphere l1m_1 = createSphere(vec3(-1.0, 1.0, 5.0),0.5);
	Sphere l1m0  = createSphere(vec3( 0.0, 1.0, 5.0),0.5);
	Sphere l1m1  = createSphere(vec3( 1.0, 1.0, 5.0),0.5);
	Sphere l2m_2 = createSphere(vec3(-2.0, 0.0, 5.0),0.5);
	Sphere l2m_1 = createSphere(vec3(-1.0, 0.0, 5.0),0.5);
	Sphere l2m0  = createSphere(vec3( 0.0, 0.0, 5.0),0.5);
	Sphere l2m1  = createSphere(vec3( 1.0, 0.0, 5.0),0.5);
	Sphere l2m2  = createSphere(vec3( 2.0, 0.0, 5.0),0.5);
	Sphere l3m_3 = createSphere(vec3(-3.0,-1.0, 5.0),0.5);
	Sphere l3m_2 = createSphere(vec3(-2.0,-1.0, 5.0),0.5);
	Sphere l3m_1 = createSphere(vec3(-1.0,-1.0, 5.0),0.5);
	Sphere l3m0  = createSphere(vec3( 0.0,-1.0, 5.0),0.5);
	Sphere l3m1  = createSphere(vec3( 1.0,-1.0, 5.0),0.5);
	Sphere l3m2  = createSphere(vec3( 2.0,-1.0, 5.0),0.5);
	Sphere l3m3  = createSphere(vec3( 3.0,-1.0, 5.0),0.5);
	Sphere l4m_4 = createSphere(vec3(-4.0,-2.0, 5.0),0.5);
	Sphere l4m_3 = createSphere(vec3(-3.0,-2.0, 5.0),0.5);
	Sphere l4m_2 = createSphere(vec3(-2.0,-2.0, 5.0),0.5);
	Sphere l4m_1 = createSphere(vec3(-1.0,-2.0, 5.0),0.5);
	Sphere l4m0  = createSphere(vec3( 0.0,-2.0, 5.0),0.5);
	Sphere l4m1  = createSphere(vec3( 1.0,-2.0, 5.0),0.5);
	Sphere l4m2  = createSphere(vec3( 2.0,-2.0, 5.0),0.5);
	Sphere l4m3  = createSphere(vec3( 3.0,-2.0, 5.0),0.5);
	Sphere l4m4  = createSphere(vec3( 4.0,-2.0, 5.0),0.5);

	Sphere[] shSpheres = Sphere[](l0m0, l1m_1, l1m0, l1m1, l2m_2, l2m_1, l2m0, l2m1, l2m2, l3m_3, l3m_2, l3m_1, l3m0, l3m1, l3m2, l3m3, l4m_4, l4m_3, l4m_2, l4m_1, l4m0, l4m1, l4m2, l4m3, l4m4);

	float t = 10000.0;
	int index = -1;

	vec3 color = vec3(0.9) * mix(1.0, 0.3, distance(pixelUV, vec2(0)));
	const vec3 POSITIVE_MATERIAL = vec3(0.5, 0.8, 1.0);
	const vec3 NEGATIVE_MATERIAL = vec3(1.0, 0.8, 0.5);

	for (int i = 0; i < 25; i++) {
		vec2 tMinMax = traceSphere(shSpheres[i], ray);
		if (isHit(tMinMax)) {
			vec2 rangeT = vec2(max(tMinMax.x, 0.0), tMinMax.y);

			int stepCount = 50;
			float stepSize = (rangeT.y - rangeT.x) / float(stepCount);
			for (int k = 0; k < stepCount; k++) {
				float currentT = rangeT.x + stepSize * (float(k) + 0.5);
				vec3 p = traverseRay(ray, currentT);
				float d = distance(p, shSpheres[i].c);
				p = normalize(p - shSpheres[i].c);
				p = getRotateY(iTime) * p;
				float r = 0.5 * SHBasis(i, p);
				if ((d < abs(r))) {
					if (t > currentT) {
						t = currentT;
						if (r > 0.0) color = POSITIVE_MATERIAL * mix(0.5, 1.0, r * 2.0);
						else color = NEGATIVE_MATERIAL * mix(0.5, 1.0, -r * 2.0);
						index = i;
					}
					break;
				}
			}
		}
	}

	return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	fragColor = vec4(visualize(fragCoord, iResolution.xy), 1.0);
}

