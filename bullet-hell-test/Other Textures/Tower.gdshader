shader_type canvas_item;

uniform vec2 scroll_speed;
uniform float alpha = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, mod(UV + scroll_speed * TIME, 1.0));
	COLOR.a = alpha;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
