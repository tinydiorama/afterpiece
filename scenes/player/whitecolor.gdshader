shader_type canvas_item;

uniform bool active = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 previousColor = texture(TEXTURE, UV);
	vec4 whiteColor = vec4(previousColor.r * 50.0, previousColor.g * 50.0, previousColor.b * 50.0, previousColor.a);
	vec4 newColor = previousColor;
	if ( active == true ) {
		newColor = whiteColor;
	}
	COLOR = newColor;
	//COLOR = vec4(1.0, 1.0, 1.0, 1.0);
}