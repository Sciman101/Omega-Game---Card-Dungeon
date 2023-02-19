shader_type spatial;
render_mode unshaded;

uniform vec3 color_north : source_color;
uniform vec3 color_east : source_color;
uniform vec3 color_floor : source_color;

varying vec3 normal;
void vertex() {
	normal = NORMAL;
}

void fragment() {
	// lock normals
	float floor_amount = ceil(abs(normal.y)-0.5);
	float wall_amount = ceil(abs(normal.z)-0.5);
	
	// TODO add fog
	
	ALBEDO = mix(mix(color_north,color_east,wall_amount),color_floor,floor_amount);
}
