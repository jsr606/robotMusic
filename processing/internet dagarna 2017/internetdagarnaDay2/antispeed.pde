//press 7 for this song

void antispeed() { 
  if (state == 0) {
    currentSong = 5;
    randomFreq = 7000;
    songName = "antispeed";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();

    scaleKeyNames.clear();
    scaleKeyNames.add("T");
    scaleKeyNames.add("U");
    scaleKeyNames.add("I");
    scaleKeyNames.add("P");
    scaleKeyNames.add("SPACE");
    scaleKeyNames.add("SPACE");
    makeScale();

    kaossPad.setPreset(1);
    kaossPad.setEffects(random(0.6, 1), random(0.6, 1));
    kaossPad.tapTempo(125, 8);

    goToVoice(0);

    timeToMoveOn = millis()+int(random(750*1000, 900*1000));
    state = 1;
  }
  if (state == 1) {
    if (randomTime) {
      // move to the top of the sequence
      clickKey(48);
      clickKey(34);
      clickKey(33);
      delay(100);
      clickKey(33);
      clickKey(34);
      randomPlayChannel(50, 100);
      clickKey(48);
      
      if (millis()%3 == 0) kaossPad.setEffects(random(0.6, 1), random(0.6, 1));
    }

    if (millis() > timeToMoveOn) state = 2;
  }

  if (state == 2) {
    stateName = "the end";
    int channel = int(random(3));
    kaossPad.setEffects(random(0.8, 1), random(0.8, 1));
    delay(int(random(10000, 20000)));
    enableChannel(channel, false);
    boolean allOff = true;
    for (int i = 0; i<3; i++) {
      if (channelOn[i] == true) allOff = false;
    }
    if (allOff) {
      clickKey(64);
      state = 3;
    }
  }

  if (state == 3) {
    println("the song has ended");
    song = 8;
    state = 0;
  }
}