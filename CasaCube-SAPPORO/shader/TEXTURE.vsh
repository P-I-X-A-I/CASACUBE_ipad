# version 300 es

layout ( location = 0 ) in mediump vec4 position;
layout ( location = 1 ) in mediump vec4 texCoord;

out mediump vec2 texCoord_v;

uniform mat4 mvpMatrix;

void main()
{
    gl_Position = mvpMatrix * position;
    texCoord_v = texCoord.xy;
}
