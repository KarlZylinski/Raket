#version 410 core

layout(location = 0) in vec3 in_position;
layout(location = 1) in vec2 in_texcoord;
layout(location = 2) in vec4 in_color;
out vec2 world_position;out vec4 vertex_color;

uniform mat4 model_view_projection_matrix;
uniform mat4 model_matrix;

void main()
{
    vec4 position4 = vec4(in_position, 1);
    vertex_color = in_color;
    world_position = (model_matrix * position4).xy;
    gl_Position = model_view_projection_matrix * position4;
}

#fragment
#version 410 core

in vec2 world_position;
in vec4 vertex_color;

uniform sampler2D noise_sampler;
uniform bool has_texture;
uniform float time;
uniform float view_resolution_ratio;
uniform vec2 resolution;

layout(location = 0) out vec4 color;

float rand(vec2 co)
{
  return fract(sin(dot(co.xy,vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    float tecoord_scalar = 0.001;
    float texel_width = (1.0 / resolution.x) * 0.2;
    float texel_height = (1.0 / resolution.y) * 0.15;
    vec2 texcoord = world_position * tecoord_scalar;
    vec2 texcoord_right = floor((texcoord + vec2(texel_width, texel_height)) * 200.0) / 200.0;
    vec2 texcoord_left = floor((texcoord - vec2(-texel_width, texel_height)) * 200.0) / 200.0;
    vec2 texcoord_up = floor((texcoord + vec2(-texel_width, -texel_height)) * 200.0) / 200.0;
    vec2 texcoord_down = floor((texcoord - vec2(texel_width, -texel_height)) * 200.0) / 200.0;
    float noise_right = texture2D(noise_sampler, texcoord_right).x;
    float noise_left = texture2D(noise_sampler, texcoord_left).x;
    float noise_up = texture2D(noise_sampler, texcoord_up).x;
    float noise_down = texture2D(noise_sampler, texcoord_down).x;
    float brightness = step(3.9, (step(0.997, noise_right) + step(0.997, noise_left) + 
        step(0.997, noise_up) + step(0.997, noise_down)));
    vec2 world_coord = sin(world_position);
    vec3 color = vec3(clamp(world_coord.x, 0.6, 0.9), clamp(world_coord.y, 0.5, 0.8), clamp(world_coord.y, 0.7, 1.0));
    gl_FragColor = vec4(color * brightness, 1);
}