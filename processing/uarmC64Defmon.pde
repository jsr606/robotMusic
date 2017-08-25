//  ______________________________/\\\_________________________________________________________________________________________________________________        
//   _____________________________\/\\\_________________________________________________________________________________________________________________       
//    _____________________________\/\\\__________________________/\\\________________________________________________________________/\\\_______________      
//     __/\\/\\\\\\\______/\\\\\____\/\\\____________/\\\\\_____/\\\\\\\\\\\______________/\\\\\__/\\\\\____/\\\____/\\\__/\\\\\\\\\\_\///______/\\\\\\\\_     
//      _\/\\\/////\\\___/\\\///\\\__\/\\\\\\\\\____/\\\///\\\__\////\\\////_____________/\\\///\\\\\///\\\_\/\\\___\/\\\_\/\\\//////___/\\\___/\\\//////__    
//       _\/\\\___\///___/\\\__\//\\\_\/\\\////\\\__/\\\__\//\\\____\/\\\________________\/\\\_\//\\\__\/\\\_\/\\\___\/\\\_\/\\\\\\\\\\_\/\\\__/\\\_________   
//        _\/\\\_________\//\\\__/\\\__\/\\\__\/\\\_\//\\\__/\\\_____\/\\\_/\\____________\/\\\__\/\\\__\/\\\_\/\\\___\/\\\_\////////\\\_\/\\\_\//\\\________  
//         _\/\\\__________\///\\\\\/___\/\\\\\\\\\___\///\\\\\/______\//\\\\\_____________\/\\\__\/\\\__\/\\\_\//\\\\\\\\\___/\\\\\\\\\\_\/\\\__\///\\\\\\\\_ 
//          _\///_____________\/////_____\/////////______\/////_________\/////______________\///___\///___\///___\/////////___\//////////__\///_____\////////__
//           _controlling the uarm swift pro to play music in defmon____________________________________________________________________________________________
//            _ver_0.1_by_jacob_remin_and_goto80_________________________________________________________________________________________________________________

import processing.serial.*;
import controlP5.*;
Serial leftSerial; 

ControlP5 cp5;

// change the name of the serial port here to fit your robot
String leftArm = "/dev/tty.usbserial-A9007VQw";

BufferedReader reader, reader2, reader3;

float[] keyScreenCoordinates = new float [66*2]; 
String[] keyNames = new String [66];
//float[] keyCoordinates = new float [199];
float[] keyboardCoordinates = new float [66*3];
int[] asciiKeyCodes = {36, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 43, 180, 8, -1, -1, 161, 9, 113, 119, 101, 114, 116, 121, 117, 105, 111, 112, 229, 168, 127, -1, 167, -1, -2, 97, 115, 100, 102, 103, 104, 106, 107, 108, 230, 248, 39, 10, 8734, -3, 60, 122, 120, 99, 118, 98, 110, 109, 44, 46, 45, -1, -4, -5, 182, 32};
String[] scaleKeyNames = {"Z", "X", "D", "V", "B", "J", "Q", "W", "3", "R", "T", "6", "7", "I", "O", "0", "SPACE", ":", ";", "="};
int[] scale = new int [20];

// SPECIAL KEYCODES
// -2 = SHIFT
// -3 = COMMODORE
// -4 = VERTICAL
// -5 = HORISONTAL

PImage C64;
String keyPress = "";
PFont mono;
boolean armDown = false;
float speed = 20000, accelleration = 300;
String saveString = "";

int thisKey = 0;

float lastStep = millis();
int stepTime = 1000;

boolean debug = true, attached = true;

float xOffset = 0, yOffset = 0, zOffset = 10, push = 12;
boolean running = false;

String feedbackString = "", incomingMessage = "", lastIncomingMessage = "", incomingCoordinates = "";

boolean armMoving = false;
String lastCommand, gCode;

int serialFrequency = 200, lastSerial = millis();

int lastKeyPressed = -1;
boolean pushing = false;

boolean sending = false;

int randomFreq = 10;
boolean randomOn = true;

float lastTick = millis();
int ticks = 0, nextRandomTick = 5;

void setup() {
  size(700, 487);
  
  if (debug) printArray(Serial.list());
  leftSerial = new Serial(this, leftArm, 115200);
  
  C64 = loadImage("C64.jpg");
  mono = loadFont("Courier-10.vlw");

  cp5 = new ControlP5(this);
  cp5.addSlider("speed").setRange(0, 40000).setPosition(10, 10).setWidth(250);
  cp5.addSlider("accelleration").setRange(0, 3000).setPosition(10, 20).setWidth(250);
  cp5.addSlider("xOffset").setRange(-50, 50).setPosition(10, 30).setWidth(250);
  cp5.addSlider("yOffset").setRange(-50, 50).setPosition(10, 40).setWidth(250);
  cp5.addSlider("zOffset").setRange(-50, 50).setPosition(10, 50).setWidth(250);
  cp5.addSlider("randomFreq").setRange(0, 100).setPosition(10, 60).setWidth(250);
  cp5.addSlider("push").setRange(0, 25).setPosition(10, 70).setWidth(250);

  reader = createReader("data/keyScreenCoordinates.txt");  
  reader2 = createReader("data/keyNames.txt");  
  reader3 = createReader("data/keyboardCoordinates.txt");  
  readData();

  delay(5000);  
  home(0);
  sendData(0, "#3 M2120 V0.2\n");
}

void draw() {
  
  image(C64, 0, 0);
  
  fill(255);
  text(incomingCoordinates, 420, 83);
  text(lastCommand, 420, 103);
  text(lastKeyPressed+" "+pushing, 420, 123);

  if (randomOn) {
    if (ticks > nextRandomTick) {

      // tweak r for amount of shifting / resetting of voices
      float r = random(30);
      
      println("time to take a chance "+r);
      if (r < 3) {
        println("reset voice");
        resetVoice();
      }
      if (r >= 3 && r < 10) {
        println("shifting voice");
        shiftVoice();
      }
      if (r >= 10) {
        int k = scale[int(random(scale.length))];
        println("scale length "+scale.length);
        // press key
        pressKey(k);
        delay(int(random(600, 2000)));
        // release key
        moveTo(0, k);
        delay(1000);
        nextRandomTick = ticks+int(random(randomFreq));
        println("next randomtick: "+nextRandomTick);

      }
    }
  }

  tick();
}

void keyFeedback(int theKey) {
  rectMode(CENTER);
  noFill();
  stroke(255, 0, 0);
  rect(keyScreenCoordinates[theKey*2], keyScreenCoordinates[theKey*2+1], 25, 25);
  text(keyNames[theKey], 433, 73);
  text(keyboardCoordinates[theKey*3]+","+keyboardCoordinates[theKey*3+1]+","+keyboardCoordinates[theKey*3+2], 433, 100);
  moveTo(0, theKey);
}


void keyPressed() { 

  if (key == 's') {
    println("shift voice manually");
    shiftVoice();
  }

  if (key == 'r') {
    println("resetting voice");
    resetVoice();
  }

  int theKey = int(key);
  println("raw key code: "+int(key));

  if (theKey == 8706) {
    // ALT + d
    attachDetach();
  }

  if (theKey == 8800) {
    leftSerial.clear();
    println("clear serial buffer");
    leftSerial.stop();
    delay(5000);
    leftSerial = new Serial(this, leftArm, 115200);
    sendData(0, "#3 M2120 V0.2\n");
  }

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
      if (pushing == false) {
        pressKey(i);
      }
    }
  }

  // set acceleration
  // sendData(0, "M204 P300 T300\n");
  // sendData(0, "M204 T"+int(accelleration)+"\n");
  // check if uarm is moving
  // sendData(0, "#2 M2200\n");
  // set reference position
  // sendData(0, "M2401\n");
  // sendData(0, "#3 M2120 V0.2\n");

}

void pressKey(int theKey) {
  moveTo(0, theKey);
  String data = "G0 X"+(keyboardCoordinates[theKey*3]+xOffset)+" Y"+(keyboardCoordinates[theKey*3+1]+yOffset)+" Z"+(keyboardCoordinates[theKey*3+2]+zOffset-push)+" F"+int(speed)+"\n";
  sendData (0, data);
  pushing = true;
  lastKeyPressed = theKey;
}


void parseIncomingCoordinates() {
  String[] coords = split(incomingCoordinates, " ");
  for (int i = 0; i<coords.length-1; i++) {
    //println(i+" "+coords[i]);
    print(coords[i].substring(1));
    print(",");
  }
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

void home (int theArm) {
  sendData(theArm, "G0 X141.20 Y-52.49 Z139.42 F20000\n");
}

void moveTo (int theArm, int theKey) {
  String data = "G0 X"+(keyboardCoordinates[theKey*3]+xOffset)+" Y"+(keyboardCoordinates[theKey*3+1]+yOffset)+" Z"+(keyboardCoordinates[theKey*3+2]+zOffset)+" F"+int(speed)+"\n";
  sendData (theArm, data);
}

void waitForIt (int theArm) {
}

void sendData (int theArm, String theData) {
  
  while (serialFrequency + lastSerial > millis()) {
    //println("wait for it");
    fill(255, 0, 0);
    rect(width-50, height-50, 10, 10);
  }

  if (theArm == 0) {
    //if (debug) print("sending G code to left arm: "+theData);
    leftSerial.write(theData);
    gCode += theData;
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
  //println("new incoming: "+incomingMessage);
  //println("--");
  if (incomingMessage.contains("@3")) {
    incomingCoordinates = incomingMessage.substring(4);
    // coord feedback
  } else if (incomingMessage.contains("$2")) {
    //println("motion: "+incomingMessage.substring(8));
    if (incomingMessage.substring(8).contains("1")) {
      armMoving = true;
    } else {
      armMoving = false;
    }
  } else {
    feedbackString += incomingMessage;
    lastIncomingMessage = incomingMessage.substring(1);
  }
  incomingMessage = "";
}

void readData() {
  String line;
  try {
    line = reader.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  String[] linePieces = split(line, ',');
  for (int i = 0; i<linePieces.length; i++) {
    keyScreenCoordinates[i] = int(linePieces[i]);
  }

  String line2;
  int k = 0;

  try {
    line2 = reader2.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line2 = null;
  }
  int s = 0;
  String[] linePieces2 = split(line2, ',');
  for (int i = 0; i<linePieces2.length; i++) {
    keyNames[k] = linePieces2[i];
    println("key nr: "+k+" has name "+keyNames[k]);

    for (int j = 0; j<scaleKeyNames.length; j++) {
      if (keyNames[k].equals(scaleKeyNames[j])) {
        // this key is in the scale
        println(s+" this key is in the scale");
        scale[s] = k;
        s++;
      }
    }
    k++;
  }
  println("scale is: ");
  for (int i = 0; i<scale.length; i++) {
    print(scale[i]+" ");
  }

  String line3;

  try {
    line3 = reader3.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line3 = null;
  }
  String[] linePieces3 = split(line3, ',');
  for (int i = 0; i<linePieces3.length; i++) {
    keyboardCoordinates[i] = float(linePieces3[i]);
  }
}

void keyReleased()  {
  if (pushing) {
    moveTo(0, lastKeyPressed);
    pushing = false;
  }
}

void shiftVoice() {  
  pressKey(63);
  delay(500);
  moveTo(0, 63);
  delay(500);
  nextRandomTick = nextRandomTick + 5;
}

void resetVoice()  {
  // key nr: 34 has name SHIFTLOCK
  pressKey(34);
  delay(500);
  moveTo(0, 34);
  delay(500);
  pressKey(63);
  delay(8000);
  moveTo(0, 63);
  delay(500);
  pressKey(34);
  delay(500);
  moveTo(0, 34);
  delay(5000);
  nextRandomTick = nextRandomTick + 10;
}

void tick() {
  if (lastTick + 1000 < millis()) {
    ticks++;
    println("tick: "+ticks);
    lastTick = millis();
  }
}