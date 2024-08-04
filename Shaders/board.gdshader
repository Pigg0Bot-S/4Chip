shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 st = FRAGCOORD.xy;
	float pct = 0.0;
	
	pct = distance(st,vec2(50.0));
	COLOR.xyz = vec3(pct);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
