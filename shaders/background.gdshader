shader_type canvas_item;

uniform vec4 color0 : source_color = vec4(1., 1., 1., 0.);
uniform vec4 color1 : source_color = vec4(1.);
uniform vec2 camera_position = vec2(0.);
uniform float camera_scale = 1.;
uniform float noise_frequency = 1.;
uniform vec2 noise_offset = vec2(0.);

// https://godotshaders.com/snippet/2d-noise/
vec2 random(vec2 uv) {
	uv = vec2(
		dot(uv, vec2(127.1, 311.7)),
		dot(uv, vec2(269.5, 183.3))
	);
	return -1. + 2. * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
	vec2 uv_index = floor(uv);
	vec2 uv_fract = fract(uv);
	vec2 blur = smoothstep(0., 1., uv_fract);

	return mix(
		mix(
			dot(random(uv_index + vec2(0., 0.)), uv_fract - vec2(0., 0.)),
			dot(random(uv_index + vec2(1., 0.)), uv_fract - vec2(1., 0.)),
			blur.x
		),
		mix(
			dot(random(uv_index + vec2(0., 1.)), uv_fract - vec2(0., 1.)),
			dot(random(uv_index + vec2(1., 1.)), uv_fract - vec2(1., 1.)),
			blur.x
		),
		blur.y
	) + 0.5;
}

varying vec2 position;

void vertex() {
	position = VERTEX;
}

void fragment() {
	vec2 world_position = (position + camera_position) / camera_scale;
	vec2 noise_uv = (world_position + noise_offset) * noise_frequency;
	float noise_value = noise(noise_uv);
	COLOR = color0 * (1. - noise_value) + color1 * noise_value;
}
