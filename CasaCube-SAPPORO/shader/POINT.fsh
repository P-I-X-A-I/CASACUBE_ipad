# version 300 es


layout ( location = 0 ) out mediump vec4 fragColor_0;

in mediump float alpha;
uniform sampler2D texImage;

void main()
{
    mediump vec2 ptCoord = gl_PointCoord;
    mediump vec4 texColor = texture( texImage, vec2(ptCoord.x*0.5, ptCoord.y*0.5 + 0.5) );
    fragColor_0 = vec4(ptCoord.x*0.0, ptCoord.y*0.0, 0.0, texColor.a * alpha);
}
