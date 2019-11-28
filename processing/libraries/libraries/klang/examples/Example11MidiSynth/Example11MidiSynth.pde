import de.hfkbremen.klang.*; 
import controlP5.*; 
import ddf.minim.*; 
import com.jsyn.unitgen.*; 


Synthesizer mSynth;
boolean mIsPlaying = false;
int mNote = Note.NOTE_A2;
int mInstrument = 0;
void settings() {
    size(640, 480);
}
void setup() {
    background(255);
    SynthUtil.dumpMidiOutputDevices();
    mSynth = Synthesizer.getSynth("midi", "IAC-Driver"); // name of an available midi out device
}
void draw() {
    if (mIsPlaying) {
        int mColor = (mNote - Note.NOTE_A2) * 5 + 50;
        background(mColor);
    } else {
        background(255);
    }
}
void mouseMoved() {
    mSynth.control_change(SynthesizerMidi.CC_MODULATION, (int) map(mouseX, 0, width, 0, 127));
    mSynth.pitch_bend((int) map(mouseY, 0, height, 16383, 0));
}
void keyPressed() {
    if (!mIsPlaying) {
        mNote = Scale.note(Scale.MAJOR_CHORD_7, Note.NOTE_A2, (int) random(0, 10));
        mSynth.instrument(mInstrument);
        mSynth.noteOn(mNote, 127);
    } else {
        mSynth.noteOff();
    }
    mIsPlaying = !mIsPlaying;
}
