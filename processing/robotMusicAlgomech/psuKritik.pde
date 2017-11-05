void psuKritik() { 
  if (state == 0) {
    currentSong = 6;
    songName = "psukritik";
    stateName = "loading";
    loadSong(currentSong);
    startSong();
    
    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("S");
    scaleKeyNames.add("V");
    scaleKeyNames.add("G");
    scaleKeyNames.add("B");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("2");
    scaleKeyNames.add("<");
    scaleKeyNames.add("<");
    scaleKeyNames.add("<");
    scaleKeyNames.add("<");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    makeScale();
    
    goToVoice(1);
    
    timeToMoveOn = millis()+int(random(50*1000,80*1000));
    state = 1;
  }
  if (state == 1) {
    stateName = "insert step V1";
    if (randomTime) randomInsertStep();
    
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(50*1000,80*1000));
      println("go to voice 2");
      goToVoice(2);
      state = 2;
    }

}
  if (state == 2) {
    stateName = "insert step V2";
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      state = 3;
    }
  }
  
  if (state == 3) {
    stateName = "set up the drop";
    enableChannel(1, false);
    timeToMoveOn = millis()+int(random(20*1000,40*1000));
    clickKey(34);
    int numberOfFPresses = int(random(5,15));
    for (int i=0; i<numberOfFPresses; i++) {
      int theKey = int(random(4));
      clickKey(16+16*theKey);
    }
    state = 4;
  }
  
  if (state == 4) {
    stateName = "the drop";
    if (millis() > timeToMoveOn) state = 5;
  }
  
  if (state == 5) {
    stateName = "?";
    clickKey(32);
    clickKey(34);
    enableChannel(1, true);
    goToVoice(0);
    timeToMoveOn = millis()+int(random(30*1000,75*1000));
    state = 6;
  }
  
  if (state == 6) {
    stateName = "random play V0";
    if (randomTime) randomPlayChannel(50,500);
    //if (millis() > timeToMoveOn) state = 7; 
    if ((songLength/1000)>(4*60)) {
      println("song is more than 4 minutes old, ending it");
      state = 7;
    }
  }
  
  if (state == 7) {
    stateName = "the end";
    int channel = int(random(3));
    delay(int(random(2000,8000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0 ; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 8;
    }
  }
  
  if (state == 8) {
    println("the song has ended");
    song = 2;
    state = 0;
  }
}