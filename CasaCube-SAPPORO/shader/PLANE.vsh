# version 300 es

layout ( location = 0 ) in mediump vec4 position;
layout ( location = 1 ) in mediump vec4 color;

out mediump vec4 color_v;

uniform mat4 mvpMatrix;

void main()
{
    gl_Position = mvpMatrix * position;
    color_v = color;
}
