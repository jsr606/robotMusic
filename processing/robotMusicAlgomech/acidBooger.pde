void acidBooger() { 
  if (state == 0) {
    currentSong = 5;
    songName = "acid booger";
    stateName = "loading...";
    loadSong(currentSong);
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
    
    timeToMoveOn = millis()+int(random(30*1000,90*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) state = 2;
  }
  
  if (state == 2) {
    // set up the drop
    enableChannel(1, false);
    enableChannel(2, false);
    timeToMoveOn = millis()+int(random(20*1000,40*1000));
    clickKey(34);
    int numberOfFPresses = int(random(5,15));
    for (int i=0; i<numberOfFPresses; i++) {
      int theKey = int(random(4));
      clickKey(16+16*theKey);
    }
    state = 3;
  }
  
  if (state == 3) {
    if (millis() > timeToMoveOn) state = 4;
    // wait for it
  }
  
  if (state == 4) {
    clickKey(32);
    clickKey(34);
    enableChannel(1, true);
    enableChannel(2, true);
    goToVoice(0);
    timeToMoveOn = millis()+int(random(30*1000,90*1000));
    state = 5;
  }
  
  if (state == 5) {
    if (randomTime) randomPlayChannel(50,500);
    if (millis() > timeToMoveOn) state = 6; 
  }
  
  if (state == 6) {
    // the end
    int channel = int(random(3));
    delay(int(random(5000,10000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0 ; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 7;
    }
  }
  
  if (state == 7) {
    println("the song has ended");
    song = 4;
    state = 0;
  }
}