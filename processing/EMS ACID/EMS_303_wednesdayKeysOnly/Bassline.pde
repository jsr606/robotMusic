float tuning, cutoff, resonance, envmod, decay, accent;
int midiBaseNote = 36; // C1
boolean midi = false;

boolean knobTweaking = false;
int currentKnob = RESONANCE;

class Bassline {
  boolean playing = true;

  public float posX, posY;  
  public int midiChannel = 0;

  public int pattern = 0;

  static final int A = 0, B = 0;
  public int patternSection = A;

  public Bassline () {
    posX = 100;
    posY = 100;
  }


  void dumpData() {
  }

  void update() {
  }
}
