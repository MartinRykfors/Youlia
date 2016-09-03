import processing.video.*;

Capture webcam;
PShader fractalShader;
boolean isCalibrating = true;
PGraphics camGraphics;
ArrayList<Preset> presets;
float rotation = 0.0;
AnimationRunner animationRunner;

void setup() {
  size(1200, 800, P2D);
  String[] devices = Capture.list();
  println(devices);
  readPresets();
  animationRunner = new AnimationRunner(new AnimationPlayList(presets, 600, 60));
  reloadShader();
  camGraphics = createGraphics(1200, 800, P2D);
  webcam = new Capture(this, 1200, 800, "FaceTime HD Camera", 30);
  webcam.start();
}

void readPresets(){
  presets = new ArrayList<Preset>();
  JSONArray json = loadJSONArray("data/presets.json");
  for (int i = 0; i < json.size(); i++){
    JSONObject presetJSON = json.getJSONObject(i);
    JSONObject startPointJSON = presetJSON.getJSONObject("start");
    JSONObject endPointJSON = presetJSON.getJSONObject("end");
    PresetPoint start = new PresetPoint(startPointJSON.getFloat("c1"),
                                        startPointJSON.getFloat("c2"),
                                        startPointJSON.getFloat("rotation"));
    PresetPoint end = new PresetPoint(endPointJSON.getFloat("c1"),
                                      endPointJSON.getFloat("c2"),
                                      endPointJSON.getFloat("rotation"));
    presets.add(new Preset(start, end));
  }
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
  if (false){
    PVector fractalParameters = getFractalParameters();
    fractalShader.set("c1", fractalParameters.x);
    fractalShader.set("c2", fractalParameters.y);
    fractalShader.set("rotation", rotation);
  }
  else {
    animationRunner.animate();
    PresetPoint presetPoint = animationRunner.getCurrentAnimationState();
    fractalShader.set("c1", presetPoint.c1);
    fractalShader.set("c2", presetPoint.c2);
    fractalShader.set("rotation", presetPoint.rotation);
  }
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
    JSONArray json = new JSONArray();
    for (int i = 0; i < presets.size(); i++){
      json.setJSONObject(i, presets.get(i).toJSON());
    }
    saveJSONArray(json, "data/presets.json");
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
