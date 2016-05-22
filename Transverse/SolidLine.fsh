precision mediump float;
uniform vec4 vColor;
varying float vAlpha;
void main() {
  gl_FragColor = vec4(vColor.x, vColor.y, vColor.z, vColor.w * vAlpha);
}