precision mediump float;
varying vec2 v_texCoord;
uniform sampler2D s_texture;
uniform vec4 vColor;
void main() {
  vec4 bitmapColor = texture2D( s_texture, v_texCoord );
  vec4 invertedBitmapColor = vec4(1.0 - bitmapColor.x, 1.0 -bitmapColor.y, 1.0 - bitmapColor.z, bitmapColor.w);
  gl_FragColor = invertedBitmapColor * vColor;
}