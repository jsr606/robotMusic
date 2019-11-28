package de.hfkbremen.klang;

import com.jsyn.devices.javasound.JavaSoundAudioDevice;
import controlP5.ControlP5;
import controlP5.DropdownList;
import processing.core.PApplet;
import processing.core.PConstants;

public final class SynthUtil {

    private static final int NOTE_OFFSET = (69 - 12);

    public static float note_to_frequency(int pMidiNote, float pBaseFreq) {
        return pBaseFreq * (float) Math.pow(2.0, (pMidiNote / 12.0));
    }

    public static float note_to_frequency(int pMidiNote) {
        return note_to_frequency(pMidiNote - NOTE_OFFSET, 440); // A4 440 Hz
    }

    public static String note_to_string(int noteNum) {
        final String notes = "C C#D D#E F F#G G#A A#B ";
        int octave;
        String note;

        octave = noteNum / 12 - 1;
        note = notes.substring((noteNum % 12) * 2, (noteNum % 12) * 2 + 2);
        return PApplet.trim(note) + octave;
    }

    public static int frequency_to_note(int pFreq) {
        return frequency_to_note(pFreq, 440, NOTE_OFFSET);
    }

    public static int frequency_to_note(int pFreq, float pBaseFreq, int pOffset) {
        return (int) (Math.round(12 * log2(pFreq / pBaseFreq)) + pOffset);
    }

    public static double log2(double num) {
        return (Math.log(num) / Math.log(2));
    }

    public static int clamp127(int pValue) {
        return Math.max(0, Math.min(127, pValue));
    }

    public static void dumpMidiOutputDevices() {
        final String[] mOutputNames = MidiOut.availableOutputs();
        System.out.println("### Midi Output Devices\n");
        for (String mOutputName : mOutputNames) {
            System.out.println("  - " + mOutputName);
        }
    }

    public static void dumpMidiInputDevices() {
        final String[] mInputNames = MidiIn.availableInputs();
        System.out.println("### Midi Input Devices\n");
        for (String mOutputName : mInputNames) {
            System.out.println("  - " + mOutputName);
        }
    }

    public static void dumpAudioDeviceInfo(final JavaSoundAudioDevice mDevice) {
        System.out.println("********");
        System.out.println(mDevice.getDefaultOutputDeviceID());
        System.out.println(mDevice.getDefaultInputDeviceID());
        System.out.println("********");
        for (int i = 0; i < mDevice.getDeviceCount(); i++) {
            System.out.println(i + "\t" + mDevice.getDeviceName(i));
            System.out.println("\tout\t" + mDevice.getMaxOutputChannels(i));
            System.out.println("\tin\t" + mDevice.getMaxInputChannels(i));
        }
    }

    public static void buildSelectMidiDeviceMenu(ControlP5 controls) {
        final int mListWidth = 300, mListHeight = 300;

        DropdownList dl = controls.addDropdownList("Please select MIDI Device",
                                                   (controls.papplet.width - mListWidth) / 2,
                                                   (controls.papplet.height - mListHeight) / 2,
                                                   mListWidth,
                                                   mListHeight);

        //        dl.toUpperCase(true);
        dl.setItemHeight(16);
        dl.setBarHeight(16);
        dl.getCaptionLabel().align(PConstants.LEFT, PConstants.CENTER);

        final String[] mOutputNames = MidiOut.availableOutputs();
        for (int i = 0; i < mOutputNames.length; i++) {
            dl.addItem(mOutputNames[i], i);
        }
    }

    public static int constrain(int value, int min, int max) {
        if (value > max) {
            value = max;
        }
        if (value < min) {
            value = min;
        }
        return value;
    }

    public static void run(Class<? extends PApplet> T, String... pArgs) {
        String[] mArgs;
        mArgs = PApplet.concat(new String[]{"--sketch-path=" + System.getProperty("user.dir") + "/simulator"}, pArgs);
        mArgs = PApplet.concat(mArgs, new String[]{T.getName()});
        PApplet.main(mArgs);
    }

    public static void main(String[] args) {
        SynthUtil.dumpMidiOutputDevices();
    }
}
