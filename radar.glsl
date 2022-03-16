//Radar
#iChannel0 "file://perlin.png"

#define TIMESCALE 0.15
#define OCTAVES 5.0

float noise( in vec2 x ){return texture2D(iChannel0, x*0.1).x;}

//fractal brownian motion
float fbm(in vec2 p)
{	
	float a = 2.0;
	float v = (sin(iTime*20.0))/100.0;

	for (float i= 1.0;i < OCTAVES;i++)
	{
		v+= abs(1.0-noise(p+iTime)*2.0)/a;
		a *= 2.0;
		p *= 2.0;
		
	}
	return v;
}

//Circle
float circ(vec2 p, float t) 
{
	float r = length(p)-mod(t,8.0);
	return r;
}

//Line Segment
float line( in vec2 p, in vec2 a, in vec2 b, float th )
{
    float l = clamp( dot(p-a,b-a)/dot(b-a,b-a), 0.0, 0.75 );
    return smoothstep(th, -th *0.05, length( (p-a) - (b-a)*l ));
}

void main() {
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
  float time = iTime * TIMESCALE;
	vec2 p = uv - 0.5;

	//Red Dot
	vec2 pos = p+vec2(0.3,-0.2)-vec2(sin(time*2.0)/4.0,cos(time*1.5)/4.0);
	float sphere = 1.0-length(pos)-0.96;
	sphere = clamp(sphere*20.0*(1.0+sin(time*50.0)),0.0,1.0);
	vec3 reddot = vec3(sphere,0,0);

	//Line
	float lineLength = 1.0;
  vec2 origin = vec2(0.0,0.0);
  vec2 end = vec2(lineLength*sin(time*20.0),lineLength*cos(time*20.0));
  float line = line(p, origin, end, 0.2);

	//vignette
	float vignette = clamp(1.0-(length(p)+0.025)*1.2,0.0,1.0);

	//Scale
	p*=10.0;

	//Circle
	float shapes = fbm(p)*2.0;
	shapes *= circ(p, time*15.0) * circ(p, 2.0+time*15.0) * circ(p,-4.0+time*15.0) * circ(p, -2.0+time*15.0) * (1.0-line);
	
	//Scanline
	float scan = clamp(sin(abs(uv.y)*500.0),0.0,1.0);	
	
	//final color
	vec3 col = vec3(0.0627, 0.3451, 0.098)/shapes;
	col=pow(abs(col),vec3(0.6));
	col=mix(col,reddot, sphere);

  gl_FragColor = vec4(col*(scan+0.5)*vignette,1.0);

}
