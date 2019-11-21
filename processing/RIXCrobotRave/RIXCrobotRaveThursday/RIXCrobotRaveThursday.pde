import processing.serial.*;
import controlP5.*;
import de.hfkbremen.klang.*;

import oscP5.*;
import netP5.*;

Serial robotSerial; 
String robotArm = "/dev/tty.usbmodem1421";
String incomingChars;

//variables needed for osc
OscP5 oscP5;
NetAddress myRemoteLocation;

//set/change port numbers here
int incomingPort = 3000;
int outgoingPort = 9000;
String ipTouchOSC = "172.16.42.6";

boolean incomingOSC = false;

ControlP5 cp5;
Drummachine machineDrums;
Synthesizer mSynth;

float [] robotCoords = new float [3];
int lastMove = millis(), moveFreq = 500;
boolean armMightBeMoving = false;
String incomingSerial = "";
PFont mono;

int serialFrequency = 100, lastSerial = millis();
boolean attached = true;
String lastCommand;
String feedbackString = "", incomingCoordinates = "", incomingMessage = "", lastIncomingMessage = "";
boolean debug = true;
boolean robotMoving = false;
boolean pause = false;

ArrayList feedbackMessages, robotCommands;
int keyBeforeThat;
int amountOfFeedbackMessages = 80;

// sequencer keys
JSONArray keyData;
JSONArray newKeyData;
int currentKey = 0, futureKey = 0;
int amountOfKeys = 30;
Key [] keys = new Key [amountOfKeys];

float xOffset = -2.39, yOffset = -0.4, zOffset = 9.6, speed = 57;
int calibrationKey = -1;

static final int SETUP = -1, ROBOTRUNNING = 1;
static final int CHILL = 0, RANDOMEDIT = 2, PATTERNPLAY = 3, MUTEPLAY = 4;
int state = SETUP, robotMode = -1;

float hyper = 2, density = 0.2;

static final int JUSTMOVING = 1, PUSHING = 2, TRIGGERSHIFTING = 3;
int mode = JUSTMOVING;
int pushTime, pushStart;

int currentTrigger;

boolean robotIdle = true;

int tick = 0, lastSecond = second();

static final int START = 0, STOP = 1, RECORD = 2, MUTE = 19, LASTSTEP = 20, DIRECTION = 21, TRIGGERSELECT = 22, CLEAR = 23, F6 = 24, F7 = 25, NATIVEMUTE = 26, NATIVEDIRECTION = 27, NATIVECLEAR = 28, NATIVEPATTERN = 29;
static final int trigger [] = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18};
int lastStep [] = {15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15};

boolean drumSeqMute [] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};
boolean drumSeqArmed [] = {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true};

void setup() {
  size(1000, 758);
  printArray(Serial.list());
  robotSerial = new Serial(this, robotArm, 115200);
  mono = loadFont("PTMono-Regular-12.vlw");
  textFont(mono, 12);

  SynthUtil.dumpMidiOutputDevices();
  machineDrums = new Drummachine(width-300, 120);
  mSynth = Synthesizer.getSynth("midi", "IAC Bus 1");

  feedbackMessages = new ArrayList();
  robotCommands = new ArrayList();

  // robot controls
  cp5 = new ControlP5(this);
  cp5.addSlider("speed").setRange(0, 200).setPosition(10, 10).setWidth(360);
  cp5.addSlider("xOffset").setRange(-50, 50).setPosition(10, 20).setWidth(360);
  cp5.addSlider("yOffset").setRange(-50, 50).setPosition(10, 30).setWidth(360);
  cp5.addSlider("zOffset").setRange(-50, 50).setPosition(10, 40).setWidth(360);
  cp5.addSlider("hyper").setRange(0, 11).setPosition(420, 10).setWidth(360);
  cp5.addSlider("density").setRange(0, 1).setPosition(420, 20).setWidth(360);
  //cp5.addSlider("push").setRange(0, 25).setPosition(10, 60).setWidth(250).setValue(push);

  // drum machine controls
  float knobY = machineDrums.posY+280;
  float xStart = machineDrums.posX-10, spread = 50;
  cp5.addKnob("beats").setRange(0, maxBeats).setPosition(xStart, knobY).setValue(1).setResolution(maxBeats);
  cp5.addKnob("shift").setRange(-maxBeats, maxBeats).setPosition(xStart+spread, knobY).setValue(0).setResolution(maxBeats*2);
  cp5.addKnob("beatLength").setRange(1, maxBeats).setPosition(xStart+spread*2, knobY).setValue(16).setResolution(maxBeats);
  cp5.addKnob("voice").setRange(0, 9).setPosition(xStart+spread*3, knobY).setValue(0).setResolution(maxVoices);
  cp5.addButton("upload").setSize(70, 18).setPosition(xStart+spread*4+5, knobY);
  cp5.addToggle("midi").setSize(70, 15).setPosition(xStart+spread*4+5, knobY+20);
  cp5.addButton("randomize").setSize(70, 15).setPosition(xStart+spread*4+5, knobY+40);

  // stylish
  cp5.setColorActive(color(225));
  colorMode(HSB, 255);
  //float h = random(255);
  cp5.setColorBackground(color(random(255), 255, 30));
  cp5.setColorForeground(color(random(255), 255, 150));
  colorMode(RGB);

  keyData = loadJSONArray("keyData.json");
  newKeyData = new JSONArray();
  createKeys();
  checkKeys();

  // start oscP5, listening for incoming messages at port #####
  // for INCOMING osc messages (e.g. from Max/MSP)
  oscP5 = new OscP5(this, incomingPort); //port number set above
  //for OUTGOING osc messages (to another device/application)
  myRemoteLocation = new NetAddress(ipTouchOSC, outgoingPort); //ip address set above
  println("outgoing OSC for DMX data is: "+ipTouchOSC+" port: "+outgoingPort);
}

void draw() {
  background(0);
  fill(255);

  textFeedback(0, 100);
  machineDrums.update();

  switch(state) {
  case SETUP:
    if (tick > 5) {
      sendData("M2122 V1\n"); // sends feedback when robot stops / has reached destination
      delay(100);
      sendData("M2210 F500 T20\n"); // beep
      sendData("M2210 F700 T20\n"); // beep
      sendData("M2210 F800 T20\n"); // beep
      delay(100);
      home();
      //delay(500);
      state = ROBOTRUNNING;
    }
    break;

  case ROBOTRUNNING:
    if (robotIdle && !pause) {
      if (robotCommands.size() > 0) {
        sendNextRobotCommand();
      }
      if (robotCommands.size() == 0 && robotMode == RANDOMEDIT) {
        int t = int(random(lastStep[currentTrigger]+1));
        robotPush(trigger[t], 10);
        robotPause(hyperPause(0, 10000));
      }
      if (robotCommands.size() == 0 && robotMode == MUTEPLAY) {
        int t = int(random(15)); // NOT trigger 16 (clock out)
        robotPush(trigger[t], 10);
        robotPause(hyperPause(0, 10000));
      }
      if (robotCommands.size() == 0 && robotMode == PATTERNPLAY) {
        int t = int(random(16));
        robotPush(NATIVEPATTERN, 10);
        println("pushing trigger "+t);
        robotPush(trigger[t], 10);
        robotPush(NATIVEPATTERN, 10);
        robotPause(hyperPause(0, 30000));
      }
    }
    break;
  }
  tick();
}

int hyperPause(int min, int max) {
  float amountOfRandom = 0.3;
  float randomizer = random(1-amountOfRandom, 1+amountOfRandom);
  float hyperRandom = constrain(hyper*randomizer, 0, 11);
  int pause = int(map(hyperRandom, 0, 11, max, min + 10));
  return pause;
}

void sendNextRobotCommand() {
  String data = (String) robotCommands.get(0);
  robotSerial.write(data);
  feedbackMessages.add("TX: "+data);
  robotIdle = false;
}

void robotMoveTo(int theFutureKey) {
  if (keys[theFutureKey].zone != keys[keyBeforeThat].zone) {
    robotCommands.add(homeCoords()); // new key zone, add homing
  }
  robotCommands.add(keyCoords(theFutureKey));
  keyBeforeThat = theFutureKey;
}

void chooseLastStep(int theStep) {
  robotPush(LASTSTEP, 10);
  robotPush(trigger[theStep-1], 10);
  robotPause(2000);
  lastStep[currentTrigger] = theStep;
  println("new last step "+theStep);
}

void robotPause(int theDelay) {
  robotCommands.add(wait(theDelay));
}
void chooseTrigger(int theTrigger) {
  robotPush(TRIGGERSELECT, 10);
  robotPush(trigger[theTrigger], 10);
  robotPause(2000);
  currentTrigger = theTrigger;
}

void robotPush(int theFutureKey, int theTime) {
  if (keys[theFutureKey].zone != keys[keyBeforeThat].zone) {
    robotCommands.add(homeCoords()); // new key zone, add homing
    feedbackMessages.add("homing");
  }
  robotCommands.add(keyCoords(theFutureKey));
  robotCommands.add(pushCoords(theFutureKey));
  robotCommands.add(wait(theTime));
  robotCommands.add(keyCoords(theFutureKey));
  keyBeforeThat = theFutureKey;
  feedbackMessages.add("pushing "+theFutureKey);
}

String wait(int waitTime) {
  waitTime = max(waitTime, 0);
  String data = "#1 G2004 P"+waitTime+"\n";
  return data;
}

String homeCoords() {
  String data = "#1 G0 X172 Y150 Z140 F"+int(speed)+"\n";
  return data;
}

String keyCoords(int theKey) {
  String data = "#1 G0 X"+(keys[theKey].x+xOffset)+" Y"+(keys[theKey].y+yOffset)+" Z"+(keys[theKey].z+zOffset)+" F"+int(speed)+"\n"; 
  return data;
}

String pushCoords(int theKey) {
  String data = "#1 G0 X"+(keys[theKey].x+xOffset)+" Y"+(keys[theKey].y+yOffset)+" Z"+(keys[theKey].z+zOffset-keys[theKey].push)+" F"+int(speed)+"\n"; 
  return data;
}

void textFeedback(int x, int y) {
  pushMatrix();
  translate(x, y); 
  Key cK = keys[currentKey];
  text(robotCoords[0]+","+robotCoords[1]+","+robotCoords[2], 10, 15);
  for (int i = 0; i<feedbackMessages.size(); i++) {
    String msg = (String) feedbackMessages.get(feedbackMessages.size()-1-i);
    text(msg, 10, 30+10*i);
  }
  popMatrix();
  pushMatrix();
  translate(355, y+30);
  for (int i = 0; i<robotCommands.size(); i++) {
    String msg = (String) robotCommands.get(i);
    text(msg, 0, 10*i);
  }

  popMatrix();
  pushMatrix();
  translate(875, 20);
  if (state == SETUP) text("INITIALIZING", 0, 0);
  if (state == ROBOTRUNNING) text("ROBOT RUNNING", 0, 0);
  if (robotMode == RANDOMEDIT) text("random edit", 0, 10);
  popMatrix();
}

void attachDetach() {
  // detach / attach servo motors
  attached = !attached; 
  if (attached) {
    println("attaching servos"); 
    sendData ("M17\n");
  } else {
    println("detaching servos"); 
    sendData ("M2019\n");
  }
}

void sendData (String theData) {
  feedbackMessages.add("TX: "+theData);
  while (serialFrequency + lastSerial > millis()) {
    //println("wait for it");
    fill(255, 0, 0); 
    rect(width-50, height-50, 10, 10);
  }

  robotSerial.write(theData);
  if (theData.contains("G0")) robotMoving = true;
  lastCommand = theData;
  lastSerial = millis(); 
  delay(200);
}

void serialEvent(Serial myPort) {
  char incomingChar;
  try {
    incomingChar = myPort.readChar();
    incomingMessage += incomingChar;

    if (incomingChar == 10 || incomingChar == 13) {
      parseIncomingSerial();
    }
  } 
  catch(RuntimeException e) {
    println("argh, runtime exception");
    //e.printStackTrace();
  }
}

void parseIncomingSerial() {
  if (incomingMessage.contains("X") && incomingMessage.contains("Y") && incomingMessage.contains("Z")) {
    //println("this is coordinates");
    incomingCoordinates = incomingMessage;
    parseIncomingCoordinates();
  } else if (incomingMessage.contains("@9 V0")) {
    currentKey = futureKey;
    sendData("P2220\n"); // ask for current coordinates
    //println("arrived at destination");
    armMightBeMoving = false;
  } else if (incomingMessage.contains("$1 E")) {
    println("problems with move command"+incomingMessage);
  } else if (incomingMessage.contains("$1 ok")) {
    // move on
    robotCommands.remove(0);
    robotIdle = true;
  }
  feedbackMessages.add("RX: "+incomingMessage);
  while (feedbackMessages.size() > amountOfFeedbackMessages) feedbackMessages.remove(0);
  incomingMessage = "";
}

void parseIncomingCoordinates() {
  String[] coords = split(incomingCoordinates, " "); 
  for (int i = 1; i<coords.length; i++) {
    robotCoords[i-1] = float(coords[i].substring(1));
  }
}

void home() {
  delay(300);
  sendData ("#1 G0 X172 Y150 Z140 F200\n");
  feedbackMessages.add("--- homed");
  delay(650);
}

void shift(int theShift) {
  //println("shift: "+theShift);
  machineDrums.shiftRythm(activeTrigger, 16-theShift);
}

void voice(int theVoice) {
  //println("voice: "+theVoice);
  activeTrigger = theVoice;
}

void beats(int theBeats) {
  //println("beats: "+theBeats);
  machineDrums.updateRythm(activeTrigger, theBeats);
}

void beatLength(int theBeatLength) {
  //println("beat length");
  machineDrums.updateBeatLength(activeTrigger, theBeatLength);
}

void tick() {
  if (lastSecond != second()) {
    tick++;
    lastSecond = second();
  }
}

void randomize() {
  println("randomize drummachine");
  machineDrums.randomizeMuted(int(random(3, 6)));
  machineDrums.doRandom(density);
}

void mute(int theRythm) {
  robotPush(MUTE, 10);
  robotPush(trigger[theRythm], 10);
  robotPause(3000);
  robotPush(MUTE, 10);
  drumSeqMute[theRythm] = !drumSeqMute[theRythm];
}

void upload() {
  println("ok lets put this on the drummachine");

  // muting / unmuting here
  robotPush(MUTE, 10);
  for (int i = 0; i< machineDrums.rythms.size(); i++) {
    Rythm r = (Rythm) machineDrums.rythms.get(i);
    if (r.muted != drumSeqMute[i]) {
      robotPush(trigger[i], 10);
      drumSeqMute[i] = !drumSeqMute[i];

      println("muted / unmuted ");
    }
  }  
  robotPush(MUTE, 10);

  for (int i = 0; i< machineDrums.rythms.size(); i++) {
    Rythm r = (Rythm) machineDrums.rythms.get(i);

    if (r.muted == false) {
      println("getting nr "+i);
      String _r = machineDrums.getRythm(i);
      println(_r);
      chooseTrigger(i);
      chooseLastStep(_r.length());
      robotPush(CLEAR, 1000);
      robotPause(3000);
      for (int j = 0; j<_r.length(); j++) {
        char c = _r.charAt(j);
        if (c == '1') {
          robotPush(trigger[j], 10);
        }
      }
    }
  }
  println();
}
