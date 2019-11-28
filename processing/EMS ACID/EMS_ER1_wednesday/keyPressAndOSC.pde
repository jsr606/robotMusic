
void keyPressed() {
  int theKey = int(key);
  //println("the key: "+theKey);
  /*
  if (theKey == 8706) {
   // mac OS, ALT + d
   attachDetach();
   }
   */
  if (theKey == 'D') {
    println("attach / detach");
    attachDetach();
  }
  
  if (key == ' ') {
    pause = !pause;
    if (pause) {
      //robotPush(STOP, 10);
    }
    if (!pause) {
      //robotPush(START, 10);
    }
  }
  if (key == 'I') {
    // new colors for the interface!
    colorMode(HSB, 255);
    cp5.setColorBackground(color(random(255), 255, 30));
    cp5.setColorForeground(color(random(255), 255, 150));
    colorMode(RGB);
  }
  if (key == 'R') {
    if (robotMode == RANDOMEDIT) {
      robotMode = CHILL;
    } else if (robotMode != RANDOMEDIT) {
      robotMode = RANDOMEDIT;
    }
  }
  if (key == 'p') {
    if (robotMode == PATTERNPLAY) {
      robotMode = CHILL;
    } else if (robotMode != PATTERNPLAY) {
      robotMode = PATTERNPLAY;
    }
  }

  if (key =='o') {
    // send OSC
    OscMessage myMessage = new OscMessage("/ER1/step/1/1");

    myMessage.add(1.0); /* add an int to the osc message */

    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
    println("sending osc");
  }

  if (key == '1') {
    robotPush(trigger[0],10);
  }
  if (key == '2') {
    robotPush(trigger[1],10);
  }
  if (key == '3') {
    robotPush(trigger[2],10);
  }
  if (key == '4') {
    robotPush(trigger[3],10);
  }
  if (key == '5') {
    robotPush(trigger[4],10);
  }
  if (key == '6') {
    robotPush(trigger[5],10);
  }
  if (key == '7') {
    robotPush(trigger[6],10);
  }
  if (key == '8') {
    robotPush(trigger[7],10);
  }
  if (key == 'q') {
    robotPush(trigger[8],10);
  }
  if (key == 'w') {
    robotPush(trigger[9],10);
  }
  if (key == 'e') {
    robotPush(trigger[10],10);
  }
  if (key == 'r') {
    robotPush(trigger[11],10);
  }
  if (key == 't') {
    robotPush(trigger[12],10);
  }
  if (key == 'y') {
    robotPush(trigger[13],10);
  }
  if (key == 'u') {
    robotPush(trigger[14],10);
  }
  if (key == 'i') {
    robotPush(trigger[15],10);
  }
  if (key == 'a') {
    robotPush(PERC1,10);
  }
  if (key == 's') {
    robotPush(PERC2,10);
  }
  if (key == 'd') {
    robotPush(PERC3,10);
  }
  if (key == 'f') {
    robotPush(PERC4,10);
  }
  if (key == 'g') {
    robotPush(HIHATCLOSE,10);
  }
  if (key == 'h') {
    robotPush(HIHATOPEN,10);
  }
  if (key == 'j') {
    robotPush(CRASH,10);
  }
  if (key == 'k') {
    robotPush(HCLAP,10);
  }
  
  

  if (key == 'l') {
    chooseLastStep(int(random(16)));
  }
  if (key == 'x') {
    //robotPush(NATIVECLEAR, int(random(200, 5000)));
  }

  if (key == 'c') {
    // kindly ask for robot coordinates
    feedbackMessages.add("asking for coordinates");
    sendData("P2220\n");
  }
  if (key == 'C') {
    // print coordinates to terminal, as comma seperated list
    if (calibrationKey == -1) {
      println("welcome to key calibration mode");
      calibrationKey = 0;
    }
    Key _k = keys[calibrationKey];
    JSONObject k = new JSONObject();
    k.setInt("id", calibrationKey);
    k.setFloat("x", robotCoords[0]); 
    k.setFloat("y", robotCoords[1]); 
    k.setFloat("z", robotCoords[2]);
    k.setString("name", _k.keyName);
    //k.setInt("zone", 3);
    k.setFloat("push", 11);
    println("saved key "+_k.keyName); 

    newKeyData.append(k);
    println("added "+_k.keyName);
    saveJSONArray(newKeyData, "data/newKeyData.json");
    calibrationKey++;
    if (calibrationKey == amountOfKeys) {
      println("calibration done, thanks");
      calibrationKey = -1;
    }
  }
}

void oscEvent(OscMessage theOscMessage) 
{


  print("## OSC incoming:");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  /*
  if (theOscMessage.addrPattern().equals("/mixer/mix")) {
   mix = theOscMessage.get(0).floatValue();
   }
  /*
   if (theOscMessage.addrPattern().equals("/setup/debugToggle")) {
   if (theOscMessage.get(0).floatValue() == 0) {
   debugLamps = false;
   } else {
   debugLamps = true;
   }
   }
   */

  String adressPattern = theOscMessage.addrPattern();
  if (adressPattern.contains("/ER1/step/1/")) {
    int t = 0;
    if (adressPattern.contains("1/1")) t = 0;
    if (adressPattern.contains("1/2")) t = 1;
    if (adressPattern.contains("1/3")) t = 2;
    if (adressPattern.contains("1/4")) t = 3;
    if (adressPattern.contains("1/5")) t = 4;
    if (adressPattern.contains("1/6")) t = 5;
    if (adressPattern.contains("1/7")) t = 6;
    if (adressPattern.contains("1/8")) t = 7;
    if (adressPattern.contains("1/9")) t = 8;
    if (adressPattern.contains("1/10")) t = 9;
    if (adressPattern.contains("1/11")) t = 10;
    if (adressPattern.contains("1/12")) t = 11;
    if (adressPattern.contains("1/13")) t = 12;
    if (adressPattern.contains("1/14")) t = 13;
    if (adressPattern.contains("1/15")) t = 14;
    if (adressPattern.contains("1/16")) t = 15;
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(trigger[t], 10);
    }
    println("trigger "+t);
  }
  if (adressPattern.contains("/ER1/REC")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(REC, 10);
    }
  }
  if (adressPattern.contains("/ER1/PLAY")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(PLAY, 10);
    }
  }
  if (adressPattern.contains("/ER1/STOP")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(STOP, 10);
    }
  }
  if (adressPattern.contains("/ER1/TAP")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(TAP, 10);
    }
  }
  if (adressPattern.contains("/ER1/PERC1")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(PERC1, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/PERC2")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(PERC2, 10);
      activeTrigger = 1;
    }
  }
  if (adressPattern.contains("/ER1/PERC3")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(PERC3, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/PERC4")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(PERC4, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/AUDIO1")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(AUDIOIN1, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/AUDIO2")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(AUDIOIN2, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/HI-HATCLOSE")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(HIHATCLOSE, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/HI-HATOPEN")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(HIHATOPEN, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/ACCENT")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(ACCENT, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/RINGMOD1")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(RINGMOD1, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/RINGMOD2")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(RINGMOD2, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/CRASH")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(CRASH, 10);
      activeTrigger = 0;
    }
  }
  if (adressPattern.contains("/ER1/HCLAP")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(HCLAP, 10);
      activeTrigger = 0;
    }
  }

  if (adressPattern.contains("/ER1/HCLAP")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(HCLAP, 10);
      activeTrigger = 0;
    }
  }

  if (adressPattern.contains("/ER1/shift")) {
    float f = theOscMessage.get(0).floatValue();
    println("shift "+f);

    OscMessage myMessage = new OscMessage("/ER1/shift");
    myMessage.add(float(int(f)));
    oscP5.send(myMessage, myRemoteLocation);
  }
  if (adressPattern.contains("/ER1/voice")) {
    int t = 0;
    if (adressPattern.contains("/13/1")) t = 0;
    if (adressPattern.contains("/12/1")) t = 1;
    if (adressPattern.contains("/11/1")) t = 2;
    if (adressPattern.contains("/10/1")) t = 3;
    if (adressPattern.contains("9/1")) t = 4;
    if (adressPattern.contains("8/1")) t = 5;
    if (adressPattern.contains("7/1")) t = 6;
    if (adressPattern.contains("6/1")) t = 7;
    if (adressPattern.contains("5/1")) t = 8;
    if (adressPattern.contains("/4/1")) t = 9;
    if (adressPattern.contains("/3/1")) t = 10;
    if (adressPattern.contains("/2/1")) t = 11;
    if (adressPattern.contains("/1/1")) t = 12;

    println("current trigger "+t);
    currentTrigger = t;

    cp5.getController("voice").setValue(t);
  }
  if (adressPattern.contains("/ER1/beats")) {

    float b = theOscMessage.get(0).floatValue();
    println("beats "+b);
    beats(int(b));
    cp5.getController("beats").setValue(int(b));
  }

  if (adressPattern.contains("/ER1/shift")) {

    float s = theOscMessage.get(0).floatValue();
    println("shift "+s);
    shift(int(s));
    cp5.getController("shift").setValue(int(s));
  }
  if (adressPattern.contains("/ER1/upload")) {

    if (theOscMessage.get(0).floatValue() == 1) {
      upload();
    }
  }

  incomingOSC = true;
}

void controlEvent(ControlEvent theEvent) {


  if (theEvent.isController()) { 
    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());
  }
  
  if (theEvent.getController().getName().equals("zHeight")) {
    zHeight = theEvent.getController().getValue();
    println(zHeight);
    robotCommands.add("#1 G0 X185 Y0 Z"+int(zHeight)+" F"+speed+"\n");
  }
}
  
