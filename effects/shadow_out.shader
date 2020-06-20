shader_type canvas_item;

uniform vec3 color1 = vec3(0.1, 0.1, 0.1);

void fragment(){
	vec3 text_color = texture(TEXTURE, UV).rgb;
	vec3 final_color = mix(text_color, color1, 0.90);
	COLOR.rgb = final_color;
	COLOR.a = texture(TEXTURE, UV).a;
}
