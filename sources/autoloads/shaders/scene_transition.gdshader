shader_type canvas_item;

uniform sampler2D tex : source_color;
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform bool reverse = false;

void fragment() {
	vec4 texel = texture(tex, UV);
	float value = reverse ? 1.0 - texel.r : texel.r;
	if (value > progress) {
		discard;
	}
	COLOR = color;
}
