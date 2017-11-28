// press 5 for this song

void geminix() { 
  if (state == 0) {
    currentSong = 1;
    randomFreq = 2000;
    loadSong(currentSong);
    songName = "geminix";
    stateName = "loading...";
    startSong();

    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("X");
    scaleKeyNames.add("Z");
    scaleKeyNames.add("S");
    scaleKeyNames.add("S");
    scaleKeyNames.add("D");
    scaleKeyNames.add("V");
    scaleKeyNames.add("V");
    scaleKeyNames.add("V");
    scaleKeyNames.add("G");
    scaleKeyNames.add("G");
    scaleKeyNames.add("B");
    scaleKeyNames.add("H");
    scaleKeyNames.add("J");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("2");
    scaleKeyNames.add("2");
    makeScale();

    goToVoice(0);

    timeToMoveOn = millis()+int(random(150*1000, 200*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(80*1000, 90*1000));
      state = 2;
    }
  }

  if (state == 2) {
    goToVoice(1);
    state = 3;
  }

  if (state == 3) {
    if (randomTime) {
      randomInsertStep();
    }
    if (millis() > timeToMoveOn) {
      state = 4;
    }
  }

  if (state == 4) {
    goToVoice(0);
    timeToMoveOn = millis()+int(random(1*1000, 10*1000));
    state = 5;
  }

  if (state == 5) {
    if (randomTime) randomPlayChannel(50, 500);
    if (millis() > timeToMoveOn) state = 6;
  }

  if (state == 6) {
    // goto back to hyper tempo
    stateName = "hyper tempo";
    clickKey(34);
    clickKey(48);
    clickKey(34);
    timeToMoveOn = millis()+int(random(90*1000, 120*1000));
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
  }

  if (state == 8) {
    int channel = int(random(3));
    delay(int(random(5000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 9;
    }
  }

  if (state == 9) {
    println("the song has ended");
    song = 6;
    state = 0;
  }
}