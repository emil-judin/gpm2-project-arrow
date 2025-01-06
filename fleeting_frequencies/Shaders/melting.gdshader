shader_type canvas_item;

// Reverse melting
uniform bool reverse = false;
// Melt direction
uniform bool melts_right = true;
// Array size determines how many horizontal strips appear
uniform float[64] x_offsets;
// Texture to melt away
uniform sampler2D melt_texture;

group_uniforms runtime;
// Controls whether the effect can play
uniform bool melting = false;
// Incremented by outside script to move effect
uniform float timer = 0.0;
group_uniforms;

void fragment() {
	vec2 texture_uv = SCREEN_UV;
	if (melting)
	{
		float index = texture_uv.y * float(x_offsets.length());
		
		float offset = timer * x_offsets[int(index)];
		if (reverse)
			if (melts_right){
				texture_uv.x = (-1.0 + texture_uv.x) + offset;
				if (texture_uv.x < 0.0) discard;
			}
			else{
				texture_uv.x = (-1.0 + texture_uv.x) - offset;
				if (texture_uv.x > -1.0) discard;
			}
		else
			if (melts_right){
				texture_uv.x = texture_uv.x + offset;
				if (texture_uv.x > 1.0) discard;
			}
			else{
				texture_uv.x = texture_uv.x - offset;
				if (texture_uv.x < 0.0) discard;
			}
	}
	
	COLOR = texture(melt_texture, texture_uv);
}