import de.hfkbremen.klang.*; 
import controlP5.*; 
import ddf.minim.*; 
import com.jsyn.unitgen.*; 


InstrumentJSynCustom mInstrument;
void settings() {
    size(640, 480);
}
void setup() {
    SynthesizerJSyn mSynth = new SynthesizerJSyn(Synthesizer.INSTRUMENT_EMPTY);
    mInstrument = new InstrumentJSynCustom(mSynth, 0);
    mInstrument.set_amp(0.8f);
}
void draw() {
    background(255);
    noFill();
    stroke(0);
    ellipse(mouseX, mouseY, 10, 10);
    mInstrument.set_freq(map(mouseX, 0, width, 22.5f, 440.0f));
    mInstrument.set_freq_offset(map(mouseY, 0, height, -10.0f, 10.0f));
}
class InstrumentJSynCustom extends InstrumentJSyn {
    UnitOscillator mOsc1;
    UnitOscillator mOsc2;
    UnitOscillator mOsc3;
    float mFreqOffset;
    InstrumentJSynCustom(SynthesizerJSyn pSynth, int pID) {
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
    void set_amp(float pAmp) {
        mAmp = pAmp;
        mOsc1.amplitude.set(mAmp * 0.6);
        mOsc2.amplitude.set(mAmp * 0.6);
        mOsc3.amplitude.set(mAmp * 1.0);
    }
    void set_freq(float freq) {
        mFreq = freq;
        mOsc1.frequency.set(mFreq);
        mOsc2.frequency.set(mFreq + mFreqOffset);
        mOsc3.frequency.set(mFreq / 2 - mFreqOffset);
    }
    void set_freq_offset(float freq_offest) {
        mFreqOffset = freq_offest;
    }
}
