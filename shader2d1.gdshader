shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

group_uniforms motion_blur;

uniform bool motion_blur_effect_enabled = true;
uniform float motion_blur_quality: hint_range(1.0, 256.0, 1) = 8;
uniform float motion_blur_boost: hint_range(1.0, 4.0, .1) = 1;
uniform vec2 velocity = vec2(0, 0);

group_uniforms distortion;
uniform bool distortion_effect_enabled = true;
uniform float distortion_strength: hint_range(0.0, 100.0, .1) = 32;
uniform float distortion_power: hint_range(0.0, 100.0, .1) = 8;


vec2 vec2_pow(vec2 x, float p)
{
	return vec2(pow(abs(x.x), p)*sign(x.x), pow(abs(x.y), p)*sign(x.y));
}


void fragment()
{
	vec2 uv = SCREEN_UV;
	if (distortion_effect_enabled)
	{
		uv = (uv-.5)*2.;
		uv = uv*distortion_strength + vec2_pow(uv, distortion_power);
		uv /= 4.+(distortion_strength-1.)*2.;
		uv += .5;
	}
	vec4 color = vec4(0.);
	float blend = 1.;
	if (motion_blur_effect_enabled)
	{
		vec2 v = velocity*SCREEN_PIXEL_SIZE*motion_blur_boost;
		blend += motion_blur_quality;
		for (float i=1.; i<=motion_blur_quality; i++)
			color += texture(SCREEN_TEXTURE, uv+(v*i)/motion_blur_quality)/blend;
	}
	color += texture(SCREEN_TEXTURE, uv)/blend;
	COLOR = color;
}
