import processing.serial.*;
import controlP5.*;
import de.hfkbremen.klang.*;

import oscP5.*;
import netP5.*;

Serial robotSerial; 
//String robotArm = "/dev/ttyUSB0";
String robotArm = "/dev/ttyACM3";
String incomingChars;

//variables needed for osc
OscP5 oscP5;
NetAddress myRemoteLocation;

//set/change port numbers here
int incomingPort = 3000;
int outgoingPort = 9000;
String ipTouchOSC = "192.168.203.23";

boolean incomingOSC = false;

ControlP5 cp5;
Bassline bassline;

float [] robotCoords = new float [3];
int lastMove = millis(), moveFreq = 500;
boolean armMightBeMoving = false;
String incomingSerial = "";
PFont mono;

int serialFrequency = 20, lastSerial = millis();
boolean attached = true;
String lastCommand;
String feedbackString = "", incomingCoordinates = "", incomingMessage = "", lastIncomingMessage = "";
boolean debug = true;
boolean robotMoving = false;
boolean pause = false;

ArrayList feedbackMessages, robotCommands;
int lastKey;
int amountOfFeedbackMessages = 80;

// sequencer keys
JSONArray keyData;
JSONArray newKeyData;
int currentKey = 0, futureKey = 0;
int amountOfKeys = 17;
Key [] keys = new Key [amountOfKeys];

float xOffset = 0, yOffset = 0, zOffset = 9.8, speed = 157;
int calibrationKey = -1;

static final int SETUP = -1, ROBOTRUNNING = 1;
static final int CHILL = 0, RANDOMEDIT = 2, PATTERNPLAY = 3, MUTEPLAY = 4;
int state = SETUP, robotMode = -1;


static final int JUSTMOVING = 1, PUSHING = 2, TRIGGERSHIFTING = 3;
int mode = JUSTMOVING;
int pushTime, pushStart;

int currentTrigger;

boolean robotIdle = true;

int tick = 0, lastSecond = second();

static final int TUNING = 0, CUTOFF = 1, RESONANCE = 2, ENVMOD = 3, DECAY = 4, ACCENT = 5;
static final int RUN = 6, A = 15, B = 16;
static final int pattern [] = {7, 8, 9, 10, 11, 12, 13, 14};

float frequencies [] = {220.00, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30};

float zHeight = 50;

PImage smiley;
float rotation = 0, rotationSpeed = 1;

float knobValue [] = {90, 90, 90, 90, 90, 90, 90};

void setup() {
  size(1200, 758);

  printArray(Serial.list());
  robotSerial = new Serial(this, robotArm, 115200);
  mono = loadFont("PTMono-Regular-12.vlw");
  textFont(mono, 12);

  SynthUtil.dumpMidiOutputDevices();
  bassline = new Bassline();
  //mSynth = Synthesizer.getSynth("midi", "IAC Bus 1");

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

  cp5.addSlider("zHeight").setRange(0, 100).setPosition(420, 30).setWidth(360);

  cp5.addButton("calibrate1").setSize(70, 18).setPosition(10, 50);
  cp5.addButton("calibrate2").setSize(70, 18).setPosition(420+360-70, 50);
  cp5.addButton("moveRandom").setSize(70, 18).setPosition(10, 70);




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

  smiley = loadImage("aciiid.png");
}

void draw() {
  background(0);
  fill(255);

  textFeedback(0, 100);
  bassline.update();

  switch(state) {
  case SETUP:
    if (tick > 2) {
      sendData("M2122 V1\n"); // sends feedback when robot stops / has reached destination
      delay(100);
      /*
      // robot sound from internal piezo
       for (int j = 0; j<12; j++) {
       println(frequencies[j]);
       sendData("M2210 F"+frequencies[j]*3+" T50\n"); // beep
       delay(5);
       }
       */
      delay(100);
      home();

      state = ROBOTRUNNING;
    }
    break;

  case ROBOTRUNNING:
    if (robotIdle && !pause) {
      if (robotCommands.size() > 0) {
        sendNextRobotCommand();
      }
    }
    break;
  }

  rotateSmiley();
  drawKnobs();
  tick();
}

void rotateSmiley() {
  pushMatrix();
  translate(width/4, height/2);
  rotation += rotationSpeed*mouseY/300;
  rotate(radians(rotation));
  //imageMode(CENTER);
  image(smiley, 0, 0);
  popMatrix();
}

void sendNextRobotCommand() {
  String data = (String) robotCommands.get(0);
  while (serialFrequency + lastSerial > millis()) {
  }
  robotSerial.write(data);
  feedbackMessages.add("TX: "+data);
  robotIdle = false;
}

void tweakKnob(int theFutureKnob, int times, int amount) {
  if (knobTweaking) {
    if (currentKnob != theFutureKnob) 
      robotCommands.add(hoverCoords(theFutureKnob)); 
    robotCommands.add(pushCoords(theFutureKnob));
    for (int i = 0; i<times; i++) {
      int angle = int(random(90-amount, 90+amount));
      angle = constrain(angle, 0, 180);
      robotCommands.add("#1 G2202 N3 V"+angle+" F0\n");
      robotPause(int(random(30, 200)));
    }
    robotCommands.add(hoverCoords(theFutureKnob));
  }
}


void robotPause(int theDelay) {
  robotCommands.add(wait(theDelay));
}

void chooseTrigger(int theTrigger) {
  //robotPush(TRIGGERSELECT, 10);
  robotPush(theTrigger+4, 10); // triggers start at 4
  robotPause(50);
  currentTrigger = theTrigger;
}



String wait(int waitTime) {
  waitTime = max(waitTime, 0);
  String data = "#1 G2004 P"+waitTime+"\n";
  return data;
}

String hoverCoords(int theKey) {
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
    if (msg !=null) {
      text(msg, 0, 10*i);
    }
  }


  popMatrix();
  pushMatrix();
  translate(875, 20);
  if (state == SETUP) text("INITIALIZING", 0, 0);
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
  //delay(20);
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
    e.printStackTrace();
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
  //delay(300);
  sendData ("#1 G0 X190 Y-4 Z100 F200\n");
  feedbackMessages.add("--- homed");
  //delay(650);
}

void tick() {
  if (lastSecond != second()) {
    tick++;
    lastSecond = second();
  }
}

void moveRandom() {
  float x = random(150, 200);
  float y = random(120, 170);
  float z = random(30, 60);
  robotCommands.add("#1 G0 X"+x+" Y"+y+" Z"+z+" F"+speed+"\n");
  feedbackMessages.add("--- moved random");
}

void robotMoveTo(int theKey) {
  // place the robot above button / knob

  // make sure the robot hovers before moving
  if (knobTweaking) {
    robotCommands.add(hoverCoords(lastKey));
    knobTweaking = false;
  }

  if (keys[theKey].zone != keys[lastKey].zone) {
    // maybe move relative up in stead??
    home();
    println("bam!");
    //robotCommands.add(homeCoords()); // new key zone, add homing
  }
  robotCommands.add(hoverCoords(theKey));
}

void turnKnob(int theKnob, float _angle) {
  if (theKnob != lastKey) {
    robotMoveTo(theKnob);
  }
  // rotate servo to correct angle before engaging
  robotCommands.add("#1 G2202 N3 V"+(180-knobValue[theKnob])+" F0\n");
  robotCommands.add(wait(100)); // allow for the servo to turn
  robotCommands.add(pushCoords(theKnob));
  knobValue[theKnob] = _angle;
  robotCommands.add("#1 G2202 N3 V"+(180-_angle)+" F0\n");

  knobTweaking = true;
  lastKey = theKnob;
}

void robotPush(int theKey, int theTime) {
  if (knobTweaking) {
    robotMoveTo(currentKnob);
    robotCommands.add("#1 G2202 N3 V90 F0\n"); // turn the servo to the middle
    robotCommands.add(wait(100)); // allow for the servo to turn    
    knobTweaking = false;
  }
  if (keys[theKey].zone != keys[lastKey].zone) {
    home();
    robotCommands.add(wait(500)); // allow for the servo to turn    
    
    println("homing done");
    //robotCommands.add(homeCoords()); // new key zone, add homing
    feedbackMessages.add("homing");
  }
  
  robotCommands.add(hoverCoords(theKey));
  robotCommands.add(pushCoords(theKey));
  robotCommands.add(wait(theTime));
  robotCommands.add(hoverCoords(theKey));
  lastKey = theKey;
  
  println("pushing "+theKey);
  
  feedbackMessages.add("pushing "+theKey);
}

float fixDec(float n) {
  return Float.parseFloat(String.format("%." + 5 + "f", n));
}

void mousePressed() {
  println(mouseX+","+mouseY);
}

void drawKnobs() {
  pushMatrix();
  translate(100, height-100);
  strokeWeight(2);
  for (int i = 0; i<6; i++) {
    translate(100, 0);
    pushMatrix();
    rotate(radians(knobValue[i]));
    ellipse(0, 0, 100, 100);
    line(0, 0, -60, 0);
    popMatrix();
  }
  popMatrix();
}
