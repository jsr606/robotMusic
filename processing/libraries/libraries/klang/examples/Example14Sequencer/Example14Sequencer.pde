import de.hfkbremen.klang.*; 
import controlP5.*; 
import ddf.minim.*; 
import com.jsyn.unitgen.*; 


static final int NO = -1;
Synthesizer mSynth;
int mNote;
Beat mBeat;
final int[] mSteps = {
        0, NO, 12, NO,
        0, NO, 12, NO,
        0, NO, 12, NO,
        0, NO, 12, NO,
        3, 3, 15, 15,
        3, 3, 15, 15,
        5, 5, 17, 17,
        5, 5, 17, 17
};
void settings() {
    size(640, 480);
}
void setup() {
    mSynth = new SynthesizerJSyn();
    mBeat = new Beat(this);
    mBeat.bpm(120 * 4);
}
void draw() {
    background(mNote * 2);
}
void mousePressed() {
    mBeat.bpm((float) mouseX / width * 200 * 4);
}
void beat(int pBeat) {
    int mStep = mSteps[pBeat % mSteps.length];
    if (mStep != NO) {
        mNote = Scale.note(Scale.HALF_TONE, Note.NOTE_C4, mStep);
        mSynth.noteOn(mNote, 127);
    } else {
        mSynth.noteOff();
    }
}
