package de.hfkbremen.klang;

import com.jsyn.devices.javasound.JavaSoundAudioDevice;
import com.jsyn.engine.SynthesisEngine;
import com.jsyn.unitgen.LineOut;
import com.softsynth.shared.time.TimeStamp;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

import static de.hfkbremen.klang.Instrument.NUMBER_OF_OSCILLATORS;
import static de.hfkbremen.klang.SynthUtil.clamp127;
import static de.hfkbremen.klang.SynthUtil.note_to_frequency;
import static processing.core.PApplet.constrain;

public class SynthesizerJSyn extends Synthesizer {

    private static final boolean USE_AMP_FRACTION = false;
    private final SynthesisEngine mSynth;
    private final LineOut mLineOut;
    private final ArrayList<InstrumentJSyn> mInstruments;
    private final Timer mTimer;
    private int mInstrumentID;
    private boolean mIsPlaying = false;

    public SynthesizerJSyn() {
        this(INSTRUMENT_WITH_OSCILLATOR_ADSR);
    }

    public SynthesizerJSyn(int pDefaultInstrumentType) {
        mSynth = new SynthesisEngine();
        prepareExitHandler();

        mLineOut = new LineOut();
        mSynth.add(mLineOut);
        mLineOut.start();

        mInstruments = new ArrayList<>();
        for (int i = 0; i < NUMBERS_OF_INSTRUMENTS; i++) {
            final InstrumentJSyn mInstrumentJSyn;
            switch (pDefaultInstrumentType) {
                case INSTRUMENT_EMPTY:
                    mInstrumentJSyn = new InstrumentJSyn(this, i);
                    break;
                case INSTRUMENT_WITH_OSCILLATOR:
                    mInstrumentJSyn = new InstrumentJSynOscillator(this, i);
                    break;
                case INSTRUMENT_WITH_OSCILLATOR_ADSR:
                    mInstrumentJSyn = new InstrumentJSynOscillatorADSR(this, i);
                    break;
                case INSTRUMENT_WITH_OSCILLATOR_ADSR_FILTER_LFO:
                    mInstrumentJSyn = new InstrumentJSynOscillatorADSRFilterLFO(this, i);
                    break;
                default:
                    mInstrumentJSyn = new InstrumentJSynOscillatorADSR(this, i);
            }
            mInstrumentJSyn.osc_type(i % NUMBER_OF_OSCILLATORS);
            mInstrumentJSyn.set_amp(1.0f);
            mInstruments.add(mInstrumentJSyn);
        }
        mInstrumentID = 0;

        final JavaSoundAudioDevice mDevice = new JavaSoundAudioDevice();
        SynthUtil.dumpAudioDeviceInfo(mDevice);
        mSynth.start(44100, mDevice.getDefaultInputDeviceID(), 2, mDevice.getDefaultOutputDeviceID(), 2);

        mTimer = new Timer();
    }

    public SynthesisEngine synth() {
        return mSynth;
    }

    public LineOut line_out() {
        return mLineOut;
    }

    private void prepareExitHandler() {
        Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
            public void run() {
                System.out.println("### shutting down JSyn");
                mSynth.stop();
            }
        }));
    }

    public void noteOn(int note, int velocity, float duration) {
        TimerTask mTask = new NoteOffTask();
        mTimer.schedule(mTask, (long) (duration * 1000));
        mIsPlaying = true;
        final float mFreq = note_to_frequency(clamp127(note));
        float mAmp = clamp127(velocity) / 127.0f;
        if (USE_AMP_FRACTION) {
            mAmp /= (float) NUMBERS_OF_INSTRUMENTS;
        }
        TimeStamp mOnTime = new TimeStamp(mSynth.getCurrentTime());
        TimeStamp mOffTime = mOnTime.makeRelative(duration);
        InstrumentJSyn mInstrument = getInstrument(getInstrumentID());
        mInstrument.set_amp(mAmp);
        mInstrument.set_freq(mFreq);
        if (mInstrument instanceof InstrumentJSynOscillatorADSR) {
            InstrumentJSynOscillatorADSR mInstrumentJSynBasic = (InstrumentJSynOscillatorADSR) mInstrument;
            mInstrumentJSynBasic.env().start(mOnTime);
            mInstrumentJSynBasic.env().stop(mOffTime);
            mInstrumentJSynBasic.trigger();
        }
    }

    public void noteOn(int note, int velocity) {
        mIsPlaying = true;
        final float mFreq = note_to_frequency(clamp127(note));
        float mAmp = clamp127(velocity) / 127.0f;
        if (USE_AMP_FRACTION) {
            mAmp /= (float) NUMBERS_OF_INSTRUMENTS;
        }
        getInstrument(getInstrumentID()).noteOn(mFreq, mAmp);
    }

    public void noteOff(int note) {
        noteOff();
    }

    public void noteOff() {
        mIsPlaying = false;
        getInstrument(getInstrumentID()).noteOff();
    }

    public void control_change(int pCC, int pValue) {
        // not used in jsyn klang
    }

    public void pitch_bend(int pValue) {
        final float mRange = 110;
        final float mValue = mRange * ((float) (constrain(pValue, 0, 16383) - 8192) / 8192.0f);
        mInstruments.get(getInstrumentID()).pitch_bend(mValue);
    }

    public boolean isPlaying() {
        return mIsPlaying;
    }

    public final Instrument instrument(int pInstrumentID) {
        mInstrumentID = pInstrumentID;
        return instruments().get(mInstrumentID);
    }

    public Instrument instrument() {
        return mInstruments.get(mInstrumentID);
    }

    public ArrayList<? extends Instrument> instruments() {
        return mInstruments;
    }

    public InstrumentJSyn getInstrument(int pInstrumentID) {
        return mInstruments.get(mInstrumentID);
    }

    public InstrumentJSynOscillatorADSR getInstrumentBasic(int pInstrumentID) {
        if (mInstruments.get(mInstrumentID) instanceof InstrumentJSynOscillatorADSR) {
            return (InstrumentJSynOscillatorADSR) mInstruments.get(mInstrumentID);
        } else {
            return null;
        }
    }

    public InstrumentJSynOscillatorADSRFilterLFO getInstrumentFilterLFO(int pInstrumentID) {
        if (mInstruments.get(mInstrumentID) instanceof InstrumentJSynOscillatorADSRFilterLFO) {
            return (InstrumentJSynOscillatorADSRFilterLFO) mInstruments.get(mInstrumentID);
        } else {
            return null;
        }
    }

    private int getInstrumentID() {
        return Math.max(mInstrumentID, 0) % mInstruments.size();
    }

    public class NoteOffTask extends TimerTask {

        public void run() {
            mIsPlaying = false;
        }
    }
}
