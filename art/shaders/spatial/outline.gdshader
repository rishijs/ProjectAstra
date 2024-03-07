shader_type spatial;
render_mode unshaded;

uniform bool solid = true;
uniform float strength : hint_range(0.0, 5.0) = 1.0;
uniform vec4 color : source_color = vec4(0,0,0,1);

void fragment() {
	float fresnel = clamp((1.0 - ((dot(NORMAL,VIEW)) * strength * color.a)), 0.0, 1.0);
	ALBEDO = color.rgb;
	if (solid == true){
		ALPHA = step(0.5,fresnel);
	}
	else{
		ALPHA = fresnel;
	}
}