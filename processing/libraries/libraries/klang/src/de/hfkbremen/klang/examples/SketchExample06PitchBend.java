package de.hfkbremen.klang.examples;

import de.hfkbremen.klang.Note;
import de.hfkbremen.klang.Scale;
import de.hfkbremen.klang.Synthesizer;
import processing.core.PApplet;

/**
 * this examples shows how use pitch bending e.g offsetting the actual frequency.
 */
public class SketchExample06PitchBend extends PApplet {

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
        int mNote = Scale.note(Scale.MAJOR_CHORD_7, Note.NOTE_A3, (int) random(0, 10));
        mSynth.noteOn(mNote, 127);
    }

    public void mouseReleased() {
        mSynth.noteOff();
        mSynth.pitch_bend(8192);
    }

    public void mouseDragged() {
        mSynth.pitch_bend((int) map(mouseY, 0, height, 16383, 0));
    }

    public static void main(String[] args) {
        PApplet.main(SketchExample06PitchBend.class.getName());
    }
}
