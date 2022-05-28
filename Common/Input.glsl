///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                            FILE: Common/Input.glsl                            //////////
////////// NOTE: 1. Change Section "Initial Input Data" to define initial locations      //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

/******************************
 *     Initial Input Data     *
 ******************************/
#define KEYBOARD_INPUT_CHANNEL iChannel0
#define INPUT_STATE_CHANNEL    iChannel1

const int INPUT_SLOT_CAM_POS            = 0;
const int INPUT_SLOT_CAM_LOOK_AT        = 1;
const int INPUT_SLOT_CAM_UP             = 2;
const int INPUT_SLOT_COUNT              = 3;

const vec3 initCamPos    = vec3(0);
const vec3 initCamLookAt = vec3(0.0, 0.0, 1.0);
const vec3 initCamUp     = vec3(0.0, 1.0, 0.0);

const float moveSpeed = 0.1;
const float turnSpeed = 2.0;

/******************************
 *      Input State Code      *
 ******************************/

struct InputState {
	vec3 cameraPos;
	vec3 cameraLookAt;
	vec3 cameraUp;
	vec3 cameraBaseLookAt;
};

InputState initInputState() {
	InputState state;
	state.cameraPos        = initCamPos;
	state.cameraLookAt     = initCamLookAt;
	state.cameraUp         = getCameraUp(initCamLookAt, initCamUp);
	state.cameraBaseLookAt = initCamLookAt;
	return state;
}

InputState loadInputState(sampler2D inputStateBuffer) {
	vec4[INPUT_SLOT_COUNT] inputStateData;
	for (int i = 0; i < INPUT_SLOT_COUNT; i++) 
		inputStateData[i] = fetch(inputStateBuffer, ivec2(0, i));
	
	InputState state;
	state.cameraPos        = inputStateData[INPUT_SLOT_CAM_POS].xyz;
	state.cameraLookAt     = inputStateData[INPUT_SLOT_CAM_LOOK_AT].xyz;
	state.cameraUp         = inputStateData[INPUT_SLOT_CAM_UP].xyz;
	state.cameraBaseLookAt = vec3(inputStateData[0].w, inputStateData[1].w, inputStateData[2].w);

	return state;
}

vec4 saveInputState(sampler2D inputStateBuffer, in InputState state, in ivec2 pixelIdx) {
	vec4 ret = vec4(0);
	if (pixelIdx.x == 0) {
		switch(pixelIdx.y) {
		case INPUT_SLOT_CAM_POS:         ret = vec4(state.cameraPos, state.cameraBaseLookAt.x); break;
		case INPUT_SLOT_CAM_LOOK_AT:     ret = vec4(state.cameraLookAt, state.cameraBaseLookAt.y); break;
		case INPUT_SLOT_CAM_UP:          ret = vec4(state.cameraUp, state.cameraBaseLookAt.z); break;
		default: break;
		}
	}
	return ret;
}

Camera getCameraFromInputState(sampler2D inputStateBuffer) {
	InputState state = loadInputState(inputStateBuffer);
	Camera camera;
	camera.o = state.cameraPos;
	camera.d = state.cameraLookAt;
	camera.u = state.cameraUp;
	return camera;
}

