#version 410 core

layout(location = 0) in vec3 in_position;
layout(location = 1) in vec2 in_texcoord;
layout(location = 2) in vec4 in_color;
out vec2 world_position;
out vec2 texcoord;
out vec4 vertex_color;

uniform mat4 model_view_projection_matrix;
uniform mat4 model_matrix;

void main()
{
    vec4 position4 = vec4(in_position, 1);
    texcoord = in_texcoord;
    vertex_color = in_color;
    world_position = (model_matrix * position4).xy;
    gl_Position = model_view_projection_matrix * position4;
}

#fragment
#version 410 core

in vec2 world_position;
in vec2 texcoord;
in vec4 vertex_color;

uniform sampler2D noise_sampler;
uniform bool has_texture;
uniform float time;

layout(location = 0) out vec4 color;

float rand(vec2 co) {
  return fract(sin(dot(co.xy,vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec3 noise = texture2D(noise_sampler, mod(world_position * 0.0001, 1.0)).xyz;
    float noise_value = (noise.x + noise.y + noise.z) / 3.0;
    vec3 color = vec3(1.0, 1.0, 1.0);
    float brightness = step(0.999, noise_value);
    gl_FragColor = vec4(color * brightness, 1);
}