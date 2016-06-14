precision highp float;
varying float ratio;
uniform vec4 vColor;
uniform vec4 vColor2;
varying float vAlpha;
void main() {
  vec4 color = vColor + ratio * (vColor2 - vColor);
  gl_FragColor = vec4(color.x, color.y, color.z, color.w * vAlpha);
}