///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                         FILE: Common/PhongShading.glsl                         //////////
////////// NOTE: 1. Copy this file to the Common tab                                     //////////
////////// Reference: 
///////////////////////////////////////////////////////////////////////////////////////////////////

/******************************
 *      Phong Materials       *
 ******************************/
struct PhongMaterial {
	vec3 ambient;
	vec3 diffuse;
	vec4 specular;
};

PhongMaterial createPhongMaterial(in vec3 ambient, in vec3 diffuse, in vec3 specular, in float shininess) {
	PhongMaterial mat;
	mat.ambient = ambient;
	mat.diffuse = diffuse;
	mat.specular = vec4(specular, shininess);
	return mat;
}

/******************************
 *       Phong Shading        *
 ******************************/

/** Compute ambient in phong shading model.
    Parameters:
      I: ambient light intensity
      C: ambient cofficent
 */
vec3 phongAmbient(vec3 I, vec3 C) {
	return I * C;
}

/** Compute specular in phong shading model.
    Parameters:
      I: light source intensity
      L: light direction(towards light)
      N: normal
      C: diffuse cofficent
 */
vec3 phongDiffuse(vec3 I, vec3 L, vec3 N, vec3 C) {
	float diffuse = max(dot(L, N), 0.0);
	return diffuse * I * C;
}

/** Compute specular in phong shading model.
    Parameters:
      I: light source intensity
      L: light direction(towards light)
      N: normal
      E: eye direction(towards eye)
      C: specular cofficent, (RGB + Shiness)
 */
vec3 phongSpecular(vec3 I, vec3 L, vec3 N, vec3 E, vec4 C) {
	vec3 R = reflect(L, N);
	float specular = pow(max(dot(E, R), 0.0), C.w);
	return specular * I * C.xyz;
}

vec3 phongShading(vec3 lightIntensity, vec3 lightDir, vec3 eyeDir, vec3 p, vec3 normal, PhongMaterial material) {
	vec3 color = vec3(0);
	color += phongAmbient(lightIntensity, material.ambient);
	color += phongDiffuse(lightIntensity, lightDir, normal, material.diffuse);
	color += phongSpecular(lightIntensity, lightDir, normal, eyeDir, material.specular);
	return color;
}
