shader_type canvas_item;

uniform vec3 background_color: source_color = vec3(0.3, 0.2, 0.8);

float get_particle_x(int i) {
	return (sin(float(i)) * 0.5) * (sin(float(i) * 6.0) +  0.5) * 1.75 + 0.5;
}

void vertex() {
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 col = background_color;
	
	// Wave animation, layered sin waves
	float sine = sin(UV.x * 2.0 + (TIME * 0.3)) * 0.1 + 0.6;
	float sine_2 = abs(sin(UV.x * 5.0 + (TIME * 0.8)) * 0.05);
	float sine_3 = abs(sin(UV.x * 12.0 + (TIME * 1.2)) * 0.02);
	float mask = 1.0 - step(UV.y, sine + sine_2 + sine_3);
	col += mask * 0.1;
	
	// BUBBLES!
	for (int i = 1; i < 20; i++) {
		float particle_x = get_particle_x(i);
		float time_offset = get_particle_x(i+2) * 40.0;
		float speed_offset = get_particle_x(i+3) * 0.75;
		float scale_factor = get_particle_x(i+5) * 0.01;
		
		// Generate a particle position that animates upward based on values generated above
		vec2 particle = vec2(particle_x, (fract((TIME + time_offset) * (-0.06 * speed_offset)) * 2.0) - 0.5);
		
		// Generate circles based on length from point in UV
		float circle = step(length(UV - particle), 0.04 - scale_factor);
		float inner_circle = step(length(UV - particle), (0.04 - scale_factor) - 0.005);
		
		// Add lighter bubble
		col += (circle - (inner_circle * 0.7)) * 0.1;
	}
	
	COLOR = vec4(col, 1.0);
}

