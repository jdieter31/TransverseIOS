uniform mat4 uMVPMatrix;
varying float ratio;
attribute vec4 vPosition;
attribute float aAlpha;
uniform float width;
varying float vAlpha;
void main() {
  ratio = vPosition.x/width;
  vAlpha = aAlpha;
  gl_Position = uMVPMatrix * vPosition;
}