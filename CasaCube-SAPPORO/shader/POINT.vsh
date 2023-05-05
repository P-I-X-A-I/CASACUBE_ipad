# version 300 es

layout ( location = 0 ) in mediump vec4 position;
layout ( location = 1 ) in mediump vec2 ptSizeAndAlpha;

out mediump float alpha;

uniform mat4 mvpMatrix;

void main()
{
    gl_Position = mvpMatrix * position;
    
    gl_PointSize = ptSizeAndAlpha.x;
    
    alpha = ptSizeAndAlpha.y;
}

