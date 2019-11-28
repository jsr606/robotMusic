package de.hfkbremen.klang.examples;

import com.jsyn.unitgen.MixerMono;
import com.jsyn.unitgen.SawtoothOscillator;
import com.jsyn.unitgen.UnitOscillator;
import de.hfkbremen.klang.InstrumentJSyn;
import de.hfkbremen.klang.Synthesizer;
import de.hfkbremen.klang.SynthesizerJSyn;
import processing.core.PApplet;

/**
 * this examples shows how to create a custom jsyn instrument. for further information on jsyn visit the website:
 * http://www.softsynth.com/jsyn/
 */
public class SketchExample20InstrumentJSynCustom extends PApplet {

    private InstrumentJSynCustom mInstrument;

    public void settings() {
        size(640, 480);
    }

    public void setup() {
        SynthesizerJSyn mSynth = new SynthesizerJSyn(Synthesizer.INSTRUMENT_EMPTY);
        mInstrument = new InstrumentJSynCustom(mSynth, 0);
        mInstrument.set_amp(0.8f);
    }

    public void draw() {
        background(255);
        noFill();
        stroke(0);
        ellipse(mouseX, mouseY, 10, 10);
        mInstrument.set_freq(map(mouseX, 0, width, 22.5f, 440.0f));
        mInstrument.set_freq_offset(map(mouseY, 0, height, -10.0f, 10.0f));
    }

    private class InstrumentJSynCustom extends InstrumentJSyn {

        private UnitOscillator mOsc1;
        private UnitOscillator mOsc2;
        private UnitOscillator mOsc3;
        private float mFreqOffset;

        public InstrumentJSynCustom(SynthesizerJSyn pSynth, int pID) {
            super(pSynth, pID);

            mOsc1 = new SawtoothOscillator();
            mSynth.add(mOsc1);
            mOsc1.start();

            mOsc2 = new SawtoothOscillator();
            mSynth.add(mOsc2);
            mOsc2.start();

            mOsc3 = new SawtoothOscillator();
            mSynth.add(mOsc3);
            mOsc3.start();

            MixerMono mMixerMono = new MixerMono(3);
            mOsc1.output.connect(mMixerMono.input.getConnectablePart(0));
            mOsc2.output.connect(mMixerMono.input.getConnectablePart(1));
            mOsc3.output.connect(mMixerMono.input.getConnectablePart(2));
            mMixerMono.amplitude.set(0.5f);

            mMixerMono.output.connect(0, mLineOut.input, 0);
            mMixerMono.output.connect(0, mLineOut.input, 1);
        }

        public void set_amp(float pAmp) {
            mAmp = pAmp;
            mOsc1.amplitude.set(mAmp * 0.6);
            mOsc2.amplitude.set(mAmp * 0.6);
            mOsc3.amplitude.set(mAmp * 1.0);
        }

        public void set_freq(float freq) {
            mFreq = freq;
            mOsc1.frequency.set(mFreq);
            mOsc2.frequency.set(mFreq + mFreqOffset);
            mOsc3.frequency.set(mFreq / 2 - mFreqOffset);
        }

        public void set_freq_offset(float freq_offest) {
            mFreqOffset = freq_offest;
        }
    }

    public static void main(String[] args) {
        PApplet.main(SketchExample20InstrumentJSynCustom.class.getName());
    }
}
