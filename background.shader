#version 410 core

layout(location = 0) in vec3 in_position;
layout(location = 1) in vec2 in_texcoord;
layout(location = 2) in vec4 in_color;
out vec2 world_position;
out vec2 texcoord;
out vec4 vertex_color;

uniform mat4 model_view_projection_matrix;

void main()
{
    vec4 position4 = vec4(in_position, 1);
    texcoord = in_texcoord;
    vertex_color = in_color;
    gl_Position = model_view_projection_matrix * position4;
}

#fragment
#version 410 core

in vec2 world_position;
in vec2 texcoord;
in vec4 vertex_color;

uniform sampler2D texture_sampler;
uniform bool has_texture;
uniform float time;
uniform float height;

layout(location = 0) out vec4 color;

float random(vec2 ab) 
{
    float f = (cos(dot(ab ,vec2(21.9898,78.233))) * 43758.5453);
    return fract(f);
}

float noise(in vec2 xy) 
{
    vec2 ij = floor(xy);
    vec2 uv = xy-ij;
    uv = uv*uv*(3.0-2.0*uv);
    

    float a = random(vec2(ij.x, ij.y ));
    float b = random(vec2(ij.x+1., ij.y));
    float c = random(vec2(ij.x, ij.y+1.));
    float d = random(vec2(ij.x+1., ij.y+1.));
    float k0 = a;
    float k1 = b-a;
    float k2 = c-a;
    float k3 = a-b-c+d;
    return (k0 + k1*uv.x + k2*uv.y + k3*uv.x*uv.y);
}

void main( void ) {
    vec2 position = gl_FragCoord.xy;

    float color = pow(noise(position), 40.0) * 20.0;

    float r1 = noise(position*noise(vec2(sin(time*0.01))));
    float r2 = noise(position*noise(vec2(cos(time*0.01), sin(time*0.01))));
    float r3 = noise(position*noise(vec2(sin(time*0.05), cos(time*0.05))));
        
    gl_FragColor = vec4(vec3(color*r1, color*r2, color*r3), 1.0);
}
