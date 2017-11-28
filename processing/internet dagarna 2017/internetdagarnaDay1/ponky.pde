//press 9 for this song

void ponky() { 
  if (state == 0) {
    currentSong = 9;
    randomFreq = 7000;
    songName = "ponky";
    stateName = "loading...";
    loadSong(currentSong);
    delay(2000);
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
    
    goToVoice(2);

    kaossPad.setPreset(1);
    kaossPad.setEffects(0.4, 0.4);
    kaossPad.tapTempo(94, 8);

    timeToMoveOn = millis()+int(random(100*1000, 110*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 50*1000));
      state = 2;
    }
  }

  if (state == 2) {
    goToVoice(0);
    state = 3;
  }

  if (state == 3) {
    if (randomTime) {
      randomPlayChannel(0, 200);
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
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
    if (randomTime) {
      randomPlayChannel(0, 100);
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
    if (millis() > timeToMoveOn) state = 6;
  }

  if (state == 6) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
      state = 7;
    }
  }

  if (state == 7) {
    goToVoice(0);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 8;
  }
  
  if (state == 8) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.playWithEffects(15,600);
    }
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
      state = 9;
    }
  }  

      if (state == 9) {
    if (randomTime) {
      randomPlayChannel(50, 500);
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
    if (millis() > timeToMoveOn) state = 10;
  }

  if (state == 10) {
    goToVoice(2);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 11;
  }
  
  if (state == 11) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
      state = 12;
    }
  }

  if (state == 12) {
    goToVoice(0);
      timeToMoveOn = millis()+int(random(30*1000, 60*1000));
    state = 13;
  }
  
  if (state == 13) {
    if (randomTime) {
      randomInsertStep();
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
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
    if (randomTime) {
      randomPlayChannel(50,500);
      if (millis() % 3 == 0) kaossPad.setEffects(random(0,1), 0.4);
    }
    // if (millis() > timeToMoveOn) state = 7; 
    if ((songLength/1000)>(10*60)) {
      println("song is more than 10 minutes old, ending it");
      state = 16;
    }
  }
  
  if (state == 16) {
    stateName = "the end";
    int channel = int(random(3));
    kaossPad.setEffects(random(0.5,1), random(0.6,1));
    delay(int(random(2000,8000)));
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
    song = 10;
    state = 0;
  }
}