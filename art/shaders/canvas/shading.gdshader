shader_type canvas_item;
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

uniform vec4 blue_color:source_color;

uniform float noise_speed : hint_range(0.0, 1.0) = 0.1;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.01;
uniform int type : hint_range(0, 3) = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = texture(screen_texture,SCREEN_UV).rgb;

	switch(type){
		case 0:
			color.b = 0.0;
			color.g = 0.0;
			break;
		case 1:
			color = blue_color.rgb;
			COLOR.a = blue_color.a;
			break;
		case 2:
			color.r = 0.0;
			color.b = 0.0;
			break;
		default:
			break;
	}
	COLOR.rgb = color;
	
}

void light() {
	// Called for every pixel for every light affecting the material.
}
