extern number rt_h = 600.0; // render target height

extern number intensity = 1.0;

const number offset[3] = number[](0.0, 1.3846153846, 3.2307692308);
const number weight[3] = number[](0.2270270270, 0.3162162162, 0.0702702703);

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
	vec4 texcolor = Texel(texture, texture_coords);
	vec3 tc = texcolor.rgb * weight[0];
	
	tc += Texel(texture, texture_coords + intensity * vec2(0.0, offset[1])/rt_h).rgb * weight[1];
	tc += Texel(texture, texture_coords - intensity * vec2(0.0, offset[1])/rt_h).rgb * weight[1];
	
	tc += Texel(texture, texture_coords + intensity * vec2(0.0, offset[2])/rt_h).rgb * weight[2];
	tc += Texel(texture, texture_coords - intensity * vec2(0.0, offset[2])/rt_h).rgb * weight[2];
	
	return color * vec4(tc, texcolor.a);
}