///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                         FILE: Common/RayTracing.glsl                          //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

/******************************
 *          Ray Code          *
 ******************************/
struct Ray {
	vec3 o; // ray origin
	vec3 d; // normalized direction
};

Ray createRay(in vec3 o, in vec3 d) {
	Ray r;
	r.o = o;
	r.d = d;
	return r;
}

Ray createRayTowards(in vec3 o, in vec3 target) {
	Ray r;
	r.o = o;
	r.d = normalize(target - o);
	return r;
}

vec3 traverseRay(in Ray r, in float t) { return r.o + r.d * t; }

/*--------------------*
 |   Ray Generation   |
 *--------------------*/
Ray generatePinholeRay(in Camera camera, in vec2 pixelUV) {
	mat3 cameraToWorldMatrix = getCameraToWorldMatrix(camera.d, getCameraRight(camera.d, camera.u), camera.u);
	Ray ray;
	ray.o = camera.o;
	ray.d = cameraToWorldMatrix * normalize(vec3(pixelUV, 1.0));
	return ray;
}

/******************************
 *           Shapes           *
 ******************************/
// Reference: https://iquilezles.org/articles/intersectors/

/*--------------------*
 |       Sphere       |
 *--------------------*/
struct Sphere {
	vec3 c;
	float r;
};

Sphere createSphere(in vec3 c, in float r) { 
	Sphere s;
	s.c = c;
	s.r = r;
	return s;
}

vec2 traceSphere(in Sphere s, in Ray r) {
	vec3 oc = r.o - s.c;
	float b = dot( oc, r.d );
	float c = dot( oc, oc ) - s.r * s.r;
	float h = b*b - c;
	if( h<0.0 ) return vec2(-1.0); // no intersection
	h = sqrt( h );
	return vec2( -b-h, -b+h );
}

/*--------------------*
 |        AABB        |
 *--------------------*/
struct AABB {
	vec3 lb; // left and bottom point
	vec3 rt; // right and top point
};

AABB createAABB(in vec3 lb, in vec3 rt) {
	AABB aabb;
	aabb.lb = lb;
	aabb.rt = rt;
	return aabb;
}

vec2 traceAABB(in AABB aabb, in Ray r) {
	vec3 boxCenter = (aabb.lb + aabb.rt) * 0.5;
	vec3 boxSize = aabb.rt - aabb.lb;
	vec3 rd = r.d;
	vec3 ro = r.o - boxCenter;

	vec3 m = 1.0/rd; // can precompute if traversing a set of aligned boxes
	vec3 n = m*ro;   // can precompute if traversing a set of aligned boxes
	vec3 k = abs(m)*boxSize;
	vec3 t1 = -n - k;
	vec3 t2 = -n + k;
	float tN = max( max( t1.x, t1.y ), t1.z );
	float tF = min( min( t2.x, t2.y ), t2.z );
	if( tN>tF || tF<0.0) return vec2(-1.0); // no intersection
	return vec2( tN, tF );
}

/******************************
 *     Intersection Code      *
 ******************************/
struct Intersection {
	Ray r;
	vec2 t; // minimum and maximum of ray
};

bool isMiss(in vec2 t) { return t.x > t.y; }

// Difference between intersection and hit:
//   Intersection: Hit point can be at the back of ray origin.
//   Hit: At least 1 hit point at the front of ray origin.
bool isIntersect(in vec2 t) { return t.y >= t.x; }
bool isHit(in vec2 t) { return t.y > 0.0; }

Intersection createIntersection(in Ray r, in vec2 t) {
	Intersection i;
	i.r = r;
	i.t = t;
	return i;
}

