shader_type canvas_item;

uniform float stripe_impact = 2.0;
uniform float stripe_angle = 1.0;
uniform float stripe_frequency = 40.0;
uniform vec4 stripe_color : source_color;
uniform vec4 background_color : source_color;

void fragment() {
	float stripe = stripe_impact*sin((UV.y - stripe_angle*UV.x + TIME*0.02)*stripe_frequency);
	
	if (stripe > 0.5) {
		COLOR = stripe_color;
	} else {
		COLOR = background_color;
	}
}
