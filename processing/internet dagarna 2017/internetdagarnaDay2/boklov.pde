//press 8 for this song

void boklov() { 
  if (state == 0) {
    currentSong = 8;
    randomFreq = 3500;
    songName = "boklov";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();
    
    scaleKeyNames.clear();
    scaleKeyNames.add("C");
    scaleKeyNames.add("E");
    scaleKeyNames.add("N");
    scaleKeyNames.add("Y");
    scaleKeyNames.add("J");
    scaleKeyNames.add("7");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    makeScale();
    
    kaossPad.setPreset(1);
    kaossPad.setEffects(random(0.5, 1), random(0, 1));
    kaossPad.tapTempo(106, 8);
        
    goToVoice(2);

    timeToMoveOn = millis()+int(random(360*1000, 380*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) {
      int ran = int(random(2)); 
      println("going to random voice "+(ran+1));
      goToVoice(1+ran);
      randomInsertStep();
    }
      
    if (millis() > timeToMoveOn) {
      state = 2;
    }
  }
  
  if (state == 2) {
    stateName = "the end";
    int channel = int(random(3));
    kaossPad.setEffects(random(0.6, 1), random(0.6, 1));
    delay(int(random(10000,12000)));
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
    song = 9;
    state = 0;
  }
}