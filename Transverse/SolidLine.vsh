uniform mat4 uMVPMatrix;    // A constant representing the combined model/view/projection matrix.
attribute vec4 vPosition;    // Per-vertex position information we will pass in.
attribute float aAlpha;
varying float vAlpha;    // This will be passed into the fragment shader.
void main() {     // The entry point for our vertex shader.
  vAlpha = aAlpha;    // Pass the color through to the fragment shader.
  gl_Position = uMVPMatrix * vPosition;    // gl_Position is a special variable used to store the final position.
}