///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                            FILE: Buffer/Input.glsl                            //////////
////////// NOTE: 1. Create channels according to Common/Input.glsl                       //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

/******************************
 *      Input Constants       *
 ******************************/

const int // http://keycode.info
, KEY_W     = 87
, KEY_A     = 65
, KEY_S     = 83
, KEY_D     = 68
, KEY_Q     = 81
, KEY_E     = 69
, KEY_R     = 82
// Generalized control.
, KEY_FW    = KEY_W
, KEY_LF    = KEY_A
, KEY_BW    = KEY_S
, KEY_RT    = KEY_D
, KEY_UW    = KEY_E
, KEY_DW    = KEY_Q
;

/******************************
 *   Input Processing Code    *
 ******************************/

float key(int vk) { return step(.5, fetch(KEYBOARD_INPUT_CHANNEL, ivec2(vk, 0)).x); }
bool isMousePressed() { return iMouse.z >= 0.0; }
bool isMouseClicked() { return iMouse.w >= 0.0; }
vec2 getMouseMovement() { return (iMouse.xy - abs(iMouse.zw)) / iResolution.xy; }
bool isInitFrame() { return iFrame == 0; }

void processInput(inout InputState state, out vec3 translation, out vec2 rotation) {
	if (key(KEY_R) > 0.0) {
		state = initInputState();
		translation = vec3(0);
		rotation = vec2(0);
		return;
	}

	translation = vec3(key(KEY_RT) - key(KEY_LF) , key(KEY_UW) - key(KEY_DW) , key(KEY_FW) - key(KEY_BW));
	rotation = vec2(0);

	if (isMousePressed()) {
		rotation = getMouseMovement();
		if (abs(rotation.x) > abs(rotation.y)) rotation.y = 0.0;
		else rotation.x = 0.0;
	}
	else {
		state.cameraBaseLookAt = state.cameraLookAt;
	}
}

vec4 updateInputState(sampler2D inputStateBuffer, in ivec2 pixelIdx) {
	InputState state = loadInputState(inputStateBuffer);
	if (isInitFrame()) state = initInputState();

	vec3 translation;
	vec2 rotation;
	processInput(state, translation, rotation);

	mat3 rotateX = getRotateX(rotation.y);
	mat3 rotateY = getRotateY(rotation.x);

	state.cameraLookAt = rotateX * rotateY * state.cameraBaseLookAt;
	state.cameraUp     = getCameraUp(state.cameraLookAt, state.cameraUp);

	mat3 cameraMatrix = getCameraToWorldMatrix(state.cameraLookAt, normalize(cross(state.cameraLookAt, state.cameraUp)), state.cameraUp);
	state.cameraPos   += cameraMatrix * translation * moveSpeed;

	return saveInputState(inputStateBuffer, state, pixelIdx);
}

void mainImage( out vec4 pixelColor, in vec2 pixelCoord) {
	ivec2 pixelIdx = ivec2(pixelCoord);
	pixelColor = updateInputState(INPUT_STATE_CHANNEL, pixelIdx);
}

