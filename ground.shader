#version 410 core

layout(location = 0) in vec3 in_position;
layout(location = 1) in vec2 in_texcoord;
layout(location = 2) in vec4 in_color;
out vec2 texcoord;
out vec4 vertex_color;

uniform mat4 model_view_projection_matrix;
uniform mat4 model_matrix;

void main()
{
    vec4 position4 = vec4(in_position, 1);
    vertex_color = in_color;
    texcoord = in_texcoord;
    gl_Position = model_view_projection_matrix * position4;
}

#fragment
#version 410 core

in vec2 texcoord;
in vec4 vertex_color;

uniform sampler2D noise_sampler;
uniform bool has_texture;

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
    vec2 p = -.5 + texcoord + vec2(0, 0.25);
    vec3 coord = vec3(atan(p.x * 2,p.y)/6.2832+.5, length(p)*.4 - 1, .5);
    float noise = snoise(coord + vec3(0.,-0.5, 0.3), 16.);

    float c = snoise(coord + vec3(0.,0.5, 0.3), 16.);

    color = vec4(c * 0.2, c * 0.6, c * 0.3, 1);
}
