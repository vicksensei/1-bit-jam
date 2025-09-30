shader_type canvas_item;
uniform vec4 target_color : source_color;
uniform vec4 replace_color : source_color;
uniform float tolerance : hint_range(0, 1);
uniform float speed: hint_range(0., 10.) = 0.5;
uniform float frequency : hint_range(0.0, 5.0) = 2;  // frequency of the shine

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float dist = distance(tex_color.rgb, target_color.rgb);

    if (dist < tolerance) {
		vec4 new_color=	vec4(0.5 + sin(2.0*3.14*frequency*TIME),
							   0.5 + sin(2.0*3.14*frequency*TIME + radians(120.0)),
							   0.5 + sin(2.0*3.14*frequency*TIME + radians(240.0)),
							   tex_color.a);
		tex_color.rgb = new_color.rgb;
        //tex_color.rgb = replace_color.rgb;
   }
    COLOR = tex_color;
}