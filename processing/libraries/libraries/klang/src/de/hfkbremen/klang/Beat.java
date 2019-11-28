package de.hfkbremen.klang;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Timer;
import java.util.TimerTask;
import processing.core.PApplet;

public class Beat {

    private int mBeat = -1;

    private Method mMethod = null;

    private PApplet mPApplet;

    private final Timer mTimer;

    private TimerTask mTask;

    public Beat(PApplet pPApplet, int pBPM) {
        this(pPApplet);
        bpm(pBPM);
    }

    public Beat(PApplet pPApplet) {
        mPApplet = pPApplet;
        try {
            mMethod = pPApplet.getClass().getDeclaredMethod("beat", Integer.TYPE);
        } catch (NoSuchMethodException | SecurityException ex) {
            ex.printStackTrace();
        }
        mTimer = new Timer();
    }

    public void bpm(float pBPM) {
        final int mPeriod = (int) (60.0f / pBPM * 1000.0f);
        if (mTask != null) {
            mTask.cancel();
        }
        mTask = new BeatTimerTask();
        mTimer.scheduleAtFixedRate(mTask, 1000, mPeriod);
    }

    public class BeatTimerTask extends TimerTask {

        @Override
        public void run() {
            try {
                mBeat++;
                mMethod.invoke(mPApplet, mBeat);
            } catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException ex) {
                ex.printStackTrace();
            }
        }
    }
}
