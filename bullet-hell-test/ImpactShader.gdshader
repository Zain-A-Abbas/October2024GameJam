shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool impact = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	float brightness = (c.r + c.g + c.b) / 3.0;
	if (!impact) {
		COLOR.rgb = c.rgb;
	} else {
		COLOR.rgb = vec3(step(0.5, brightness));
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
