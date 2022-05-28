///////////////////////////////////////////////////////////////////////////////////////////////////
//////////                      FILE: Common/GUI.glsl                                    //////////
///////////////////////////////////////////////////////////////////////////////////////////////////

vec4 renderChar(sampler2D text, vec2 p, int c)  {
	if (p.x<.0|| p.x>1. || p.y<0.|| p.y>1.) return vec4(0,0,0,1e5);
	return textureGrad(text, p/16. + fract( vec2(c, 15-c/16) / 16. ), dFdx(p/16.),dFdy(p/16.));
}

#define DRAW_STRING(str, strlen, textChannel, textPos, textColor, output)       \
	for (int i = 0; i < strlen; i++) {                                          \
		output += renderChar(textChannel, textPos, str[i]).x * textColor; \
		textPos.x -= 0.5;                                                       \
	}

