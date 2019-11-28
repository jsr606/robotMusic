package de.hfkbremen.klang.examples;

import de.hfkbremen.klang.Instrument;
import de.hfkbremen.klang.Note;
import de.hfkbremen.klang.Scale;
import de.hfkbremen.klang.Synthesizer;
import de.hfkbremen.klang.SynthesizerMinim;
import processing.core.PApplet;

/**
 * this examples shows how to use the minim library for sound synthesis ( note that the basic concept of sound synthesis
 * is very similar to the jsyn library )
 *
 * note: if running this sketch from processing PDE add `import ddf.minim.*;` to the imports.
 *
 */
public class SketchExample12MinimSynth extends PApplet {

    private Synthesizer mSynth;

    private Instrument mInstrument;

    private boolean mIsPlaying = false;

    private int mNote;

    public void settings() {
        size(640, 480);
    }

    public void setup() {
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

    public void draw() {
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

    public void keyPressed() {
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

    public static void main(String[] args) {
        PApplet.main(SketchExample12MinimSynth.class.getName());
    }
}
