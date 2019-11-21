int beats, voice, shift, beatLength, activeTrigger;
int midiBaseNote = 36; // C1
boolean midi = false;
int maxBeats = 16, maxVoices = 16;

class Drummachine {
  int amountOfTriggers = 16, maxSteps = 16;
  boolean[][] steps = new boolean[amountOfTriggers][maxSteps];
  ArrayList rythms;

  boolean playing = true;
  public int BPM = 140;
  int lastBeat = millis();
  public int beatDivision = 4;
  int beatRest = 60000 / BPM / beatDivision;
  int currentStep = 0;
  public float posX, posY;  
  public int midiChannel = 0;

  public Drummachine (float x, float y) {
    rythms = new ArrayList();
    rythms.add(new Rythm("tr1", 16, 0));
    rythms.add(new Rythm("tr2", 16, 0));
    rythms.add(new Rythm("tr3", 16, 0));
    rythms.add(new Rythm("tr4", 16, 0));
    rythms.add(new Rythm("tr5", 16, 0));
    rythms.add(new Rythm("tr6", 16, 0));
    rythms.add(new Rythm("tr7", 16, 0));
    rythms.add(new Rythm("tr8", 16, 0));
    rythms.add(new Rythm("tr9", 16, 0));
    rythms.add(new Rythm("tr10", 16, 0));
    rythms.add(new Rythm("tr11", 16, 0));
    rythms.add(new Rythm("tr12", 16, 0));
    rythms.add(new Rythm("tr13", 16, 0));
    rythms.add(new Rythm("tr14", 16, 0));
    rythms.add(new Rythm("tr15", 16, 0));
    rythms.add(new Rythm("tr16", 16, 0));

    for (int i = 0; i<rythms.size(); i++) {
      Rythm r = (Rythm) rythms.get(i);
      r.updateRythm();
    }

    posX = x;
    posY = y;
  }

  void updateBeatLength(int theRythm, int theBeatLength) {
    Rythm r = (Rythm) rythms.get(theRythm);
    int b = constrain(theBeatLength, 1, r.maxSteps);
    r.steps = b;
  }

  void updateRythm(int theRythm, int theBeats) {
    Rythm r = (Rythm) rythms.get(theRythm);
    r.beats = theBeats;
    r.updateRythm();
  }

  void shiftRythm(int theRythm, int theShift) {
    Rythm r = (Rythm) rythms.get(theRythm);
    r.shift = theShift;
  }

  String getRythm(int theRythm) {
    Rythm r = (Rythm) rythms.get(theRythm);
    String returnRythm = r.getStepsAsString();
    return(returnRythm);
  }

  void doRandom(float intensity) {
    println("randomize!");
    for (int i = 0; i<rythms.size(); i++) {
      Rythm r = (Rythm) rythms.get(i);  
      if (r.muted) {
        float lower = map(intensity, 0, 1, 10, 1);
        updateBeatLength(i, int(random(lower, 16)));
        float beats = map(intensity, 0, 1, 0, float(r.steps)*random(1, 2));
        beats = constrain(beats, 1.1, r.steps);
        r.beats = int(beats);
        int s = int(random(0,r.beats)/2);
        r.shift = s;
        r.updateRythm();
      }
    }
  }

  void randomizeMuted(int maxVoices) {
    int voicesOn = 0;
    for (int i = 0; i<rythms.size()-4; i++) {
      Rythm r = (Rythm) rythms.get(i);  
      
      if (random(rythms.size()) > (i+2) && voicesOn < maxVoices) {
        r.muted = false;
        voicesOn ++;
      } else {
        r.muted = true;
      }
    }
  }

  void update() {    
    boolean nextStep = false;
    if (playing && lastBeat + beatRest < millis()) {
      nextStep = true;
      lastBeat = millis();
    }

    float size = 15;
    for (int i = 0; i<rythms.size(); i++) {
      Rythm r = (Rythm) rythms.get(i);
      float pY = posY + (size+2) * i;
      if (nextStep) {
        r.nextStep();
        int j = (r.currentStep+r.shift+r.steps)%r.steps;
        int v = r.stepVel[j];
        if (midi == true && v > 0) {
          mSynth.noteOn(midiBaseNote+i, v, 1);
        }
      }
      color c = color(150);
      if (i == activeTrigger) {
        r.activeColor = color(255,0,0);
      } else {
        r.activeColor = color(255);
      }
      r.drawMinimalSequence(posX, pY, size, c);
    }
  }
}
