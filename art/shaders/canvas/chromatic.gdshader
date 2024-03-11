shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

uniform vec2 red_displacement = vec2(-10,0);
uniform vec2 green_displacement = vec2(0,0);
uniform vec2 blue_displacement = vec2(10,0);

uniform float magnitude = 2.0;

void fragment() {
	vec3 screen_color = texture(screen_texture,SCREEN_UV).rgb;
	float red = (texture(screen_texture,SCREEN_UV+vec2(SCREEN_PIXEL_SIZE*red_displacement),0.0)).r;
	float green = (texture(screen_texture,SCREEN_UV+vec2(SCREEN_PIXEL_SIZE*green_displacement),0.0)).g;
	float blue = (texture(screen_texture,SCREEN_UV+vec2(SCREEN_PIXEL_SIZE*blue_displacement),0.0)).b;
		
	COLOR.rgb = screen_color * normalize(vec3(red,green,blue));
	
}

