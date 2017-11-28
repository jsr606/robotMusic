//press 9 for this song

void condor() { 
  if (state == 0) {
    currentSong = 9;
    randomFreq = 7000;
    songName = "condor";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();

    scaleKeyNames.clear();
    scaleKeyNames.add("B");
    scaleKeyNames.add("J");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("3");
    scaleKeyNames.add("W");
    scaleKeyNames.add("V");
    scaleKeyNames.add("D");
    scaleKeyNames.add("X");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    makeScale();
    
    kaossPad.setPreset(1);
    kaossPad.setEffects(random(0, 0.5), random(0, 0.5));
    kaossPad.tapTempo(94, 8);
    
    goToVoice(2);

    timeToMoveOn = millis()+int(random(600*1000, 610*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) {
      randomInsertStep();
      if (millis()%4 == 0) kaossPad.setEffects(random(0, 0.5), random(0, 0.5));
    }
    if (millis() > timeToMoveOn) {
      state = 2;
    }
  }

  if (state == 2) {
    stateName = "the end";
    int channel = int(random(3));
    kaossPad.setEffects(random(0, 0.5), random(0, 0.5));
    delay(int(random(2000,8000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0 ; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 3;
    }
  }
  
  if (state == 3) {
    println("the song has ended");
    song = 11;
    state = 0;
  }
}