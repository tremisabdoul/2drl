shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform float strength: hint_range(0.0, 100.0, 1);
uniform float power: hint_range(0.0, 100.0, 1);


vec2 vec2_pow(vec2 x, float p)
{
	return vec2(pow(abs(x.x), p)*sign(x.x), pow(abs(x.y), p)*sign(x.y));
}


void fragment() {
	vec2 uv = (SCREEN_UV-.5)*2.;
	vec2 uv2;
	uv2 = uv*strength + vec2_pow(uv, power);
	uv2 /= 4.+(strength-1.)*2.;
	uv2 += .5;
		
	//uv2.x = pow(2.*(uv.x-.5), 10);
	//uv2.y = uv.y;
	//((uv.x-.5)*(1.-.25*uv.y))+.5
	//uv2.x = ((uv.x-.5)*(1.-.25*uv.y))+.5;
	//uv = vec2(
	//	((uv.x-.5)*(1.-.25*uv.y))+.5,
	//	((uv.y-.5)*(1.-.25*uv.x))+.5);
	COLOR = texture(SCREEN_TEXTURE, uv2);
}