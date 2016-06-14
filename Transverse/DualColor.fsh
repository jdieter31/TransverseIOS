precision highp float;
varying float ratio;
uniform vec4 vColor;
uniform vec4 vColor2;
void main() {
  gl_FragColor = vColor + ratio * (vColor2 - vColor);
}