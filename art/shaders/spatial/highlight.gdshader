shader_type spatial;
render_mode unshaded;

uniform float stripes : hint_range(0.0, 5.0) = 1;
uniform float speed : hint_range(0.1, 5.0) = 1;
uniform float interval : hint_range(0.1, 5.0) = 1;
uniform vec4 color : source_color = vec4(1,1,1,1);

void fragment() {
	vec3 vertex = (VIEW_MATRIX * vec4(VERTEX,1.0)).xyz;
	float frequency = clamp(floor(tan(vertex.y/stripes + TIME * speed * interval)),0,1.0);
	ALBEDO = color.rgb;
	ALPHA = clamp((1.0-dot(NORMAL,VIEW)) * frequency * color.a,0.0,1.0);
}