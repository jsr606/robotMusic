void afrikstep() { 
  if (state == 0) {
    currentSong = 4;
    songName = "afrikstep";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();
    randomFreq = 1000;
    
    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("C");
    scaleKeyNames.add("B");
    makeScale();
    
    goToVoice(1);
    timeToMoveOn = millis()+int(random(60*1000,120*1000));
    state = 1;
  }
  
  if (state == 1) {
    if (randomTime) randomPlayChannel(50,500);
    if (millis() > timeToMoveOn) state = 2;
    // wait for it
  }
  
  if (state == 2) {
    goToVoice(0);
    timeToMoveOn = millis()+int(random(60*1000,120*1000));
    state = 3;    
  }
  
  if (state == 3) {
    if (randomTime) {
      randomInsertStep();
      randomPlayChannel(50,500);
    }
    if (millis() > timeToMoveOn) state = 4;
    stateName = "inserting and playing";
  }
  
  if (state == 4) {
    stateName = "end";
    enableChannel(2, false);
    delay(int(random(5000,7000)));
    enableChannel(1, false);
    delay(int(random(5000,7000)));
    enableChannel(0, false);
    clickKey(64);
    state = 5;
  }
  
  if (state == 5) {
    println("the song has ended");
    song = 5;
    state = 0;
  }
}