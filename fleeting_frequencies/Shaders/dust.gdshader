shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);

//https://godotshaders.com/snippet/random-value
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

//This distorts the sprite's size to be taller and wider.
//50.0 and 60.0 are guessed hardcoded shit
void vertex() {
	if(UV.y <= progress)
	{
		VERTEX.y = VERTEX.y*(1.2*progress+1.0)-progress*60.0;
		VERTEX.x = VERTEX.x*(2.0*progress+1.0)+progress*80.0;
	}
}

void fragment() {
	//pixel clamping code taken from https://godotshaders.com/shader/pixel-explosion/
	vec2 tex_size = 1.0 / (TEXTURE_PIXEL_SIZE); // Real texture size in pixels
	vec2 uv = floor(UV * tex_size) / (tex_size - 1.0); // Pixelate UV to snap pixels

	//Each pixel fades according to noise*progress
	// i.e. the random noise decides how fast each pixel
	// fades
	float appProgress = progress-uv.y + progress;
	float noise = max(0.1,0.5*random(uv));
	float noiseVal = (noise-(appProgress))/noise;
	COLOR.a = max(0.0, min(1.0,noiseVal));
}