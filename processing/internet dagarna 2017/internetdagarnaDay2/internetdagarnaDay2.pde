// ROBOT MUSIC
// ver 0.3 by jacob remin and goto80
// controlling the uarm swift pro to play music in defmon
// for internetdagarna 2017

// to re-calibrate keyboard coordinates:
// press 'alt+d' to attach/detach robot arm
// press 'c' to print robot coordinates to console. get all key cordinates from left to right, top to bottem
// copy paste comma seperated list in to data/keyboardCoordinates.txt

// to check calibration:
// press 'k' to enable keyboard parsing, robot will now move to which ever key is pressed
// press a key with no function attached to it: maybe 'o'?
// do small tweaks in GUI to x,y and z offset if needed
// press 'k' again to disable keyboard parsing

// press SPACE BAR to start the show (including pause for intro by anders)
// press 1-9,qwerty... to start from that specific song

import processing.serial.*;
import controlP5.*;
Serial robotSerial; 

ControlP5 cp5;

// put the serial port to fit your robot here
String robotArm = "/dev/tty.usbserial-A1068NZ4";

// helper files to read misc data from harddrive
BufferedReader reader1, reader2, reader3;

String[] keyNames = new String [66];
float[] keyboardCoordinates = new float [66*3];
float[] keyScreenCoordinates = new float [66*2]; 
int[] asciiKeyCodes = {36, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 43, 180, 8, -1, -1, 161, 9, 113, 119, 101, 114, 116, 121, 117, 105, 111, 112, 229, 168, 127, -1, 167, -1, -2, 97, 115, 100, 102, 103, 104, 106, 107, 108, 230, 248, 39, 10, 8734, -3, 60, 122, 120, 99, 118, 98, 110, 109, 44, 46, 45, -1, -4, -5, 182, 32};
// SPECIAL KEYCODES, -2 = SHIFT, -3 = COMMODORE, -4 = VERTICAL, -5 = HORISONTAL

// active scale, human readable keyname list
ArrayList scale, scaleKeyNames;

PImage C64pic;
String keyPress = "";
PFont mono;
float speed = 20000, accelleration = 300;

boolean debug = false, attached = true;

float xOffset = 0, yOffset = 0, zOffset = 12, push = 11;

String feedbackString = "", incomingMessage = "", lastIncomingMessage = "", incomingCoordinates = "";

float robotX, robotY, robotZ;

boolean armMoving = false;
String lastCommand;

int serialFrequency = 100, lastSerial = millis();

int activeKey = -1, lastKeyPressed = -1;

boolean sending = false;

int randomFreq = 10000;
boolean randomOn = false;

float lastTick = millis();
int ticks = 0;

int nextRandom = millis();

ArrayList keys; 

boolean usbKeyboardOn = false;

int song = -1; 
boolean robotMoving = false;

boolean [] channelOn = {true, true, true}; 
boolean keyParsing = false;

int songLength;

boolean playing = false;

int activeVoice = 0;

int currentSong = -1;
int state = 0;
int timeToMoveOn = millis(), timeSongStarted = millis();

PImage ledON, ledOFF;

String songName, stateName;

boolean randomTime = true;

boolean closeUp = true;

KaossPadMini kaossPad;
int pushDelay = 104;
float holdPush = 4.4;

static int C64 = 0, KAOSSPAD = 1;
int activeInstrument = -1;

void setup() {
  size(700, 487);

  keys = new ArrayList();

  printArray(Serial.list());
  robotSerial = new Serial(this, robotArm, 115200);

  C64pic = loadImage("C64.jpg");
  ledON = loadImage("ledON.png");
  ledOFF = loadImage("ledOFF.png");
  mono = loadFont("PTMono-Regular-12.vlw");
  textFont(mono, 12);

  cp5 = new ControlP5(this);
  cp5.addSlider("speed").setRange(0, 40000).setPosition(10, 10).setWidth(250);
  cp5.addSlider("accelleration").setRange(0, 3000).setPosition(10, 20).setWidth(250);
  cp5.addSlider("xOffset").setRange(-50, 50).setPosition(10, 30).setWidth(250);
  cp5.addSlider("yOffset").setRange(-50, 50).setPosition(10, 40).setWidth(250);
  cp5.addSlider("zOffset").setRange(-50, 50).setPosition(10, 50).setWidth(250);
  cp5.addSlider("push").setRange(0, 25).setPosition(10, 60).setWidth(250);
  cp5.addSlider("pushDelay").setRange(0, 1000).setPosition(10, 70).setWidth(250);
  cp5.addSlider("holdPush").setRange(0, 10).setPosition(10, 80).setWidth(250);

  // read data about C64 keys
  reader1 = createReader("data/keyScreenCoordinates.txt");  
  reader2 = createReader("data/keyNames.txt");  
  reader3 = createReader("data/keyboardCoordinates.txt");  
  createKeys();

  scale = new ArrayList();
  scaleKeyNames = new ArrayList();

  kaossPad = new KaossPadMini();

  // wait for the serial port to get ready
  delay(1000);  
  // set continuos position feedback
  sendData(0, "#3 M2120 V0.2\n");
  // set faster accelleration
  sendData(0, "M204 P300 T300\n");
}

void draw() {
  background(0);

  drawComputer();

  switch (song) {
  case -1:
    // initialize robot
    println("welcome to the cocktail bar 2 tooooo");
    home();
    song = 0;
    break;

  case 0:
    // idle, do nothing, wait for show to begin
    if (playing) {
      println("waiting for anders to intro");
      delay(int(random(90*1000,120*1000)));
      song = 1;
    }
    break;

  case 1:
    triller();
    break;

  case 2:
    matsamot();
    break;

  case 3:
    synkex();
    break;

  case 4:
    syllan();
    break;

  case 5:
    rentakopf();
    break;

  case 6:
    sushib();
    break;

  case 7:
    antispeed();
    break;

  case 8:
    boklov();
    break;

  case 9:
    condor();
    break;
    
  case 10:
    floredux();
    break;

  case 11:
    print("no more songs   stop ");
    //no more songs
    break;
  }

  tick();
}

void randomPlayChannel(int shortest, int longest) {
  
  waitForRobot();
  
  stateName = "random play V"+activeVoice;
  int k = (int) scale.get(int(random(scale.size())));
  // press key
  int del = int(random(shortest, longest)); 
  pushKey(k, del); 
  activeKey = -1; 
  nextRandom = millis()+int(random(randomFreq));
}

void randomInsertStep()  {
  
  waitForRobot();
  
  stateName = "insert step V"+activeVoice;
  // add a little delay magic
  delay(int(random(200)));
  clickKey(48);
  clickKey(47);
  clickKey(47);
  clickKey(48);

  nextRandom = millis()+int(random(randomFreq));
}

void OctaveDownOnStep()  {
  stateName = "octave down step V"+activeVoice;
  // add a little delay magic
  delay(int(random(200)));
  clickKey(48);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(88);
  clickKey(48);

  nextRandom = millis()+int(random(randomFreq));
}

void randomDeleteStep()  {
  
  waitForRobot();
  
  stateName = "delete step V"+activeVoice;
  // add a little delay magic
  delay(int(random(200)));
  clickKey(48);
  clickKey(34);
  clickKey(47);
  clickKey(47);
  clickKey(34);
  clickKey(48);

  nextRandom = millis()+int(random(randomFreq));
}

void forceToVoice(int theVoice) {
  // go back to voice 0
  
  waitForRobot();
  
  clickKey(34); 
  pushKey(63, 1500); 
  clickKey(34); 
  activeVoice = 0;
  int voiceSteps = theVoice-activeVoice;

  for (int i = 0; i<voiceSteps; i++) {
    clickKey(63); 
    activeVoice ++;
  }
  
  waitForRobot();
  
}

void goToVoice (int theVoice) {
  
  waitForRobot();

  if (activeVoice > theVoice) {
    // go back to voice 0
    clickKey(34); 
    pushKey(63, 1500); 
    clickKey(34); 
    activeVoice = 0;
  }

  int voiceSteps = theVoice-activeVoice;

  for (int i = 0; i<voiceSteps; i++) {
    clickKey(63); 
    activeVoice ++;
  }

  println("active voice "+activeVoice);
}

void startSong () {
  println("starting song"); 
  clickKey(32);
  timeSongStarted = millis();
  // force to voice 1
  forceToVoice(0);
}

void stopSong() {
  println("stopping song"); 
  clickKey(64);
}

void enableChannel(int theChannel, boolean onOff) {
  
  waitForRobot();
  
  if (channelOn[theChannel] != onOff) {
    clickKey(44+theChannel);
    channelOn[theChannel] = !channelOn[theChannel];
    println("channel "+theChannel+" "+channelOn[theChannel]);
    //break;
  } else {
    if (onOff == true) {
      println("channel "+theChannel+" is already on");
    } else {
      println("channel "+theChannel+" is already off");
    }
  }
  println("channels on: "+channelOn[0]+" "+channelOn[1]+" "+channelOn[2]);
}

void loadSong(int theSong) {
  println("load song nr "+theSong); 
  clickKey(34); 
  clickKey(52); 
  clickKey(34); 
  delay(1000); 
  for (int i = 0; i<theSong; i++) {
    clickKey(62);
  }
  clickKey(47); 
  delay(7000);

  // all channels are on
  channelOn[0] = true;
  channelOn[1] = true;
  channelOn[2] = true;
}

void drawComputer() {
  imageMode(CORNER);    
  image(C64pic, 0, 0); 
  fill(255); 
  pushMatrix();
  float tightness = 12;
  translate(420, 83);
  text("internet cocktail ambient - day 2", 0, 0);
  translate(0, tightness);
  text(incomingCoordinates, 0, 0);
  translate(0, tightness);
  text("random frequency: "+randomFreq, 0, 0);
  translate(0, tightness);
  text("song: "+currentSong+" "+songName, 0, 0);
  translate(0, tightness);
  text("state: "+state+" "+stateName, 0, 0);

  songLength = millis()-timeSongStarted;
  int mins = int(songLength/1000/60);
  int secs = (int(songLength/1000))%60;
  String s = nf(secs, 2);
  translate(0, tightness);
  text("dur: "+mins+":"+s, 0, 0);

  //keyFeedback(activeKey);
  translate(0, 3);
  if (second() % 2 == 0) {
    fill(0);
  } else {
    fill(255);
  }
  rectMode(CORNER);
  rect(0, 0, 2, 12);
  popMatrix();
  pushMatrix();
  translate(598, 251);
  for (int i = 0; i<3; i++) {
    fill(0);
    stroke(0);
    imageMode(CENTER);
    if (channelOn[i]) {
      image(ledON, 0, 0);
    } else {
      image(ledOFF, 0, 0);
    }
    if (activeVoice == i) {
      ellipseMode(CENTER);
      stroke(0);
      noFill();
      ellipse(0, 0, 13, 13);
    }
    translate(15, 0);
  }
  popMatrix();
}

void clickKey (int theKey) {
  pushKey(theKey, 0);
}

void pushKey (int theKey, int theDelay) {
  
  if (activeInstrument != C64) {
    if (debug) println("coming from a different instrument, homing");
    home();
    activeInstrument = C64;
  }
  
  if (debug) println("pushing "+theKey); 
  waitForRobot();
  C64Key c64k = (C64Key) keys.get(theKey); 
  String data = "#1 G0 X"+(c64k.x+xOffset)+" Y"+(c64k.y+yOffset)+" Z"+(c64k.z+zOffset)+" F"+int(speed)+"\n"; 
  sendData (0, data); 
  data = "#1 G0 X"+(c64k.x+xOffset)+" Y"+(c64k.y+yOffset)+" Z"+(c64k.z+zOffset-push)+" F"+int(speed)+"\n";
  sendData (0, data);
  waitForRobot();
  delay(theDelay);
  data = "#1 G0 X"+(c64k.x+xOffset)+" Y"+(c64k.y+yOffset)+" Z"+(c64k.z+zOffset)+" F"+int(speed)+"\n"; 
  sendData (0, data);
  waitForRobot();
}

void checkForMovement() {
  sendData(0, "#2 M2200\n");
}

void moveTo (int theKey) {
  
  if (activeInstrument != C64) {
    println("coming from a different instrument, homing");
    home();
    activeInstrument = C64;
  }
  
  waitForRobot();
  if (debug) println("moving to "+theKey); 
  C64Key c64k = (C64Key) keys.get(theKey); 
  String data = "#1 G0 X"+(c64k.x+xOffset)+" Y"+(c64k.y+yOffset)+" Z"+(c64k.z+zOffset)+" F"+int(speed)+"\n"; 
  sendData (0, data); 
  waitForRobot();

}

void makeScale() {
  scale.clear();
  int s = 0; 
  for (int j = 0; j<scaleKeyNames.size(); j++) {
    for (int i = 0; i<keyNames.length; i++) { 
      String k = (String) scaleKeyNames.get(j);
      if (keyNames[i].equals(k)) {
        // this key is in the scale
        scale.add(i);
      }
    }
  }

  print("created new scale ");
  for (int i = 0; i<scale.size(); i++) {
    int j = (int) scale.get(i);
    print(j+" ");
  }
  println();
}

void keyFeedback(int theKey, color theColor) {
  //println("key feedback for key "+theKey);
  if (theKey != -1) {
    rectMode(CENTER); 
    noFill(); 
    stroke(255, 0, 0); 
    rect(keyScreenCoordinates[theKey*2], keyScreenCoordinates[theKey*2+1], 25, 25); 
    text(keyNames[theKey], 433, 73); 
    text(keyboardCoordinates[theKey*3]+","+keyboardCoordinates[theKey*3+1]+","+keyboardCoordinates[theKey*3+2], 433, 100); 
    //moveTo(theKey);
  }
}

void keyPressed() { 

  if (key == 'e') {
    float effect1 = random(0,1);
    float effect2 = random(0,1);
    println("setting kaoss pad to: "+effect1+","+effect2);
    kaossPad.setEffects(effect1,effect2);
    
    //kaossPad.setEffects(0.9,0.1);
    
    
    /*
    kaossPad.setEffects(0,0);
    delay(1000);
    kaossPad.setEffects(0,1);
    delay(1000);
    kaossPad.setEffects(1,0);
    delay(1000);
    kaossPad.setEffects(0,1);
    delay(1000);
    */
  }
  
  if (key == 'h') {
    kaossPad.holdOn(!kaossPad.hold);
  }
  
  if (key == 'b') {
    kaossPad.tapTempo(75,8);
  }
  
  if (key == 'p') {
    kaossPad.setPreset(0);
  }
  
  if (key == 'P') {
    kaossPad.setPreset(1);
  }
  
  if (key == 'r') {
    kaossPad.playWithEffects(10,200);
  }

  if (key == '1') {
    song = 1;
  }

  if (key == '2') {
    song = 2;
  }

  if (key == '3') {
    song = 3;
  }

  if (key == '4') {
    song = 4;
  }

  if (key == '5') {
    song = 5;
  }

  if (key == '6') {
    song = 6;

  }
  if (key == '7') {
    song = 7;

  }
  if (key == '8') {
    song = 8;

  }
  if (key == '9') {
    song = 9;
  
  }
  if (key == '0') {
    song = 10;
  }

  int theKey = int(key); 
  if (debug) println("raw key code: "+int(key)); 

  if (theKey == 8706) {
    // ALT + d
    attachDetach();
  }
  
  if (key == 'k') {
    // turn key parser on / off
    keyParsing = !keyParsing;
    println("keyparsing "+keyParsing);
  }

  if (key == 'c') {
    // print coordinates to terminal, as comma seperated list
    parseIncomingCoordinates();
  }
  
  if (keyParsing) {

    if (key == CODED) {
      if (keyCode == SHIFT) {
        println("SHIFT"); 
        theKey = -2;
      }  
      if (keyCode == CONTROL) {
        println("CONTROL"); 
        theKey = -3;
      }
      if (keyCode == ALT) {
        println("ALT");
      }
      if (keyCode == LEFT) {
        println("LEFT"); 
        theKey = -5;
      } 
      if (keyCode == RIGHT) {
        println("RIGHT"); 
        theKey = -5;
      }
      if (keyCode == UP) {
        println("UP"); 
        theKey = -4;
      }
      if (keyCode == DOWN) {
        println("DOWN"); 
        theKey = -4;
      }
    }

    for (int i = 0; i<asciiKeyCodes.length; i++) {
      if (theKey == asciiKeyCodes[i]) {   
        println("commodore key: "+keyNames[i]); 
        clickKey(i);
      }
    }
  }
}

void parseIncomingCoordinates() {
  String[] coords = split(incomingCoordinates, " "); 
  
  /*
  for (int i = 0; i<coords.length-1; i++) {
    //println(i+" "+coords[i]);
    print(coords[i].substring(1)); 
    print(",");
  }
  */
  robotX = float(coords[0].substring(1));
  robotY = float(coords[1].substring(1));
  robotZ = float(coords[2].substring(1));
  //println("parsed coords: "+robotX+","+robotY+","+robotZ);
}

void attachDetach() {
  // detach / attach servo motors
  attached = !attached; 
  if (attached) {
    println("attaching servos"); 
    sendData (0, "M17\n");
  } else {
    println("detaching servos"); 
    sendData (0, "M2019\n");
  }
}

void home () {
  waitForRobot();
  sendData(0, "G2202 N3 V99\n"); 
  sendData(0, "G0 X210.11 Y-35.79 Z53.20 F20000\n");
  waitForRobot();
}

void waitForRobot() {
  robotMoving = true;
  while (robotMoving) checkForMovement();
}


void sendData (int theArm, String theData) {
  while (serialFrequency + lastSerial > millis()) {
    //println("wait for it");
    fill(255, 0, 0); 
    rect(width-50, height-50, 10, 10);
  }

  if (theArm == 0) {
    //if (debug) print("sending G code to left arm: "+theData);
    robotSerial.write(theData); 
    lastCommand = theData;
  }

  lastSerial = millis(); 
  sending = true; 
  fill(0, 255, 0); 
  rect(width-50, height-50, 10, 10); 
  //println("sent");
}

void serialEvent(Serial myPort) {
  int inByte = myPort.read(); 
  incomingMessage += char(inByte); 
  if (inByte == 13) parseIncomingSerial(); 
  //print(char(inByte));
}

void parseIncomingSerial () {
  if (debug) println("new incoming: "+incomingMessage); 
  if (debug) println("--"); 
  if (incomingMessage.contains("@3")) {
    // coord feedback
    incomingCoordinates = incomingMessage.substring(4);
    parseIncomingCoordinates();
  } else if (incomingMessage.contains("$1")) {
    // movement completed
    robotMoving = false;
  } else if (incomingMessage.contains("$2")) {
    int mov = int(incomingMessage.substring(8)); 
    if (mov == 1) {
      //println("still moving");
      robotMoving = true;
    } else {
      //println("done moving");
      robotMoving = false;
    }
  } else {
    feedbackString += incomingMessage; 
    lastIncomingMessage = incomingMessage.substring(1);
  }
  incomingMessage = "";
}

void tick() {
  if (lastTick + 1000 < millis()) {
    ticks++; 
    lastTick = millis();
  }
  if (millis() > nextRandom) {
    randomTime = true;
    nextRandom = millis()+int(random(randomFreq/2,randomFreq));
  } else {
    randomTime = false;
  }
}

void accelleration(float theValue) {
  println("new accelleration "+theValue); 
  int v = int(theValue); 
  robotSerial.write("M204 P"+v+" T"+v+"\n");
}

void mouseClicked() {
  println(mouseX+","+mouseY);
}