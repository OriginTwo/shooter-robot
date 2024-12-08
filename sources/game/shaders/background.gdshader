shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D noise_tex : source_color, repeat_enable;
uniform vec3 colors[3] : source_color;
uniform float time_scale : hint_range(0.0, 1.0) = 0.001;

const vec4 CLEAR_COLOR = vec4(63.0/255.0, 40.0/255.0, 50.0/255.0, 1.0);

void fragment() {
	vec4 texel = texture(screen_texture, SCREEN_UV);
	if (texel == CLEAR_COLOR) {
		vec2 pixel_size = vec2(textureSize(screen_texture, 0));
		if (texture(screen_texture, SCREEN_UV + vec2(0.0, 1.0) / pixel_size) != CLEAR_COLOR ||
				texture(screen_texture, SCREEN_UV + vec2(0.0, -1.0) / pixel_size) != CLEAR_COLOR ||
				texture(screen_texture, SCREEN_UV + vec2(1.0, 0.0) / pixel_size) != CLEAR_COLOR ||
				texture(screen_texture, SCREEN_UV + vec2(-1.0, 0.0) / pixel_size) != CLEAR_COLOR) {
			texel = vec4(1.0);
		} else {
			vec2 shifted_uv = vec2(UV.x + sin(TIME*time_scale*0.02), UV.y + sin(TIME*time_scale*0.02));
			float n1 = texture(noise_tex, shifted_uv).r;
			shifted_uv = vec2(UV.x*1.2 - sin(TIME*time_scale*0.05), UV.y*1.2 - sin(TIME*time_scale*0.05));
			float n2 = texture(noise_tex, shifted_uv).r;
			shifted_uv = vec2(UV.x*0.7 - sin(TIME*time_scale*0.04), UV.y*0.7 + sin(TIME*time_scale*0.04));
			float n3 = texture(noise_tex, shifted_uv).r;
			float n = (n1 + n2*0.5 + n3*0.5)*0.5;

			if (n < 0.4) {
				texel.rgb = colors[2];
			} else if (n > 0.5 && n < 0.54) {
				texel.rgb = colors[0];
			} else {
				texel.rgb = colors[1];
			}
		}
	}
	COLOR = texel;
}
