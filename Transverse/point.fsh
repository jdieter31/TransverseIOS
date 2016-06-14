precision mediump float;

uniform sampler2D texture;
uniform vec4 vColor;

varying float vAlpha;

void main()
{
    vec4 color = texture2D(texture, gl_PointCoord);
    gl_FragColor = vec4(vColor.x, vColor.y, vColor.z,color.w*vAlpha);
}