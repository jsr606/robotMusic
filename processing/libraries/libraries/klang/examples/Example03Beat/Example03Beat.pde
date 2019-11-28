import de.hfkbremen.klang.*; 
import controlP5.*; 
import ddf.minim.*; 
import com.jsyn.unitgen.*; 


final Synthesizer mSynth = Synthesizer.getSynth();
int mBeatCount;
int[] mNotes = {Note.NOTE_C3, Note.NOTE_C4, Note.NOTE_A2, Note.NOTE_A3};
void settings() {
    size(640, 480);
}
void setup() {
    Beat mBeat = new Beat(this, 120);
}
void draw() {
    background((mBeatCount % 2) * 255);
}
void beat(int pBeatCount) {
    mBeatCount = pBeatCount;
    int mNote = mNotes[mBeatCount % mNotes.length];
    mSynth.noteOn(mNote, 127);
}
