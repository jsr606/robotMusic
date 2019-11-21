// euclidian rythm

class Rythm {
  public int steps, beats;
  public int maxSteps = 16;
  public int[] stepVel;
  float[] beatPositions;
  float[] stepPosition;
  int[] closestStep;
  public String name;
  float mutation = 0;
  int shift = 0;
  int currentStep = 0;
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
    //int j = (i+shift+steps)%steps;
    currentStep = (currentStep + 1) % steps;
  }

  public String getStepsAsString() {
    String returnString = "";
    for (int i=0; i<steps; i++) {
      if (stepVel[i] == 0) {
        returnString += "0";
      } else {
        returnString += "1";
      }
    }
    return returnString;
  }

  public void drawMinimalSequence(float theXPos, float theYPos, float boxSize, color strokeColor) {
    pushMatrix();
    translate(theXPos, theYPos);
    pushMatrix();
    for (int i = 0; i<steps; i++) {
      // compensate for possible array shifting
      int k = (i+steps)%steps;
      int j = (i+shift+steps)%steps;
      fill (stepVel[j]);
      if (k == currentStep) {
        stroke(activeColor);
        strokeWeight(2);
      } else {
        stroke(inActiveColor);
        strokeWeight(1);
      }
      rect(0, 0, boxSize, boxSize);
      translate(boxSize+1, 0);
    }
    popMatrix();
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
    ellipse(0,0,boxSize-4, boxSize-4);

    popMatrix();
  } 


  public void drawSequence(float theXPos, float theYPos, float theWidth) {
    float stepLength = theWidth/float(steps);
    float beatLength = theWidth/float(beats);

    pushMatrix();
    translate(theXPos, theYPos);
    fill(255, 0, 0);
    stroke(200);
    for (int i = 0; i<steps; i++) {
      strokeWeight(1);
      line(0, 0, stepLength, 0);
      if (stepVel[i] > 0) {
        fill(255, 0, 0);
        ellipse(0, 0, 6, 6);
      } else {
        fill(0);
        ellipse(0, 0, 4, 4);
      }

      translate(stepLength, 0);
    }
    popMatrix();
    pushMatrix();
    translate(10, theYPos);
    for (int i = 0; i<steps; i++) {
      float x = beatPositions[i]*theWidth;
      stroke(100);
      line(x, -2, x, 2);
      stroke(255);
    }
    popMatrix();
  }

  public void updateRythm() {
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
