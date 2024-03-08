shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

const mat4 bayer = mat4(
	vec4(0.0,8.0,2.0,10.0),
	vec4(12.0,4.0,14.0,6.0),
	vec4(3.0,11.0,1.0,9.0),
	vec4(15.0,7.0,13.0,5.0)
);
const int n = 4;

uniform float spread = 1;
uniform float colors = 2;


void fragment() {
	vec4 screen_color = texture(screen_texture,SCREEN_UV);
	// position on screen
	int x = int(UV.x * SCREEN_PIXEL_SIZE.x)%n;
	int y = int(UV.y * SCREEN_PIXEL_SIZE.y)%n;
	float M = bayer[x][y];
	float noise = M * (1.0/float(n*n)) - 0.5;
	vec4 new_color = screen_color + noise * spread;
	vec4 mapped_color = floor(new_color * (colors-1.0)+0.5)/(colors-1.0);
	COLOR = mapped_color;
	
}
