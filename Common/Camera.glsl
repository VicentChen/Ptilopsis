///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                           FILE: Common/Camera.glsl                            //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

struct Camera {
	vec3 o; // origin (position)
	vec3 d; // (look at)direction
	vec3 u; // up
};

/******************************
 *      Coordinate Code       *
 ******************************/

vec3 getCameraRight(in vec3 front, in vec3 up) { return normalize(cross(front, up)); }

vec3 getCameraUp(in vec3 camLookAt, in vec3 camUp) {
	vec3 right = getCameraRight(camLookAt, camUp);
	return normalize(cross(right, camLookAt));
}

mat3 getRotateX(in float a) {
	float cosA = cos(a);
	float sinA = sin(a);
	return mat3(
		   1,     0,     0,
		   0,  cosA,  sinA,
		   0, -sinA,  cosA
	);
}

mat3 getRotateY(in float a) {
	float cosA = cos(a);
	float sinA = sin(a);
	return mat3(
		cosA,    0, -sinA,
		   0,    1,     0,
		sinA,    0,  cosA
	);
}

mat3 getRotateZ(in float a) {
	float cosA = cos(a);
	float sinA = sin(a);
	return mat3(
		 cosA, sinA, 0,
		-sinA, cosA, 0,
		   0,     0, 1
	);
}

mat3 getCameraToWorldMatrix(in vec3 front, in vec3 right, in vec3 up) {
	mat3 m = mat3(right, up, front);
	return m;
}

