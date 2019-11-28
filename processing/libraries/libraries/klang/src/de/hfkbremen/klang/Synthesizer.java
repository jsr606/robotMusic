package de.hfkbremen.klang;

import controlP5.ControlP5;
import processing.core.PApplet;

import java.util.ArrayList;

public abstract class Synthesizer {

    public static final int INSTRUMENT_EMPTY = 0;
    public static final int INSTRUMENT_WITH_OSCILLATOR = 1;
    public static final int INSTRUMENT_WITH_OSCILLATOR_ADSR = 2;
    public static final int INSTRUMENT_WITH_OSCILLATOR_ADSR_FILTER_LFO = 3;

    public static final int NUMBERS_OF_INSTRUMENTS = 12;
    public static final String INSTRUMENT_STR = "instrument";
    public static final int GUI_ATTACK = 0;
    public static final int GUI_DECAY = 1;
    public static final int GUI_SUSTAIN = 2;
    public static final int GUI_RELEASE = 3;
    public static final int GUI_OSC = 4;
    public static final int GUI_LFO_AMP = 5;
    public static final int GUI_LFO_FREQ = 6;
    public static final int GUI_FILTER_Q = 7;
    public static final int GUI_FILTER_FREQ = 8;
    private static final int GUI_NUMBER_OF_ELEMENTS = 9;
    private static final String[] INSTRUMENT_FIELDS = new String[GUI_NUMBER_OF_ELEMENTS];

    static {
        INSTRUMENT_FIELDS[GUI_ATTACK] = "attack";
        INSTRUMENT_FIELDS[GUI_DECAY] = "decay";
        INSTRUMENT_FIELDS[GUI_SUSTAIN] = "sustain";
        INSTRUMENT_FIELDS[GUI_RELEASE] = "release";
        INSTRUMENT_FIELDS[GUI_OSC] = "osc_type";
        INSTRUMENT_FIELDS[GUI_LFO_AMP] = "lfo_amp";
        INSTRUMENT_FIELDS[GUI_LFO_FREQ] = "lfo_freq";
        INSTRUMENT_FIELDS[GUI_FILTER_Q] = "filter_q";
        INSTRUMENT_FIELDS[GUI_FILTER_FREQ] = "filter_freq";
    }

    /**
     * play a note
     *
     * @param note     pitch of note ranging from 0 to 127
     * @param velocity volume of note ranging from 0 to 127
     * @param duration duration in seconds before the note is turned off ( noteOff() ) again
     */
    public abstract void noteOn(int note, int velocity, float duration);

    /**
     * play a note
     *
     * @param note     pitch of note ranging from 0 to 127
     * @param velocity volume of note ranging from 0 to 127
     */
    public abstract void noteOn(int note, int velocity);

    /**
     * turn off a note
     *
     * @param note pitch of note to turn off
     */
    public abstract void noteOff(int note);

    /**
     * turns off the last played note.
     */
    public abstract void noteOff();

    public abstract void control_change(int pCC, int pValue);

    public abstract void pitch_bend(int pValue);

    public abstract boolean isPlaying();

    public abstract Instrument instrument(int pInstrumentID);

    public abstract Instrument instrument();

    public abstract ArrayList<? extends Instrument> instruments();

    public static Synthesizer getSynth() {
        return new SynthesizerJSyn(INSTRUMENT_WITH_OSCILLATOR_ADSR);
    }

    public static Synthesizer getSynth(String... pName) {
        if (pName[0].equalsIgnoreCase("minim")) {
            return new SynthesizerMinim();
        } else if (pName[0].equalsIgnoreCase("jsyn")) {
            return new SynthesizerJSyn(INSTRUMENT_WITH_OSCILLATOR_ADSR);
        } else if (pName[0].equalsIgnoreCase("jsyn-filter+lfo")) {
            return new SynthesizerJSyn(INSTRUMENT_WITH_OSCILLATOR_ADSR_FILTER_LFO);
        } else if (pName[0].equalsIgnoreCase("midi") && pName.length >= 2) {
            return new SynthesizerMidi(pName[1]);
        } else if (pName[0].equalsIgnoreCase("osc") && pName.length >= 2) {
            return new SynthesizerOSC(pName[1]);
        }
        return getSynth();
    }

    public static ControlP5 createInstrumentsGUI(PApplet p, Synthesizer mSynth) {
        return createInstrumentsGUI(p, mSynth, NUMBERS_OF_INSTRUMENTS);
    }

    public static ControlP5 createInstrumentsGUI(PApplet p, Synthesizer mSynth, int... mInstruments) {
        ControlP5 cp5 = new ControlP5(p);
        //        System.out.println("### creating instruments ");
        if (mSynth instanceof SynthesizerJSyn || mSynth instanceof SynthesizerMinim) {
            for (int i = 0; i < mInstruments.length; i++) {
                //                System.out.println("### creating instrument #" + i);
                final int mID = mInstruments[i];
                final String mInstrumentStr = INSTRUMENT_STR + mID;
                final Instrument mInstrument = mSynth.instrument(mID);
                cp5.addControllersFor(mInstrumentStr, mInstrument);
                //                for (int j = 0; j < GUI_NUMBER_OF_ELEMENTS; j++) {
                //                    System.out.println("found parameter " + INSTRUMENT_FIELDS[j] + ": " + cp5.get
                // (mInstrumentStr + "/" + INSTRUMENT_FIELDS[j]));
                //                }
                updateGUI(cp5, mInstrument);
                cp5.setPosition(10, 10 + i * 60, mInstrument);
            }
        }
        return cp5;
    }

    public static void updateGUI(ControlP5 cp5, final Instrument mInstrument, final int pField) {
        final String mInstrumentStr = INSTRUMENT_STR + mInstrument.ID() + "/" + INSTRUMENT_FIELDS[pField];
        if (cp5.get(mInstrumentStr) != null) {
            switch (pField) {
                case GUI_ATTACK:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_attack());
                    break;
                case GUI_DECAY:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_decay());
                    break;
                case GUI_SUSTAIN:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_sustain());
                    break;
                case GUI_RELEASE:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_release());
                    break;
                case GUI_OSC:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_osc_type());
                    break;
                case GUI_LFO_AMP:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_lfo_amp());
                    break;
                case GUI_LFO_FREQ:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_lfo_freq());
                    break;
                case GUI_FILTER_Q:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_filter_q());
                    break;
                case GUI_FILTER_FREQ:
                    cp5.get(mInstrumentStr).setValue(mInstrument.get_filter_freq());
                    break;
            }
        }
    }

    public static void updateGUI(ControlP5 cp5, final Instrument mInstrument) {
        for (int i = 0; i < GUI_NUMBER_OF_ELEMENTS; i++) {
            updateGUI(cp5, mInstrument, i);
        }
    }
}
