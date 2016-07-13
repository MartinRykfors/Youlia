import processing.video.*;
import java.lang.*;
Capture webcam;
PShader _shader;

void setup() {
  size(1200, 800, P2D);
  webcam = new Capture(this, 1200, 800); 
  webcam.start(); 
  String[] devices = Capture.list();
  println(devices);
  reloadShader();
  //frameRate(1);
}

void draw() {  

  webcam.read();
  shader(_shader);
  image(webcam, 0, 0);

  float c1 = (mouseX/float(width) -0.5f)*1f;
  float c2 = (mouseY/float(height) -0.5f)*1f;
  _shader.set("c1", c1);
  _shader.set("c2", c2);
}

public void mousePressed() {
  reloadShader();
}

public void keyPressed() {
  saveFrame("line-######.png");
}

public void reloadShader() {
  try {
    _shader = loadShader("traptex.glsl");
  }
  catch (RuntimeException e) {
    e.printStackTrace();
  }
}
