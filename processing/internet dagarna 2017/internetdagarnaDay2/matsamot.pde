//press 2 for this song

void matsamot() { 
  if (state == 0) {
    currentSong = 4;
    randomFreq = 7000;
    songName = "matsamot";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();

    goToVoice(1);
    
    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("Z");
    scaleKeyNames.add("Z");
    scaleKeyNames.add("Z");
    scaleKeyNames.add("D");
    scaleKeyNames.add("D");
    scaleKeyNames.add("D");
    scaleKeyNames.add("V");
    scaleKeyNames.add("B");
    scaleKeyNames.add("B");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    makeScale();
    
    goToVoice(0);

    timeToMoveOn = millis()+int(random(60*1000, 180*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(100*1000, 200*1000));
      state = 2;
    }
  }

  if (state == 2) {
    goToVoice(1);
    state = 3;
  }

  if (state == 3) {
    if (randomTime) randomPlayChannel(0, 700);
    if (millis() > timeToMoveOn) {
      state = 4;
    }
  }

  if (state == 4) {
    goToVoice(0);
    timeToMoveOn = millis()+int(random(20*1000, 60*1000));
    state = 5;
  }

  if (state == 5) {
    if (randomTime) randomPlayChannel(50, 500);
    if (millis() > timeToMoveOn) state = 6;
  }

  if (state == 6) {
    // goto back to hyper tempo á la kokaninen hehehe....
    stateName = "hyper tempo";
    clickKey(34);
    clickKey(48);
    clickKey(34);
    timeToMoveOn = millis()+int(random(60*1000, 120*1000));
    state = 7;
  }

  if (state == 7) {
    // rock the camera
    // 277.58,-24.76,33.85
    // 210.11,-35.79,53.20
    delay(800);
    if (closeUp) {
      sendData(0, "G0 X210.11 Y-35.79 Z53.20 F30000\n");
    } else {
      sendData(0, "G0 X277.58 Y-24.76 Z33.85 F30000\n");
    }
    closeUp = !closeUp;

    if (millis() > timeToMoveOn) state = 8;
      goToVoice(1);
  }


  if (state == 8) {
    stateName = "random play V0";
    if (randomTime) randomPlayChannel(50,500);
    // if (millis() > timeToMoveOn) state = 7; 
    if ((songLength/1000)>(11*60)) {
      println("song is more than 11 minutes old, ending it");
      state = 9;
    }
  }
  
  if (state == 9) {
    stateName = "the end";
    int channel = int(random(3));
    delay(int(random(16000,32000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0 ; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 10;
    }
  }
  
  if (state == 10) {
    println("the song has ended");
    song = 3;
    state = 0;
  }
}