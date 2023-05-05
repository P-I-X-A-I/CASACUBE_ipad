#version 300 es

in mediump vec2 texCoord_v;

layout ( location = 0 ) out mediump vec4 fragColor_0;

uniform sampler2D imageTexture;
uniform mediump float texAlpha;

void main()
{
    mediump vec4 texColor = texture( imageTexture, texCoord_v );
    
    fragColor_0 = vec4( texColor.rgb, texColor.a * texAlpha);
}
