attribute vec4 vPosition;

uniform mat4 uMVPMatrix;
uniform float pointSize;
attribute float aAlpha;
varying float vAlpha;    // This will be passed into the fragment shader.

void main()
{
    vAlpha = aAlpha;
    gl_Position = uMVPMatrix * vPosition;
    gl_PointSize = pointSize;

}