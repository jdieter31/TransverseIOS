uniform mat4 uMVPMatrix;
varying float ratio;
attribute vec4 vPosition;
uniform float width;
void main() {
  ratio = vPosition.x/width;
  gl_Position = uMVPMatrix * vPosition;
}