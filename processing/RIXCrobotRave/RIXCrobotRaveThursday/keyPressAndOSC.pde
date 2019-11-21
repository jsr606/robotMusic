
void keyPressed() {
  int theKey = int(key);
  if (theKey == 8706) {
    // ALT + d
    attachDetach();
  }
  if (key == ' ') {
    pause = !pause;
    if (pause) {
      robotPush(STOP, 10);
    }
    if (!pause) {
      robotPush(START, 10);
    }
  }
  if (key == 'c') {
    // calibrate lower left key (f7)
    robotMoveTo(25);
  }
  if (key == 'C') {
    // calibrate lower right key (drum pad 16)
    robotMoveTo(18);
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
    //THIS DOESNT WORK
    //OscMessage myMessage = new OscMessage("/robotControl/triggers 1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0");
    OscMessage myMessage = new OscMessage("/robotControl/hyper 0.5");

    //myMessage.add(1.0); /* add an int to the osc message */

    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
    println("sending osc");
  }

  if (key == '1') {
    chooseTrigger(0);
  }
  if (key == '2') {
    chooseTrigger(1);
  }
  if (key == '3') {
    chooseTrigger(2);
  }
  if (key == '4') {
    chooseTrigger(3);
  }
  if (key == '5') {
    chooseTrigger(4);
  }
  if (key == '6') {
    chooseTrigger(5);
  }
  if (key == '7') {
    chooseTrigger(6);
  }
  if (key == '8') {
    chooseTrigger(7);
  }
  if (key == 'q') {
    chooseTrigger(8);
  }
  if (key == 'w') {
    chooseTrigger(9);
  }
  if (key == 'e') {
    chooseTrigger(10);
  }
  if (key == 'r') {
    chooseTrigger(11);
  }
  if (key == 't') {
    chooseTrigger(12);
  }
  if (key == 'y') {
    chooseTrigger(13);
  }
  if (key == 'u') {
    chooseTrigger(14);
  }
  if (key == 'i') {
    chooseTrigger(15);
  }

  if (key == 'l') {
    chooseLastStep(int(random(16)));
  }
  if (key == 'x') {
    robotPush(NATIVECLEAR, int(random(200, 5000)));
  }

  if (key == 'k') {
    // kindly ask for robot coordinates
    feedbackMessages.add("asking for coordinates");
    sendData("P2220\n");
  }
  if (key == 'K') {
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
    k.setInt("zone", 3);
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
  if (adressPattern.contains("/robotControl/triggerSelect/")) {
    int t = 0;
    if (adressPattern.contains("4/1")) t = 0;
    if (adressPattern.contains("4/2")) t = 1;
    if (adressPattern.contains("4/3")) t = 2;
    if (adressPattern.contains("4/4")) t = 3;
    if (adressPattern.contains("3/1")) t = 4;
    if (adressPattern.contains("3/2")) t = 5;
    if (adressPattern.contains("3/3")) t = 6;
    if (adressPattern.contains("3/4")) t = 7;
    if (adressPattern.contains("2/1")) t = 8;
    if (adressPattern.contains("2/2")) t = 9;
    if (adressPattern.contains("2/3")) t = 10;
    if (adressPattern.contains("2/4")) t = 11;
    if (adressPattern.contains("1/1")) t = 12;
    if (adressPattern.contains("1/2")) t = 13;
    if (adressPattern.contains("1/3")) t = 14;
    if (adressPattern.contains("1/4")) t = 15;
    if (theOscMessage.get(0).floatValue() == 1) {
      chooseTrigger(t);
      currentTrigger = t;
    }
    println("trigger "+t);
  }
  if (adressPattern.contains("/robotControl/transport/1/1")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(START, 10);
    }
  }
  if (adressPattern.contains("/robotControl/transport/1/2")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(STOP, 10);
    }
  }
  if (adressPattern.contains("/robotControl/transport/1/3")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(RECORD, 10);
    }
  }

  if (adressPattern.contains("/robotControl/euclidian")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      randomize();
      // a feedback here to tocuh OSC would be super nice
    }
  }
  if (adressPattern.contains("/robotControl/upload")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      upload();
    }
  }
  if (adressPattern.contains("/robotControl/randomEdit")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      if (robotMode == MUTEPLAY) robotPush(MUTE, 10);
      robotMode = RANDOMEDIT;
    }
  }
  if (adressPattern.contains("/robotControl/patternPlay")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      if (robotMode == MUTEPLAY) robotPush(MUTE, 10);
      robotMode = PATTERNPLAY;
    }
  }
  if (adressPattern.contains("/robotControl/mutePlay")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(MUTE, 10);
      robotMode = MUTEPLAY;
    }
  }
  if (adressPattern.contains("/robotControl/pause")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      pause = true;
      println("pause now");
    } else {
      pause = false;
      println("resume play");
    }
  }
  if (adressPattern.contains("/robotControl/chill")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      if (robotMode == MUTEPLAY) robotPush(MUTE, 10);
      robotMode = CHILL;
    }
  }
  if (adressPattern.contains("/robotControl/home")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      home();
    }
  }
  if (adressPattern.contains("/robotControl/muteTrigger")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      mute(currentTrigger);
    }
  }
  if (adressPattern.contains("/robotControl/clear")) {
    if (theOscMessage.get(0).floatValue() == 1) {
      robotPush(CLEAR, 1000);
    }
  }
  if (adressPattern.contains("/robotControl/hyper")) {
    float v = theOscMessage.get(0).floatValue();
    hyper = map(v,0,1,0,11);
    cp5.getController("hyper").setValue(hyper);
  }
  if (adressPattern.contains("/robotControl/density")) {
    density = theOscMessage.get(0).floatValue();
    cp5.getController("density").setValue(density);
  }
  incomingOSC = true;
}
