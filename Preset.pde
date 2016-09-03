public class PresetPoint{
  public float c1;
  public float c2;
  public float rotation;

  public PresetPoint(float c1, float c2, float rotation){
    this.c1 = c1;
    this.c2 = c2;
    this.rotation = rotation;
  }

  public JSONObject toJSON(){
    JSONObject json = new JSONObject();
    json.setFloat("c1", c1);
    json.setFloat("c2", c2);
    json.setFloat("rotation", rotation);
    return json;
  }

  public PresetPoint lerpTo(PresetPoint next, float t){
    return new PresetPoint(lerp(this.c1, next.c1, t),
                           lerp(this.c2, next.c2, t),
                           lerp(this.rotation, next.rotation, t));
  }

  public PresetPoint normalizedRotation(){
    return new PresetPoint(this.c1, this.c2, this.rotation % (2*PI));
  }
}

public class Preset{
  PresetPoint start;
  PresetPoint end;

  public Preset(PresetPoint start, PresetPoint end){
    this.start = start;
    this.end = end;
  }

  public JSONObject toJSON(){
    JSONObject json = new JSONObject();
    json.setJSONObject("start", start.toJSON());
    json.setJSONObject("end", end.toJSON());
    return json;
  }

  public PresetPoint getPresetState(float t){
    return start.lerpTo(end, t);
  }

  public PresetPoint transition(Preset next, float t){
    return this.end.normalizedRotation().lerpTo(next.start.normalizedRotation(), t);
  }
}
