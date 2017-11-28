// press 5 for this song

void rentakopf() { 
  if (state == 0) {
    currentSong = 7;
    randomFreq = 2000;
    loadSong(currentSong);
    songName = "rentakopf";
    stateName = "loading...";
    startSong();

    scaleKeyNames.clear();
    scaleKeyNames.add("Q");
    scaleKeyNames.add("3");
    scaleKeyNames.add("R");
    scaleKeyNames.add("T");
    makeScale();

    kaossPad.setPreset(1);
    kaossPad.setEffects(0.2, 0.2);
    kaossPad.tapTempo(111, 8);

    goToVoice(0);

    timeToMoveOn = millis()+77*1000;
    state = 1;
  }
  if (state == 1) {
    if (randomTime) {
      randomInsertStep();
      randomPlayChannel(50, 500);
    }
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+122*1000;
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
      randomPlayChannel(50,500);
    }
      
    if (millis() > timeToMoveOn) {
      state = 4;
    }
  }

  if (state == 4) {
    goToVoice(2);
    timeToMoveOn = millis()+60*1000;
    state = 5;
  }

  if (state == 5) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) state = 6;
  }

  if (state == 6) {
    goToVoice(0);
    timeToMoveOn = millis()+40*1000;
    state = 7;
  }

  if (state == 7) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) state = 8;
  }

  if (state == 8) {
    int channel = int(random(3));
    delay(int(random(7000,13000)));
    kaossPad.setEffects(random(0.7,1), random(0.6,1));
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