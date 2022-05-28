///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                         FILE: Atmosphere/Terrain.glsl                         //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

const float terrainFrequency = 0.01;

vec2 terrainParams() { 
	float time = iTime;
	return vec2(30.0 * sin(time), 30.0 * cos(time));
}

/******************************
 *     Terrain Generation     *
 ******************************/

const mat2 rotateFBM = mat2(  0.80,  0.60,
                      -0.60,  0.80 );
const mat2 rotateFBMInverse = mat2( 0.80, -0.60,
                                    0.60,  0.80 );

float hash1(vec2 p ) {
	p  = 50.0*fract( p*0.3183099 );
	return fract( p.x*p.y*(p.x+p.y) );
}

float noise(in vec2 x ) {
	vec2 p = floor(x);
	vec2 w = fract(x);
	#if 1
	vec2 u = w*w*w*(w*(w*6.0-15.0)+10.0);
	#else
	vec2 u = w*w*(3.0-2.0*w);
	#endif

	float a = hash1(p+vec2(0,0));
	float b = hash1(p+vec2(1,0));
	float c = hash1(p+vec2(0,1));
	float d = hash1(p+vec2(1,1));
	
	return -1.0+2.0*(a + (b-a)*u.x + (c-a)*u.y + (a - b - c + d)*u.x*u.y);
}

vec3 noised( in vec2 x ) {
	vec2 p = floor(x);
	vec2 w = fract(x);
	#if 1
	vec2 u = w*w*w*(w*(w*6.0-15.0)+10.0);
	vec2 du = 30.0*w*w*(w*(w-2.0)+1.0);
	#else
	vec2 u = w*w*(3.0-2.0*w);
	vec2 du = 6.0*w*(1.0-w);
	#endif
	
	float a = hash1(p+vec2(0,0));
	float b = hash1(p+vec2(1,0));
	float c = hash1(p+vec2(0,1));
	float d = hash1(p+vec2(1,1));

	float k0 = a;
	float k1 = b - a;
	float k2 = c - a;
	float k4 = a - b - c + d;

	return vec3( -1.0+2.0*(k0 + k1*u.x + k2*u.y + k4*u.x*u.y), 
	             2.0*du * vec2( k1 + k4*u.y,
	             k2 + k4*u.x ) );
}

float fbm(in vec2 x) {
	float f = 1.9;
	float s = 0.55;
	float a = 0.0;
	float b = 0.5;
	for( int i=0; i<9; i++ )
	{
		float n = noise(x);
		a += b*n;
		b *= s;
		x = f * rotateFBM * x;
	}
	
	return a;
}

vec3 fbmd( in vec2 x ) {
	float f = 1.9;
	float s = 0.55;
	float a = 0.0;
	float b = 0.5;
	vec2  d = vec2(0.0);
	mat2  m = mat2(1.0,0.0,0.0,1.0);
	for( int i=0; i<9; i++ )
	{
		vec3 n = noised(x);
		n.x = n.x;
		
		a += b*n.x;          // accumulate values		
		d += b*m*n.yz;       // accumulate derivatives
		b *= s;
		x = f*rotateFBM*x;
		m = f*rotateFBMInverse*m;
	}

	return vec3( a, d );
}

/******************************
 *    Terrain Intersection    *
 ******************************/
float traceTerrain(in AABB terrainAABB, in Ray r) {
	return -1.0;
	float ret = -1.0;

	vec2 tRange = traceAABB(terrainAABB, r);
    tRange.x = max(0.01, tRange.x);
	if (isHit(tRange)) {
		float terrainStepSize = (tRange.y - tRange.x) / float(TERRAIN_STEP);
		float t = tRange.x;
        vec2 prev = vec2(t, 0.0);
		for (int i = 0; i < TERRAIN_STEP; i++) {
			vec3 p = traverseRay(r, t);
			float hTerrain = fbm((p.xz + terrainParams()) * terrainFrequency);
			hTerrain = (hTerrain * 0.5 + 0.5) * kMaxAltitudeDifference;
			float dH = p.y - hTerrain;
			if (dH < 0.0) {
				ret = t -  terrainStepSize;
				ret = prev.x - (prev.x - t) / (prev.y - dH) * dH;
				return ret;
			}
			prev = vec2(t, dH);
			t += terrainStepSize;
		}
		if (t + 0.01 * terrainStepSize < tRange.y) ret = t;
	}
	return ret;
}

/******************************
 *     Terrain Rendering      *
 ******************************/
vec3 terrainNormal(vec3 p) {
	float d = 0.03;
	float dx = fbm((p.xz + terrainParams()) * terrainFrequency - vec2(d, 0.0)) - fbm((p.xz + terrainParams()) * terrainFrequency + vec2(d, 0.0));
	float dy = 2.0 * d;
	float dz = fbm((p.xz + terrainParams()) * terrainFrequency - vec2(0.0, d)) - fbm((p.xz + terrainParams()) * terrainFrequency + vec2(0.0, d));
	return normalize(vec3(dx, dy, dz));
}

vec3 renderTerrain(in Ray r, in float t, in vec3 sunDir, in AABB terrainAABB) {
	const vec3 rockColor = vec3(0.45, 0.3, 0.15);
	const vec3 grassColor = vec3(0.3, 0.3, 0.1);
	const vec3 snowColor = vec3(0.62, 0.65, 0.7);

	vec3 p = traverseRay(r, t);
	vec3 N = terrainNormal(p);
    p += 0.005 * N;
    float h = p.y / kMaxAltitudeDifference;

	Ray shadowRay = createRay(p, sunDir);
	float shadowT = traceTerrain(terrainAABB, shadowRay);
	vec3 material = vec3(0.0, 0.0, 0.0);
	if (shadowT < 0.0) {
		material = mix(grassColor, rockColor, max(h / 0.4, 1.0));
		material = mix(material, snowColor, max(h-0.4, 0.0) / 0.6);
	}
	return material;

	return N; // Visualize Normal
	return vec3(pow(h, 1.0 / 2.2)); // Visualize Height
}

