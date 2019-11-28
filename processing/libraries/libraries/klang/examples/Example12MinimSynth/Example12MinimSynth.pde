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
    mSynth = new SynthesizerMinim();
    /* select instrument #2 */
    mSynth.instrument(2);
    /* set ADSR parameters for current instrument */
    mInstrument = mSynth.instrument();
    mInstrument.attack(0.5f);
    mInstrument.decay(1.0f);
    mInstrument.sustain(1.0f);
    mInstrument.release(0.5f);
}
void draw() {
    if (mIsPlaying) {
        int mColor = (mNote - Note.NOTE_A2) * 5 + 50;
        background(mColor);
    } else {
        background(255);
    }
    /* set get_attack for current instrument */
    final float mAttack = (float) mouseX / width;
    mInstrument.attack(mAttack);
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
