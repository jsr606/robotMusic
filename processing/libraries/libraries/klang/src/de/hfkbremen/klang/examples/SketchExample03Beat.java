package de.hfkbremen.klang.examples;

import de.hfkbremen.klang.Beat;
import de.hfkbremen.klang.Note;
import de.hfkbremen.klang.Synthesizer;
import processing.core.PApplet;

/**
 this examples shows how to use a beat. once instantiated the beat object calls the `beat(int)` at a defined *beats per
 minute* (bpm).
 */
public class SketchExample03Beat extends PApplet {

    private final Synthesizer mSynth = Synthesizer.getSynth();
    private int mBeatCount;
    private int[] mNotes = {Note.NOTE_C3, Note.NOTE_C4, Note.NOTE_A2, Note.NOTE_A3};

    public void settings() {
        size(640, 480);
    }

    public void setup() {
        Beat mBeat = new Beat(this, 120);
    }

    public void draw() {
        background((mBeatCount % 2) * 255);
    }

    public void beat(int pBeatCount) {
        mBeatCount = pBeatCount;
        int mNote = mNotes[mBeatCount % mNotes.length];
        mSynth.noteOn(mNote, 127);
    }

    public static void main(String[] args) {
        PApplet.main(SketchExample03Beat.class.getName());
    }
}
