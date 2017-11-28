// press 6 for this song

void sushib() { 
  if (state == 0) {
    currentSong = 1;
    songName = "sushib";
    stateName = "loading...";
    loadSong(currentSong);
    startSong();
    randomFreq = 3000;

    scaleKeyNames.clear();
    scaleKeyNames.add("Z");
    scaleKeyNames.add("B");
    scaleKeyNames.add("Q");
    scaleKeyNames.add("T");
    makeScale();

    kaossPad.setPreset(1);
    kaossPad.setEffects(random(0.4,0.6), random(0.4,0.6));
    kaossPad.tapTempo(88, 8);

    goToVoice(2);
    timeToMoveOn = millis()+int(random(320*1000, 400*1000));
    state = 1;
  }

  if (state == 1) {
    if (randomTime) {
      randomPlayChannel(10, 200);
      if (millis() %2 == 0) kaossPad.setEffects(random(0.2,0.5), random(0.2,0.5));
    }
    if (millis() > timeToMoveOn) state = 2;
    // wait for it
  }

  if (state == 2) {
    stateName = "end";
    kaossPad.setEffects(random(0.4,0.9), random(0.4,0.8));
    enableChannel(2, false);
    delay(int(random(5000, 7000)));
    kaossPad.setEffects(random(0.5,1), random(0.5,0.9));
    enableChannel(1, false);
    delay(int(random(5000, 7000)));
    kaossPad.setEffects(random(0.8,1), random(0.8,1));
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