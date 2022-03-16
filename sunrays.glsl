//Sunrays
#iChannel0 "file://perlin.png"

void main() {

  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  vec2 p = uv - 0.5;

  p += vec2(0.0,-0.15);

	vec2  t = vec2(atan(p.x, p.y)*6.0 / 3.1416, 1. / length(p)*0.02);
	vec2  s = iTime * vec2(.05, .1);
	float m = t.y * 5.0;
	float perl = 1.0-texture(iChannel0, t+s).x/m;
  perl *= 5.0;
  
  vec3 col = mix(vec3(0.5216, 0.0, 0.0), vec3(1.0, 0.7333, 0.0), perl);

  gl_FragColor = vec4(col,1.0);

}
