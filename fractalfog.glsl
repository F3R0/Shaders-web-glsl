//Fractal Fog
#iChannel0 "file://perlin.png"

#define OCTAVES 4

//rotation matrix
mat2 rotate(in float theta)
{
    float c = cos(theta);
    float s = sin(theta);
    return mat2(c,-s,s,c);
}

//perlin noise texture
float noise(in vec2 p)
{
    return texture(iChannel0, p*0.2).r;
}

//fractal brownian motion
float fbm(in vec2 p) 
{
    float v = 0.0;
    float a = 0.08;
    for (int i = 0; i < OCTAVES; i++) {
        v += a * noise(p);
        p *= 2.;
        a /= 1.32;
    }
    return v;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    uv = uv - 0.5;

    float spheremask = clamp(length(uv*0.16),0.0, 1.0);
    
    float n = noise(uv*fbm((uv-iTime/20.)*3.))-0.45;

    n*=4.0;

    vec4 innerColor = vec4(0.5137, 0.0, 0.0, 0.0);

    uv *= 2.4;
    uv = uv*rotate(fbm(uv+iTime/50.));
    uv += fbm(uv)*uv;
    vec2 speed = iTime * vec2(.045, 0.1);
    
    vec3 col = vec3(fbm(uv-speed), fbm(uv+0.02-speed), fbm(uv+0.03-speed));
    col *= col / spheremask;

    vec4 fogColor = vec4(col*vec3(0.68,0.78,1.0)*(1.0-uv.y),1.0);
    gl_FragColor = mix(fogColor, innerColor, clamp(n,0.0,1.0));
}
