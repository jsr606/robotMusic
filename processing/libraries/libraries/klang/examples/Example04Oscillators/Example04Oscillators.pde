import de.hfkbremen.klang.*; 
import controlP5.*; 
import ddf.minim.*; 
import com.jsyn.unitgen.*; 


Synthesizer mSynth;
Instrument mInstrument;
boolean mIsPlaying = false;
int mNote;
void settings() {
    size(640, 480);
}
void setup() {
    background(255);
    mSynth = new SynthesizerJSyn();
    /* select instrument #2 */
    mInstrument = mSynth.instrument(2);
}
void draw() {
    if (mIsPlaying) {
        int mColor = (mNote - Note.NOTE_A2) * 5 + 50;
        background(mColor);
    } else {
        background(255);
    }
}
void keyPressed() {
    if (key == ' ') {
        if (mIsPlaying) {
            mSynth.noteOff();
        } else {
            mNote = Scale.note(Scale.MAJOR_CHORD_7, Note.NOTE_A2, (int) random(0, 10));
            mSynth.noteOn(mNote, 127);
        }
        mIsPlaying = !mIsPlaying;
    }
    if (key == '1') {
        mInstrument.osc_type(Instrument.SINE);
    }
    if (key == '2') {
        mInstrument.osc_type(Instrument.TRIANGLE);
    }
    if (key == '3') {
        mInstrument.osc_type(Instrument.SAWTOOTH);
    }
    if (key == '4') {
        mInstrument.osc_type(Instrument.SQUARE);
    }
    if (key == '5') {
        mInstrument.osc_type(Instrument.NOISE);
    }
}
