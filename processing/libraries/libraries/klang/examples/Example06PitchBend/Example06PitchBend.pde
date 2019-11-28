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
    int mNote = Scale.note(Scale.MAJOR_CHORD_7, Note.NOTE_A3, (int) random(0, 10));
    mSynth.noteOn(mNote, 127);
}
void mouseReleased() {
    mSynth.noteOff();
    mSynth.pitch_bend(8192);
}
void mouseDragged() {
    mSynth.pitch_bend((int) map(mouseY, 0, height, 16383, 0));
}
