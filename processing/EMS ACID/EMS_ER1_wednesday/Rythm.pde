// euclidian rythm

class Rythm {

  public String name;

  public int steps = 16;    // on the ER-1 this is always 16
  public int maxSteps = 16;
  public int[] stepVel;
  int currentStep = 0;

  // for euclidian rythm generation
  public int beats;
  float[] beatPositions;
  float[] stepPosition;
  int[] closestStep;
  int shift = 0;

  boolean muted = false;

  public color activeColor = color(255);
  public color inActiveColor = color(50);

  public Rythm(String theName, int theSteps, int theBeats) {
    name = theName;
    steps = theSteps;
    beats = theBeats;
    beatPositions = new float[maxSteps];
    stepPosition = new float[maxSteps];
    closestStep = new int[maxSteps];
    stepVel = new int[maxSteps];
  }

  public void nextStep () {
    currentStep = (currentStep + 1) % steps;
  }

  public String getStepsAsString() {
    String returnString = "";
    for (int i=0; i<steps; i++) {
      if (stepVelocity(i) == 0) {
        returnString += "0";
      } else {
        returnString += "1";
      }
    }
    return returnString;
  }

  public int stepVelocity(int theStep) {
    int shiftedIndex = (theStep+shift+steps)%steps;
    return stepVel[shiftedIndex];
  }

  public void drawRythm(float theXPos, float theYPos, float boxSize, color strokeColor) {
    pushMatrix();
    translate(theXPos, theYPos);
    // track name
    fill(255);
    textAlign(RIGHT, TOP);
    text(name, -23, 3);
    textAlign(LEFT, TOP);
    pushMatrix();
    // draw boxes and progress
    for (int i = 0; i<steps; i++) {      
      // change color and stroke relating to beat progress
      if (i == currentStep) {
        stroke(activeColor);
        strokeWeight(2);
      } else {
        stroke(strokeColor);
        strokeWeight(1);
      }
      fill (stepVelocity(i));
      rect(0, 0, boxSize, boxSize);
      translate(boxSize+1, 0);
    }
    popMatrix();
    
    // draw ellipse to show if track is muted or not
    /*
    strokeWeight(2);
    if (muted) {
      stroke(255);
    } else {
      stroke(150);
    }
    translate(-10, boxSize/2);
    if (muted) {
      fill(0);
    } else {
      fill(100);
    }
    ellipseMode(CENTER);
    ellipse(0, 0, boxSize-4, boxSize-4);
    */
    popMatrix();
  } 

  public void generateRythm() {
    float stepLength = 1/float(steps);
    float beatLength = 1/float(beats);
    float stepsAccumulation = 0;
    float beatAccumulation = 0;

    for (int i = 0; i<steps; i++) {
      stepPosition[i] = stepsAccumulation;
      stepsAccumulation += stepLength;
    }

    for (int i = 0; i<beats; i++) {
      beatPositions[i] = beatAccumulation;
      beatAccumulation += beatLength;
    }

    // check which step is closest to beat
    for (int j=0; j<beats; j++) {
      float closestDistance = 1;
      for (int i=0; i<steps; i++) {
        float distance = abs(beatPositions[j]-stepPosition[i]);
        if (distance < closestDistance) {
          closestStep[j] = i;
          closestDistance = distance;
        }
      }
    }

    for (int i = 0; i<steps; i++) {
      stepVel[i] = 0;
    }

    for (int i = 0; i<beats; i++) {
      stepVel[closestStep[i]] = 127;
    }
  }
}
