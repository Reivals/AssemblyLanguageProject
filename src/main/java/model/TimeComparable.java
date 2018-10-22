package model;

/**
 * @author Michal on 16.10.2018
 */

public abstract class TimeComparable {

    protected Long startTime;
    protected Long endTime;

    protected void startMeasuring(){
        startTime = System.nanoTime();
    }
    protected void endMeasuring(){
        endTime = System.nanoTime();
    }

    protected Long getMeasuredTime() throws Exception {
        if(startTime != null && endTime != null)
            return endTime-startTime;
        else
            throw new Exception("Start/End time are not initialized!");
    }
}
