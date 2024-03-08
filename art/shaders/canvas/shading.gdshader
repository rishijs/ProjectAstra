shader_type canvas_item;
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
uniform int type : hint_range(0, 3) = 0;


void fragment() {
	vec3 color = texture(screen_texture,SCREEN_UV).rgb;

	switch(type){
		case 0:
			color.b = 0.0;
			color.g = 0.0;
			COLOR.a =  0.2;
			break;
		case 1:
			color.r = 0.0;
			color.g = 0.0;
			break;
		case 2:
			color.r = 0.0;
			color.b = 0.0;
			break;
		default:
			color.r = 0.5;
			color.g = 0.5;
			color.b = 0.5;
			break;
	}
	COLOR.rgb = color;
	
}
