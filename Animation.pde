public interface IInterpolation{
  PresetPoint interpolate(float t);
}

public class PresetInterpolation implements IInterpolation{
  private Preset preset;

  PresetInterpolation (Preset preset){
    this.preset = preset;
  }

  public PresetPoint interpolate(float t){
    return preset.getPresetState(t);
  }
}

public class TransitionInterpolation implements IInterpolation{
  private Preset current;
  private Preset next;

  TransitionInterpolation (Preset current, Preset next){
    this.current = current;
    this.next = next;
  }

  public PresetPoint interpolate(float t){
    return current.transition(next, t);
  }
}

public class Animation{
  private int numSteps;
  private IInterpolation interpolation;
  private IEasing easing;
  private int step = 0;

  Animation(int numSteps, IInterpolation interpolation, IEasing easing){
    this.numSteps = numSteps;
    this.interpolation = interpolation;
    this.easing = easing;
  }

  public void step(){
    step++;
  }

  public boolean isDone(){
    return step >= numSteps;
  }

  public PresetPoint getAnimationState(){
    float t = ((float) step)/numSteps;
    return interpolation.interpolate(easing.ease(t));
  }
}

public class AnimationPlayList{
  private ArrayList<Preset> presets;
  private boolean isTransitioning = false;
  private int currentAnimation = 0;
  private int nextAnimation = 0;
  private int stepsPerAnimation;
  private int stepsPerTransition;

  AnimationPlayList(ArrayList<Preset> presets, int stepsPerAnimation, int stepsPerTransition){
    this.presets = presets;
    this.stepsPerAnimation = stepsPerAnimation;
    this.stepsPerTransition = stepsPerTransition;
  }

  public Animation getNextAnimation(){
    if (isTransitioning){
      isTransitioning = !isTransitioning;
      currentAnimation = nextAnimation;
      return getPresetAnimation(currentAnimation);
    }
    else{
      isTransitioning = !isTransitioning;
      currentAnimation = nextAnimation;
      nextAnimation = int(random(presets.size()));
      return getTransitionAnimation(currentAnimation, nextAnimation);
    }
  }

  public Animation getPresetAnimation(int index){
    return new Animation(stepsPerAnimation,
                         new PresetInterpolation(presets.get(index)),
                         new CompositeEasing(new SinInOut(), new SinInOut()));
  }

  public Animation getTransitionAnimation(int currentIndex, int nextIndex){
    return new Animation(stepsPerTransition,
                         new TransitionInterpolation(presets.get(currentIndex),
                                                     presets.get(nextIndex)),
                         new QuadOut()); 
  }
}

public class AnimationRunner{
  AnimationPlayList playList;
  Animation currentAnimation;

  AnimationRunner(AnimationPlayList playList){
    this.playList = playList;
    currentAnimation = playList.getNextAnimation();
  }

  public void animate(){
    if (currentAnimation.isDone()) {
      currentAnimation = playList.getNextAnimation();
    }
    else {
      currentAnimation.step();
    }
  }

  public PresetPoint getCurrentAnimationState(){
    return currentAnimation.getAnimationState();
  }
}
