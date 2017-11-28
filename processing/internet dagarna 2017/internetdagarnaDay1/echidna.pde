//press 2 for this song

void echidna() { 
  if (state == 0) {
    currentSong = 2;
    randomFreq = 7000;
    songName = "echidna";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();
    
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

    kaossPad.setPreset(1);
    kaossPad.setEffects(0.8,0.5);
    kaossPad.tapTempo(94,8);
    
    goToVoice(0);

    timeToMoveOn = millis()+int(random(60*1000, 180*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) {
      randomInsertStep();
      kaossPad.setEffects(random(0,1),random(0.5,1));
    }
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
    if (randomTime) {
      if (millis()%3 == 0) kaossPad.setEffects(random(0,1),random(0.5,1));
      randomPlayChannel(0, 700);
    }
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
    if (randomTime) {
      randomPlayChannel(50, 500);
      if (millis()%3 == 0) kaossPad.setEffects(random(0,1),random(0.5,1));
    }
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
    if (randomTime) { 
      if (millis()%3 == 0) kaossPad.setEffects(random(0,1),random(0.5,1));
    }

    if (millis() > timeToMoveOn) state = 8;
    goToVoice(1);
  }


  if (state == 8) {
    stateName = "random play V0";
    if (randomTime) {
      randomPlayChannel(50,500);
      if (millis()%3 == 0) kaossPad.setEffects(random(0,1),random(0.5,1));
    }
    // if (millis() > timeToMoveOn) state = 7; 
    if ((songLength/1000)>(12*60)) {
      println("song is more than 12 minutes old, ending it");
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