package de.hfkbremen.klang;

import ddf.minim.AudioOutput;
import ddf.minim.Minim;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

import static de.hfkbremen.klang.Instrument.NUMBER_OF_OSCILLATORS;
import static de.hfkbremen.klang.SynthUtil.clamp127;
import static de.hfkbremen.klang.SynthUtil.note_to_frequency;

public class SynthesizerMinim extends Synthesizer {

    private static final boolean USE_AMP_FRACTION = false;
    private final ArrayList<Instrument> mInstruments;
    private final Timer mTimer;
    private int mInstrumentID;
    private boolean mIsPlaying = false;

    public SynthesizerMinim() {
        Minim mMinim = new Minim(this);
        AudioOutput mOut = mMinim.getLineOut(Minim.MONO, 2048);
        mTimer = new Timer();

        mInstruments = new ArrayList<>();
        for (int i = 0; i < NUMBERS_OF_INSTRUMENTS; i++) {
            mInstruments.add(new InstrumentMinim(mMinim, i));
            mInstruments.get(i).osc_type(i % NUMBER_OF_OSCILLATORS);
            ((InstrumentMinim) mInstruments.get(i)).set_amp(1.0f);
        }
    }

    public void noteOn(int note, int velocity, float duration) {
        noteOn(note, velocity);
        TimerTask mTask = new NoteOffTask();
        mTimer.schedule(mTask, (long) (duration * 1000));
    }

    public void noteOn(int note, int velocity) {
        mIsPlaying = true;
        final float mFreq = note_to_frequency(clamp127(note));
        float mAmp = clamp127(velocity) / 127.0f;
        if (USE_AMP_FRACTION) {
            mAmp /= (float) NUMBERS_OF_INSTRUMENTS;
        }
        if (mInstruments.get(getInstrumentID()) instanceof InstrumentMinim) {
            InstrumentMinim mInstrument = (InstrumentMinim) mInstruments.get(getInstrumentID());
            mInstrument.noteOn(mFreq, mAmp);
        }
    }

    public void noteOff(int note) {
        noteOff();
    }

    public void noteOff() {
        if (mInstruments.get(getInstrumentID()) instanceof InstrumentMinim) {
            InstrumentMinim mInstrument = (InstrumentMinim) mInstruments.get(getInstrumentID());
            mInstrument.noteOff();
            mIsPlaying = false;
        }
    }

    public void control_change(int pCC, int pValue) {
    }

    public void pitch_bend(int pValue) {
    }

    public boolean isPlaying() {
        return mIsPlaying;
    }

    public Instrument instrument(int pInstrumentID) {
        mInstrumentID = pInstrumentID;
        return instruments().get(mInstrumentID);
    }

    public Instrument instrument() {
        return instruments().get(mInstrumentID);
    }

    public ArrayList<? extends Instrument> instruments() {
        return mInstruments;
    }

    private int getInstrumentID() {
        return Math.max(mInstrumentID, 0) % mInstruments.size();
    }

    public class NoteOffTask extends TimerTask {

        public void run() {
            noteOff();
        }
    }
}
