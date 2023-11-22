shader_type spatial;
render_mode unshaded;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
//uniform sampler2D TEXTURE;

void fragment() {
	vec2 uv = round(SCREEN_UV*256.)/256.;
	vec4 LAYER1 = texture(SCREEN_TEXTURE, uv);
	//vec4 LAYER2 = texture(TEXTURE, uv);
	vec4 LAYER2 = vec4(.2, 0., .5, 1.);
	LAYER2.a = float(1-min(int(TIME*8.+(uv.x+uv.y)*64.)%3, 1))*.1+.5;
	
	ALBEDO = (LAYER1.rgb*(1.-LAYER2.a) + LAYER2.rgb*LAYER2.a);
}
