shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixelFactor: hint_range(0, 1) = 1;

void fragment() {
	vec2 pixelNumber = vec2(textureSize(screen_texture, 0)) * pixelFactor;
	vec2 pixelatedUV = round(SCREEN_UV * pixelNumber) / pixelNumber;
	COLOR = textureLod(screen_texture, pixelatedUV, 0);
}