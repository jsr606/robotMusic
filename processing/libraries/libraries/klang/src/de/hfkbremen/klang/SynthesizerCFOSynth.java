package de.hfkbremen.klang;

import java.util.ArrayList;

import static de.hfkbremen.klang.SynthUtil.clamp127;

public class SynthesizerCFOSynth extends Synthesizer {

    public static final int PRESET_SAVE = 0;
    public static final int PRESET_RECALL = 1;
    public static final int IS_12_BIT = 3;
    public static final int CUTOFF = 4;
    public static final int ZERO_HZ_FM = 5;
    public static final int FM_OCTAVES = 6;
    public static final int PORTAMENTO = 8;
    public static final int FILTER_TYPE = 9;
    public static final int LFO1 = 10;
    public static final int SEMITONE1 = 11;
    public static final int DETUNE1 = 12;
    public static final int GAIN1 = 13;
    public static final int WAVEFORM1 = 14;
    public static final int FM1 = 15;
    public static final int FM1_OCTAVES = 16;
    public static final int FM1_SOURCE = 17;
    public static final int FM1_SHAPE = 18;
    public static final int FREQUENCY1 = 19;
    public static final int LFO2 = 20;
    public static final int SEMITONE2 = 21;
    public static final int DETUNE2 = 22;
    public static final int GAIN2 = 23;
    public static final int WAVEFORM2 = 24;
    public static final int FM2 = 25;
    public static final int FM2_OCTAVES = 26;
    public static final int FM2_SOURCE = 27;
    public static final int FM2_SHAPE = 28;
    public static final int FREQUENCY2 = 29;
    public static final int LFO3 = 30;
    public static final int SEMITONE3 = 31;
    public static final int DETUNE3 = 32;
    public static final int GAIN3 = 33;
    public static final int WAVEFORM3 = 34;
    public static final int FM3 = 35;
    public static final int FM3_OCTAVES = 36;
    public static final int FM3_SOURCE = 37;
    public static final int FM3_SHAPE = 38;
    public static final int FREQUENCY3 = 39;
    public static final int CUTOFF_MOD_AMOUNT = 70;
    public static final int CUTOFF_SOURCE = 72;
    public static final int ENV1_VELOCITY = 112;
    public static final int ENV1_ENABLE = 113;
    public static final int ENV1_ATTACK = 114;
    public static final int ENV1_DECAY = 115;
    public static final int ENV1_SUSTAIN = 116;
    public static final int ENV1_RELEASE = 117;
    public static final int ENV2_VELOCITY = 122;
    public static final int ENV2_ENABLE = 123;
    public static final int ENV2_ATTACK = 124;
    public static final int ENV2_DECAY = 125;
    public static final int ENV2_SUSTAIN = 126;
    public static final int ENV2_RELEASE = 127;
    private final MidiOut mMidiOut;
    private int mCurrentlyPlayingNote = -1;
    private int mChannel = 0;

    public SynthesizerCFOSynth(int pOutputID) {
        mMidiOut = new MidiOut(MidiOut.availableOutputs()[pOutputID]);
    }

    public SynthesizerCFOSynth(String pOutputname) {
        mMidiOut = new MidiOut(SynthesizerMidi.getProperDeviceName(pOutputname));
    }

    MidiOut midi() {
        return mMidiOut;
    }

    public void channel(int pChannel) {
        mChannel = pChannel;
    }

    public void sendController(int pController, int pValue) {
        mMidiOut.sendControllerChange(mChannel, clamp127(pController), clamp127(pValue));
    }

    public void sendNoteOn(int pNote, int pVelocity) {
        mCurrentlyPlayingNote = pNote;
        mMidiOut.sendNoteOn(mChannel, clamp127(pNote), clamp127(pVelocity));
    }

    public void sendNoteOff() {
        if (mCurrentlyPlayingNote > -1) {
            sendNoteOff(mCurrentlyPlayingNote, 0);
        }
    }

    public void sendNoteOff(int pNote, int pVelocity) {
        mCurrentlyPlayingNote = -1;
        mMidiOut.sendNoteOff(mChannel, clamp127(pNote), clamp127(pVelocity));
    }

    public int currently_playing_note() {
        return mCurrentlyPlayingNote;
    }

    public void noteOn(int note, int velocity, float duration) {
        sendNoteOn(note, velocity);
    }

    public void noteOn(int note, int velocity) {
        sendNoteOn(note, velocity);
    }

    public void noteOff(int note) {
        sendNoteOff(note, 0);
    }

    public void noteOff() {
        sendNoteOff(mCurrentlyPlayingNote, 0);
    }

    public void control_change(int pCC, int pValue) {
    }

    public void pitch_bend(int pValue) {
    }

    public boolean isPlaying() {
        return mCurrentlyPlayingNote != -1;
    }

    public Instrument instrument(int pInstrumentID) {
        return null;
    }

    public Instrument instrument() {
        return null;
    }

    public ArrayList<? extends Instrument> instruments() {
        return null;
    }
}
