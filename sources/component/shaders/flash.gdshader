shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 texel = texture(TEXTURE, UV);
	COLOR = vec4(mix(texel.rgb, vec3(1.0), strength), texel.a);
}
