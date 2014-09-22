#version 410 core

layout(location = 0) in vec3 in_position;
layout(location = 1) in vec2 in_texcoord;
out vec2 texcoord;

uniform mat4 model_view_projection_matrix;

void main()
{
    vec4 position4 = vec4(in_position, 1);
    texcoord = in_texcoord;
    gl_Position = model_view_projection_matrix * position4;
}

#fragment
#version 410 core

in vec2 texcoord;

uniform float time;
uniform float thrust;

layout(location = 0) out vec4 color;

float snoise(vec3 uv, float res)
{
    const vec3 s = vec3(1e0, 1e2, 1e3);
    
    uv *= res;
    
    vec3 uv0 = floor(mod(uv, res))*s;
    vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
    
    vec3 f = fract(uv); f = f*f*(3.0-2.0*f);

    vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
                  uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

    vec4 r = fract(sin(v*1e-1)*1e3);
    float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
    
    r = fract(sin((v + uv1.z - uv0.z)*1e-1)*1e3);
    float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
    
    return mix(r0, r1, f.z)*2.-1.;
}

void main()
{
    vec2 p = -.5 + texcoord;

    float t = thrust == 0.0 ? 0.0001 : thrust;

    p *= 1/-t;

    float color = 3.0 - (3.*length(2.3*p));
    
    vec3 coord = vec3(atan(p.x * 2,p.y)/6.2832+.5, length(p)*.4, .5);
    
    for(int i = 1; i <= 7; i++)
    {
        float power = pow(2.0, float(i));
        color += (1.5 / power) * snoise(coord + vec3(0.,-time*0.5, time*0.3), power*16.);
    }
    gl_FragColor = vec4(color, pow(max(color,0.),2.)*0.4, pow(max(color,0.),3.)*0.15 , color);

    if (p.y > 0)
        gl_FragColor = vec4(0, 0, 0, 0);
}
