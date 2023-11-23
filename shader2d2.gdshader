shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;


void fragment()
{
	vec2 uv = SCREEN_UV;
	uv.x = ((uv.x-.5)*(1.-.25*uv.y))+.5;
	COLOR = texture(SCREEN_TEXTURE, uv);
}
