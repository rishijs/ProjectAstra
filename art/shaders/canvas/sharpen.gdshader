shader_type canvas_item;
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;

uniform float sharpness = 1.0;

void fragment() {
	vec2 pixel_size = 1.0 / vec2(textureSize(screen_texture, 0));
	vec4 neighbor_value = vec4(0.0,0.0,0.0,0.0);
    for(int y = -1; y <= 1; y++){
	    for(int x = -1; x <= 1; x++){
	        vec2 offset = vec2(float(x), float(y));
			neighbor_value += texture(screen_texture, UV + offset * pixel_size);
        }
   	}
	vec4 n = neighbor_value * sharpness * -1.0;
	vec4 c = texture(screen_texture, UV + pixel_size) * sharpness * 4.0 + 1.0;
	COLOR = n+c;
}
