
void keyPressed() {
  int theKey = int(key);

  if (key == 'q') {
    currentKnob = TUNING;
  }
  if (key == 'w') {
    currentKnob = CUTOFF;
  }
  if (key == 'e') {
    currentKnob = RESONANCE;
  }
  if (key == 'r') {
    currentKnob = ENVMOD;
  }
  if (key == 't') {
    currentKnob = DECAY;
  }
  if (key == 'y') {
    currentKnob = ACCENT;
  }

  if (keyCode == UP) {
    knobValue[currentKnob] ++;
    knobValue[currentKnob] = constrain(knobValue[currentKnob],0,180);
    println(currentKnob+" knob value: "+knobValue[currentKnob]);
    turnKnob(currentKnob, knobValue[currentKnob]);
    println("hello?");
  }
  if (keyCode == DOWN) {
    knobValue[currentKnob] --;
    knobValue[currentKnob] = constrain(knobValue[currentKnob],0,180);
    println(currentKnob+" knob value: "+knobValue[currentKnob]);
    turnKnob(currentKnob, knobValue[currentKnob]);
  }

  if (keyCode == RIGHT) {
    knobValue[currentKnob] = knobValue[currentKnob] + 5;
    knobValue[currentKnob] = constrain(knobValue[currentKnob],0,180);
    println(currentKnob+" knob value: "+knobValue[currentKnob]);
    turnKnob(currentKnob, knobValue[currentKnob]);
    println("hello?");
  }
  if (keyCode == LEFT) {
    knobValue[currentKnob] = knobValue[currentKnob] - 5;
    knobValue[currentKnob] = constrain(knobValue[currentKnob],0,180);
    println(currentKnob+" knob value: "+knobValue[currentKnob]);
    turnKnob(currentKnob, knobValue[currentKnob]);
  }

  if (theKey == 'd') {
    println("attach / detach");
    attachDetach();
  }
  if (key == ' ') {
    pause = !pause;
  }
  if (key == 'I') {
    // new colors for the interface!
    colorMode(HSB, 255);
    cp5.setColorBackground(color(random(255), 255, 30));
    cp5.setColorForeground(color(random(255), 255, 150));
    colorMode(RGB);
  }

  if (key == '1') {
    robotPush(pattern[0],10);
  }
  if (key == '2') {
    robotPush(pattern[1],10);
  }
  if (key == '3') {
    robotPush(pattern[2],10);
  }
  if (key == '4') {
    robotPush(pattern[3],10);
  }
  if (key == '5') {
    robotPush(pattern[4],10);
  }
  if (key == '6') {
    robotPush(pattern[5],10);
  }
  if (key == '7') {
    robotPush(pattern[6],10);
  }
  if (key == '8') {
    robotPush(pattern[7],10);
  }
  if (key == 'a') {
    robotPush(A,10);
  }
  if (key == 'b') {
    robotPush(B,10);
  }
  if (key == 'x') {
    robotPush(RUN,10);
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
    k.setInt("zone", _k.zone);
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


void calibrate1() {
  robotMoveTo(pattern[0]);
}
void calibrate2() {
  robotMoveTo(B);
}

  
