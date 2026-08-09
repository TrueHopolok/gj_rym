shader_type canvas_item;

instance uniform float progress = 0.0;

uniform vec2 size_pixels;
uniform vec4 col_border: source_color;

uniform float transition = 0.05;
uniform float band_color = 0.05;

uniform sampler2D noise;


void fragment() {
	vec2 uv = floor(UV * size_pixels) / size_pixels;
	uv.x += sin(TIME + uv.y * size_pixels.y) * 0.2 * clamp(1.0 - progress, 0.0, 1.0);
	float p = texture(noise, uv).r;
	vec4 col_image = texture(TEXTURE, uv);
	vec4 col1 = mix(col_image, col_border, smoothstep(progress, progress+transition, p));
	vec4 col2 = mix(col1, vec4(0), smoothstep(progress+band_color, progress+band_color+transition, p));
	COLOR.rgb = col2.rgb;
	COLOR.a = col2.a * col_image.a;
}
