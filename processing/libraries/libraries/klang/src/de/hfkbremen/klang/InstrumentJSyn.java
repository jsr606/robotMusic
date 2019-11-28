package de.hfkbremen.klang;

import com.jsyn.engine.SynthesisEngine;
import com.jsyn.unitgen.LineOut;

public class InstrumentJSyn extends Instrument {

    protected final SynthesisEngine mSynth;
    protected final LineOut mLineOut;
    protected float mAmp;
    protected float mFreq;

    public InstrumentJSyn(SynthesizerJSyn mSynthesizerJSyn, int pID) {
        super(pID);
        mSynth = mSynthesizerJSyn.synth();
        mLineOut = mSynthesizerJSyn.line_out();
        mAmp = 0.9f;
        mFreq = 0.0f;
    }

    public void set_amp(float pAmp) {
        mAmp = pAmp;
    }

    public void set_freq(float freq) {
        mFreq = freq;
    }

    public void noteOff() {
        set_amp(0);
    }

    public void noteOn(float pFreq, float pAmp) {
        set_amp(pAmp);
        set_freq(pFreq);
    }

    @Override
    public void osc_type(int pOsc) {

    }

    @Override
    public int get_osc_type() {
        return 0;
    }

    @Override
    public void lfo_amp(float pLFOAmp) {

    }

    @Override
    public float get_lfo_amp() {
        return 0;
    }

    @Override
    public void lfo_freq(float pLFOFreq) {

    }

    @Override
    public float get_lfo_freq() {
        return 0;
    }

    @Override
    public void filter_q(float f) {

    }

    @Override
    public float get_filter_q() {
        return 0;
    }

    @Override
    public void filter_freq(float f) {

    }

    @Override
    public float get_filter_freq() {
        return 0;
    }

    @Override
    public void pitch_bend(float freq_offset) {

    }
}
