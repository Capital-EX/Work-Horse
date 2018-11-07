shader_type canvas_item;

void vertex() {
	VERTEX.y += sin(TIME * 2.0 + floor(VERTEX.x / 3.0));
}