//Retrowave Grid

void main() {
    vec2 p = gl_FragCoord.xy/iResolution.xy;
    vec2 uv = p - 0.5;
    p = vec2(p.x - 0.5, p.y - 0.75);

    p = vec2(p.x / p.y, 1.0 / p.y - iTime);
    p = abs((fract(p * 4.0) - 0.5) * 2.0) - 0.88;
    float grid = max(p.x, p.y);
    grid *= 32.;

    float skymask = clamp(uv.y*2.0+0.9,0.0,1.0);
    vec4 skycolor = mix(vec4(0.3412, 0.0, 0.4, 1.0), vec4(0.0, 0.0, 0.0, 1.0), 1.0-uv.y);
    vec4 gridcolor = vec4(0.8, 0.0, 1.0, 0.0) * grid;
    vec4 col = mix(skycolor,gridcolor , 1.0-skymask);
    
    gl_FragColor = vec4(col);

}
