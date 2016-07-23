import processing.video.*;

Capture webcam;
PShader fractalShader;
boolean isCalibrating = true;
PGraphics camGraphics;
ArrayList<Preset> presets = new ArrayList<Preset>();
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
  PVector fractalParameters = getFractalParameters();
  fractalShader.set("c1", fractalParameters.x);
  fractalShader.set("c2", fractalParameters.y);
  fractalShader.set("rotation", rotation);
  if (isCalibrating){
    fractalShader.set("calibrate", 1);
  }
  else
  {
    fractalShader.set("calibrate", 0);
  }
}

public PVector getFractalParameters(){
  float c1 = (mouseX/float(width) -0.5f)*1f;
  float c2 = (mouseY/float(height) -0.5f)*1f;
  return new PVector(c1, c2);
}

PresetPoint firstPoint = null;

public void mousePressed() {
  if (firstPoint == null){
    PVector fractalParameters = getFractalParameters();
    firstPoint = new PresetPoint(fractalParameters.x, fractalParameters.y, rotation);
  }
  else{
    PVector fractalParameters = getFractalParameters();
    PresetPoint endPoint = new PresetPoint(fractalParameters.x, fractalParameters.y, rotation);
    Preset preset = new Preset(firstPoint, endPoint);
    presets.add(preset);
    firstPoint = null;
  }
}

public void keyPressed() {
  if (keyCode == UP){
    rotation += 0.1;
  }
  else if (keyCode == DOWN){
    rotation -= 0.1;
  }
  else if (key == 's'){
    //saveFrame("read####.png");
    JSONArray json = new JSONArray();
    for (int i = 0; i < presets.size(); i++){
      json.setJSONObject(i, presets.get(i).toJSON());
    }
    saveJSONArray(json, "data/test.json");
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
