void drStep() { 
  if (state == 0) {
    currentSong = 3;
    randomFreq = 7000;
    songName = "dr step";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();
    goToVoice(1);
    
    // z,z,s,s,v,v,g,g,j,m,m,q,5,7,space,space,space  
    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("Z");
    scaleKeyNames.add("S");
    scaleKeyNames.add("S");
    scaleKeyNames.add("V");
    scaleKeyNames.add("V");
    scaleKeyNames.add("G");
    scaleKeyNames.add("G");
    scaleKeyNames.add("J");
    scaleKeyNames.add("M");
    scaleKeyNames.add("M");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("<");
    scaleKeyNames.add("<");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("<");
    makeScale();
    
    timeToMoveOn = millis()+int(random(30*1000,90*1000));
    state = 1;
  }
  if (state == 1) {
    // doing its thing
    if (randomTime) randomPlayChannel(600,2000);
    if (millis() > timeToMoveOn) state = 2;
  }
  
  if (state == 2) {
    // set up the drop
    enableChannel(0, false);
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
    enableChannel(0, true);
    goToVoice(1);
    timeToMoveOn = millis()+int(random(30*1000,90*1000));
    state = 5;
  }
  
  if (state == 5) {
    if (randomTime) randomPlayChannel(600,2000);
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
    song = 3;
    state = 0;
  }
}