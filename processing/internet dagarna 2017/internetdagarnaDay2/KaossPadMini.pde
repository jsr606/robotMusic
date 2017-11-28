BufferedReader coords;

float kaossPush = 0.5;

class KaossPadMini {
  public float x, y;
  public PVector upperLeft, upperRight, lowerLeft, lowerRight;
  public PVector tapButton, presetAButton, presetBButton, holdButton;
  public int preset;
  public boolean hold;
  public KaossPadMini () {
    hold = false;
    preset = 0;
    x = 0;
    y = 0;
    coords = createReader("data/kaossPadMiniCoords.txt");  
    getCoords();
  }

  public void setEffects(float effectX, float effectY) {

    if (activeInstrument != KAOSSPAD) {
      home();
      activeInstrument = KAOSSPAD;
    }
    
    waitForRobot();

    effectX = constrain(effectX, 0, 1);
    effectY = constrain(effectY, 0, 1);
    float _x = map(effectY, 0, 1, lowerLeft.x, upperLeft.x); 
    float _y = map(effectX, 0, 1, lowerLeft.y, lowerRight.y);

    // move somewhere safe above kaosspad
    String data = "#1 G0 X"+_x+" Y"+_y+" Z"+(upperLeft.z+20)+" F"+int(speed)+"\n"; 
    sendData (0, data);
    data = "#1 G0 X"+_x+" Y"+_y+" Z"+(upperLeft.z-kaossPush)+" F"+int(speed)+"\n"; 
    sendData (0, data); 
    data = "#1 G0 X"+_x+" Y"+_y+" Z"+(upperLeft.z+20)+" F"+int(speed)+"\n"; 
    sendData (0, data);
    
    waitForRobot();
  }

  public void playWithEffects(int times, int delayTime) {

    waitForRobot();

    if (activeInstrument != KAOSSPAD) {
      home();
      activeInstrument = KAOSSPAD;
    }

    String data = "#1 G0 X"+upperLeft.x+" Y"+upperLeft.y+" Z"+(upperLeft.z+20)+" F"+int(speed)+"\n"; 
    sendData (0, data);  
    waitForRobot(); 

    for (int i = 0; i<times; i++) {
      float ranX = random(0.1, 0.9);
      float ranY = random(0.1, 0.9);
      float _x = map(ranX, 0, 1, lowerLeft.x, upperLeft.x); 
      float _y = map(ranY, 0, 1, lowerLeft.y, lowerRight.y);

      //_x = constrain(_x, upperLeft.x, upperRight.x);
      //_y = constrain(_y, lowerLeft.y, upperLeft.y);
      data = "#1 G0 X"+_x+" Y"+_y+" Z"+(upperLeft.z+1)+" F"+int(speed)+"\n"; 
      sendData (0, data);
      delay(delayTime);
      waitForRobot();
    }

    data = "#1 G0 X"+upperLeft.x+" Y"+upperLeft.y+" Z"+(upperLeft.z+20)+" F"+int(speed)+"\n"; 
    sendData (0, data);
    
    waitForRobot();
  }

  public void tapTempo(int bpm, int taps) {

    if (activeInstrument != KAOSSPAD) {
      home();
      activeInstrument = KAOSSPAD;
    }
    waitForRobot();  

    String data = "#1 G0 X"+tapButton.x+" Y"+tapButton.y+" Z"+(tapButton.z+20)+" F"+int(speed)+"\n";
    sendData (0, data);
    delay(2000);
    for (int i = 0; i<taps; i++) {
      data = "#1 G0 X"+tapButton.x+" Y"+tapButton.y+" Z"+(tapButton.z+5)+" F"+int(speed)+"\n";
      sendData (0, data);
      delay(60000/bpm-pushDelay);
      data = "#1 G0 X"+tapButton.x+" Y"+tapButton.y+" Z"+(tapButton.z-kaossPush)+" F"+int(speed)+"\n";
      sendData (0, data);
    }
    data = "#1 G0 X"+tapButton.x+" Y"+tapButton.y+" Z"+(tapButton.z+20)+" F"+int(speed)+"\n";
    sendData (0, data);
  }

  public void holdOn(boolean isOn) {

    if (activeInstrument != KAOSSPAD) {
      home();
      activeInstrument = KAOSSPAD;
    }
    waitForRobot(); 

    if (isOn != hold) {
      String data = "#1 G0 X"+(holdButton.x-5)+" Y"+holdButton.y+" Z"+(holdButton.z+40)+" F"+int(speed)+"\n";
      sendData (0, data);
      waitForRobot();
      data = "#1 G0 X"+(holdButton.x-5)+" Y"+holdButton.y+" Z"+(holdButton.z)+" F"+int(speed)+"\n";
      sendData (0, data);
      waitForRobot();
      delay(200);
      data = "#1 G0 X"+(holdButton.x+holdPush)+" Y"+holdButton.y+" Z"+(holdButton.z)+" F"+int(speed)+"\n";
      sendData (0, data);
      data = "#1 G0 X"+(holdButton.x-5)+" Y"+holdButton.y+" Z"+(holdButton.z)+" F"+int(speed)+"\n";
      sendData (0, data);
      waitForRobot();
      delay(500);
      data = "#1 G0 X"+(holdButton.x-5)+" Y"+holdButton.y+" Z"+(holdButton.z+30)+" F"+int(speed)+"\n";
      sendData (0, data);
      hold = isOn;
      delay(500);
    }
  }

  public void setPreset(int thePreset) {

    if (activeInstrument != KAOSSPAD) {
      home();
      activeInstrument = KAOSSPAD;
    }
    while (robotMoving) checkForMovement(); 

    if (thePreset == 0) {
      String data = "#1 G0 X"+presetAButton.x+" Y"+presetAButton.y+" Z"+(presetAButton.z+20)+" F"+int(speed)+"\n";
      sendData (0, data);
      data = "#1 G0 X"+presetAButton.x+" Y"+presetAButton.y+" Z"+(presetAButton.z)+" F"+int(speed)+"\n";
      sendData (0, data);
      data = "#1 G0 X"+presetAButton.x+" Y"+presetAButton.y+" Z"+(presetAButton.z+20)+" F"+int(speed)+"\n";
      sendData (0, data);
      preset = 0;
      delay(1500);
      hold = false;
      holdOn(true);
    }
    if (thePreset == 1) {
      String data = "#1 G0 X"+presetBButton.x+" Y"+presetBButton.y+" Z"+(presetBButton.z+20)+" F"+int(speed)+"\n";
      sendData (0, data);
      data = "#1 G0 X"+presetBButton.x+" Y"+presetBButton.y+" Z"+(presetBButton.z)+" F"+int(speed)+"\n";
      sendData (0, data);
      data = "#1 G0 X"+presetBButton.x+" Y"+presetBButton.y+" Z"+(presetBButton.z+20)+" F"+int(speed)+"\n";
      sendData (0, data);
      preset = 1;
      delay(1500);
      hold = false;
      holdOn(true);
    }
  }

  public void getCoords() {
    String line;
    try {
      line = coords.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    String[] linePieces = split(line, ',');

    upperLeft = new PVector(float(linePieces[0]), float(linePieces[1]), float(linePieces[2]));
    upperRight = new PVector(float(linePieces[3]), float(linePieces[4]), float(linePieces[5]));
    lowerLeft = new PVector(float(linePieces[6]), float(linePieces[7]), float(linePieces[8]));
    lowerRight = new PVector(float(linePieces[9]), float(linePieces[10]), float(linePieces[11]));

    tapButton = new PVector(float(linePieces[12]), float(linePieces[13]), float(linePieces[14]));        
    presetAButton = new PVector(float(linePieces[15]), float(linePieces[16]), float(linePieces[17]));        
    presetBButton = new PVector(float(linePieces[18]), float(linePieces[19]), float(linePieces[20]));        
    holdButton = new PVector(float(linePieces[21]), float(linePieces[22]), float(linePieces[23]));

    println("kaoss pad created");
  }
}