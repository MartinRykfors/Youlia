public interface IEasing{
  float ease(float t);
}

public class QuadOut implements IEasing{
  float ease(float t){
    return t * (2 - t);
  }
}

public class SinInOut implements IEasing{
  public float ease(float t){
    return -1/2.0 * (cos(PI*t) - 1);
  }
}

public class CompositeEasing implements IEasing{
  private IEasing easing1;
  private IEasing easing2;
  public CompositeEasing(IEasing easing1, IEasing easing2){
    this.easing1 = easing1;
    this.easing2 = easing2;
  }

  public float ease(float t){
    return easing2.ease(easing1.ease(t));
  }
}
