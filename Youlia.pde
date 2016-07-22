import processing.video.*;

Capture webcam;
PShader fractalShader;
boolean isCalibrating = true;

void setup() {
  size(1200, 800, P2D);
  webcam = new Capture(this, 1200, 800); 
  webcam.start(); 
  String[] devices = Capture.list();
  println(devices);
  reloadShader();
}

void draw() {  

  webcam.read();
  shader(fractalShader);
  image(webcam, 0, 0);

  float c1 = (mouseX/float(width) -0.5f)*1f;
  float c2 = (mouseY/float(height) -0.5f)*1f;
  fractalShader.set("c1", c1);
  fractalShader.set("c2", c2);
  fractalShader.set("rotation", millis()/3000.0f);
  if (isCalibrating){
    fractalShader.set("calibrate", 1);
  }
  else
  {
    fractalShader.set("calibrate", 0);
  }
}

public void mousePressed() {
  reloadShader();
}

public void keyPressed() {
  isCalibrating = !isCalibrating;
}

public void reloadShader() {
  try {
    fractalShader = loadShader("traptex.glsl");
  }
  catch (RuntimeException e) {
    e.printStackTrace();
  }
}
