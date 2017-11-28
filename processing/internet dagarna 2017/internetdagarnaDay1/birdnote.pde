//press 7 for this song

void birdnote() { 
  if (state == 0) {
    currentSong = 7;
    randomFreq = 9000;
    songName = "birdnote";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();

    kaossPad.setPreset(1);
    kaossPad.setEffects(0.5, 0.3);
    kaossPad.tapTempo(93, 8);

    goToVoice(1);

    scaleKeyNames.clear();
    scaleKeyNames.add("Q");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("W");
    scaleKeyNames.add("W");
    scaleKeyNames.add("E");
    scaleKeyNames.add("E");
    scaleKeyNames.add("N");
    scaleKeyNames.add("N");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    makeScale();

    goToVoice(0);

    timeToMoveOn = millis()+int(random(60*1000, 180*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.setEffects(random(0.25, 0.75), random(0.25, 0.75));
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
      randomPlayChannel(0, 100);
      if (millis() % 3 == 0) kaossPad.setEffects(random(0.25, 0.75), random(0.25, 0.75));
    }
    if (millis() > timeToMoveOn) {
      state = 4;
    }
  }

  if (state == 4) {
    goToVoice(0);
    timeToMoveOn = millis()+int(random(80*1000, 200*1000));
    state = 5;
  }

  if (state == 5) {
    if (randomTime) {
      randomPlayChannel(50, 500);
      if (millis() % 3 == 0) kaossPad.setEffects(random(0.25, 0.75), random(0.25, 0.75));
    }
    if (millis() > timeToMoveOn) state = 6;
  }

  if (state == 6) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.setEffects(random(0.25, 0.75), random(0.25, 0.75));
    }
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(200*1000, 250*1000));
      state = 7;
    }
  }

  if (state == 7) {
    goToVoice(1);
    timeToMoveOn = millis()+int(random(200*1000, 250*1000));
    state = 8;
  }

  if (state == 8) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.setEffects(random(0.25, 0.75), random(0.25, 0.75));
    }
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(200*1000, 250*1000));
      state = 9;
    }
  }  

  if (state == 9) {
    if (randomTime) {
      randomPlayChannel(50, 500);
      if (millis() % 3 == 0) kaossPad.setEffects(random(0.25, 0.75), random(0.25, 0.75));
    }
    if (millis() > timeToMoveOn) state = 12;
  }

  if (state == 12) {
    goToVoice(1);
    timeToMoveOn = millis()+int(random(80*1000, 120*1000));
    state = 13;
  }

  if (state == 13) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(20*1000, 50*1000));
      state = 14;
    }
  }  

  if (state == 14) {
    stateName = "random play";
    if (randomTime) randomPlayChannel(50, 500);
    // if (millis() > timeToMoveOn) state = 7; 
    if ((songLength/1000)>(16*60)) {
      println("song is more than 16 minutes old, ending it");
      state = 15;
    }
  }

  if (state == 15) {
    stateName = "the end";
    int channel = int(random(3));
    kaossPad.setEffects(random(0.5, 1), random(0.5, 1));
    delay(int(random(10000, 12000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 16;
    }
  }

  if (state == 16) {
    println("the song has ended");
    song = 9;
    state = 0;
  }
}