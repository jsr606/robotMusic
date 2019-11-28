import de.hfkbremen.klang.*; 
import controlP5.*; 
import ddf.minim.*; 
import com.jsyn.unitgen.*; 


final Synthesizer mSynth = Synthesizer.getSynth();
void settings() {
    size(640, 480);
}
void setup() {
    background(255);
}
void draw() {
    background(mSynth.isPlaying() ? 255 : 0);
}
void mousePressed() {
    int mNote = 45 + (int) random(0, 12);
    mSynth.noteOn(mNote, 127);
}
void mouseReleased() {
    mSynth.noteOff();
}
