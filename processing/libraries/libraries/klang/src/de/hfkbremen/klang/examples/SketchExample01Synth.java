package de.hfkbremen.klang.examples;

import de.hfkbremen.klang.Synthesizer;
import processing.core.PApplet;

/**
 * this examples shows how to instantiate a synthesizer object and play notes with it.
 */
public class SketchExample01Synth extends PApplet {

    private final Synthesizer mSynth = Synthesizer.getSynth();

    public void settings() {
        size(640, 480);
    }

    public void setup() {
        background(255);
    }

    public void draw() {
        background(mSynth.isPlaying() ? 255 : 0);
    }

    public void mousePressed() {
        int mNote = 45 + (int) random(0, 12);
        mSynth.noteOn(mNote, 127);
    }

    public void mouseReleased() {
        mSynth.noteOff();
    }

    public static void main(String[] args) {
        PApplet.main(SketchExample01Synth.class.getName());
    }
}