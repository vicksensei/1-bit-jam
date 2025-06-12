shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 white : source_color;
uniform vec4 blackReplacement : source_color;
uniform vec4 whiteReplacement : source_color;


void fragment() {
	vec4 tex_color = texture(screen_texture, SCREEN_UV, 0.0);
	if( tex_color == white){
		COLOR = whiteReplacement;
	}else{
		COLOR = blackReplacement;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
