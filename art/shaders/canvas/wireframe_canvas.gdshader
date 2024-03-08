shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
uniform int grid_size : hint_range(1, 1000, 1) = 1000;
uniform int grid_thickness : hint_range(1, 10, 1) = 5;
uniform float speed : hint_range(0, 1000, 1) = 100;
uniform vec4 color : source_color = vec4(0,0,0,1);

uniform sampler2D noise_texture: repeat_enable;
uniform float noise_speed : hint_range(0.0, 10.0) = 0.1;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.01;

uniform float radial_dist : hint_range(0.0, 1.0, 0.1) = 0.75;
uniform float intensity : hint_range(0.0, 1.0, 0.1) = 0.5;

void fragment() {
	vec3 noise_color = texture(noise_texture,SCREEN_UV+TIME*noise_speed).rgb;
	vec3 screen_color = texture(screen_texture,SCREEN_UV).rgb;
	int vertex_x = int(VERTEX.x*TIME*speed+noise_color.b*noise_strength);
	int vertex_y = int(VERTEX.y*TIME*speed+noise_color.b*noise_strength);
	if (vertex_x % grid_size < grid_thickness || vertex_y % grid_size < grid_thickness){
		COLOR.rgb = color.rgb;
	}
	else{
		COLOR.rgb = screen_color;
	}
	vec2 centered_uv = (SCREEN_UV * 2.0) - 1.0;
	COLOR.a = (length(centered_uv)-radial_dist)*intensity;
}
