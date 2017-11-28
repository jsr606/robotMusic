//press 3 for this song

public void greatballad() {
  
  if (state == 0) {
    currentSong = 5;
    songName = "greatballad";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();
    
    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("X");
    scaleKeyNames.add("C");
    scaleKeyNames.add("B");
    scaleKeyNames.add("N");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("Z");
    scaleKeyNames.add("Z");
    makeScale();
    
    kaossPad.setPreset(1);
    kaossPad.setEffects(0.3f,0.3f);
    kaossPad.tapTempo(94,8);
    
    goToVoice(1);

    timeToMoveOn = millis()+PApplet.parseInt(random(120*1000, 130*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+PApplet.parseInt(random(70*1000, 80*1000));
      state = 2;
    }
  }

  if (state == 2) {
    goToVoice(0);
    state = 3;
  }

  if (state == 3) {
    if (randomTime) {
      randomPlayChannel(0, 700);
      if (millis()%3 == 0) kaossPad.setEffects(random(0.5f,1),random(0,0.5f));
    }
    if (millis() > timeToMoveOn) {
      state = 6;
    }
  }

 
  if (state == 6) {
    goToVoice(1);
    kaossPad.setEffects(0.6f,0.3f);
    timeToMoveOn = millis()+PApplet.parseInt(random(110*1000, 120*1000));
    state = 7;
  }

  if (state == 7) {
    if (randomTime) randomInsertStep();
    if (millis() > timeToMoveOn) {
      timeToMoveOn = millis()+PApplet.parseInt(random(120*1000, 130*1000));
      state = 8;
    }
  }


  if (state == 8) {
    stateName = "random play V0";
    if (randomTime) {
      randomPlayChannel(50,500);
      if (millis()%3 == 0) kaossPad.setEffects(random(0.5f,1),random(0,0.5f));
    }
    // if (millis() > timeToMoveOn) state = 7; 
    if ((songLength/1000)>(12*60)) {
      println("song is more than 12 minutes old, ending it");
      state = 9;
    }
  }
  
  if (state == 9) {
    stateName = "the end";
    int channel = PApplet.parseInt(random(3));
    kaossPad.setEffects(random(0.5f,1),random(0.8f,1));
    delay(PApplet.parseInt(random(10000,20000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0 ; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 10;
    }
  }
  
  if (state == 10) {
    println("the song has ended");
    song = 4;
    state = 0;
  }
  
}