import processing.video.*;

Capture webcam;
PShader fractalShader;
boolean isCalibrating = true;
PGraphics camGraphics;
float rotation = 0.0;

void setup() {
  size(1200, 800, P2D);
  String[] devices = Capture.list();
  println(devices);
  reloadShader();
  camGraphics = createGraphics(1200, 800, P2D);
  webcam = new Capture(this, 1200, 800);
  webcam.start();
}

void draw() {
  webcam.read();
  camGraphics.beginDraw();
  camGraphics.shader(fractalShader);
  camGraphics.image(webcam, 0, 0);
  camGraphics.endDraw();
  textSize(20);
  fill(255);
  image(camGraphics, 0,0);
  textAlign(RIGHT, BOTTOM);
  text("@rykarn", width, height);
  float c1 = (mouseX/float(width) -0.5f)*1f;
  float c2 = (mouseY/float(height) -0.5f)*1f;
  fractalShader.set("c1", c1);
  fractalShader.set("c2", c2);
  fractalShader.set("rotation", rotation);
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
  if (keyCode == UP){
    rotation += 0.1;
  }
  else if (keyCode == DOWN){
    rotation -= 0.1;
  }
  else if (key == 's'){
    saveFrame("read####.png");
  }
  else{
    isCalibrating = !isCalibrating;
  }
}

public void reloadShader() {
  try {
    fractalShader = loadShader("traptex.glsl");
  }
  catch (RuntimeException e) {
    e.printStackTrace();
  }
}
