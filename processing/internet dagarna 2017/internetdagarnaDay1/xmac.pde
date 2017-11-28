// press 6 for this song

void xmac() { 
  if (state == 0) {
    currentSong = 3;
    songName = "xmac";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();
    randomFreq = 10000;

    scaleKeyNames.clear();
    scaleKeyNames.add("V");
    scaleKeyNames.add("V");
    scaleKeyNames.add("V");
    scaleKeyNames.add("V");
    scaleKeyNames.add("SPACE");
    makeScale();

    kaossPad.setPreset(0);
    kaossPad.setEffects(0.2, 0.2);
    kaossPad.tapTempo(108, 12);

    goToVoice(1);
    timeToMoveOn = millis()+int(random(140*1000, 150*1000));
    state = 1;
  }

  if (state == 1) {
    if (randomTime) {
      randomPlayChannel(10, 50);
      kaossPad.playWithEffects(10,350);
      kaossPad.setEffects(0.2, 0.2);
    }
    if (millis() > timeToMoveOn) state = 2;
    // wait for it
  }

  if (state == 2) {
    goToVoice(0);
    timeToMoveOn = millis()+int(random(100*1000, 200*1000));
    state = 3;
  }

  if (state == 3) {
    if (randomTime) {
      randomInsertStep();
      randomPlayChannel(50, 500);
      if (millis()%5 == 0) {
        kaossPad.playWithEffects(15,350);
        kaossPad.setEffects(0.2, 0.2);
      }
    }
    if (millis() > timeToMoveOn) {
      kaossPad.setEffects(0.8, 0.6);
      delay(2000);
      state = 4;
    }
    stateName = "inserting and playing";
  }

  if (state == 4) {
    stateName = "end";
    enableChannel(2, false);
    delay(int(random(5000, 7000)));
    enableChannel(1, false);
    delay(int(random(5000, 7000)));
    enableChannel(0, false);
    clickKey(64);
    state = 5;
  }

  if (state == 5) {
    println("the song has ended");
    song = 7;
    state = 0;
  }
}