shader_type canvas_item;

uniform vec3 color1 = vec3(0.1, 0.6, 0.8);
uniform vec3 color2 = vec3(0.8, 0.1, 0.5);

void fragment(){
	vec3 text_color = texture(TEXTURE, UV).rgb;
	vec3 final_color = vec3(0.0);
	float pct = abs(sin(TIME));
	final_color = mix(color1, color2, pct);
	final_color = mix(final_color, text_color, 0.6);
	COLOR.rgb = final_color;
}

