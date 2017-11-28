//press 8 for this song

void oso() { 
  if (state == 0) {
    currentSong = 8;
    randomFreq = 7000;
    songName = "oso";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();

    goToVoice(1);
    
    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("S");
    scaleKeyNames.add("V");
    scaleKeyNames.add("G");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("2");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    makeScale();
    
    goToVoice(0);

    timeToMoveOn = millis()+int(random(110*1000, 120*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
      state = 2;
    }
  }

  if (state == 2) {
    goToVoice(2);
    state = 3;
  }

  if (state == 3) {
    if (randomTime) randomPlayChannel(0, 200);
    if (millis() > timeToMoveOn) {
      state = 4;
    }
  }
  
  if (state == 4) {
    goToVoice(0);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 5;
  }

  if (state == 5) {
    if (randomTime) randomPlayChannel(50, 500);
    if (millis() > timeToMoveOn) state = 6;
  }

  if (state == 6) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
      state = 7;
    }
  }

  if (state == 7) {
    goToVoice(1);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 8;
  }
  
  if (state == 8) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
      state = 9;
    }
  }  

      if (state == 9) {
    if (randomTime) randomPlayChannel(50, 500);
    if (millis() > timeToMoveOn) state = 10;
  }

  if (state == 10) {
    goToVoice(0);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 11;
  }
  
  if (state == 11) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
      state = 12;
    }
  }

  if (state == 12) {
    goToVoice(1);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 13;
  }
  
  if (state == 13) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 40*1000));
      state = 14;
    }
  }  
  
   if (state == 14) {
    goToVoice(0);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 15;
  } 
  
  if (state == 15) {
    stateName = "random play";
    if (randomTime) randomPlayChannel(50,500);
    // if (millis() > timeToMoveOn) state = 7; 
    if ((songLength/1000)>(7*60)) {
      println("song is more than 7 minutes old, ending it");
      state = 16;
    }
  }
  
  if (state == 16) {
    stateName = "the end";
    int channel = int(random(3));
    delay(int(random(25000,50000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0 ; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 17;
    }
  }
  
  if (state == 17) {
    println("the song has ended");
    song = 9;
    state = 0;
  }
}