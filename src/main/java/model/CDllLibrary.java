package model;

/**
 * @author Michal on 16.10.2018
 */

public class CDllLibrary {
    static{
        System.loadLibrary("CDllLibrary");
    }
    public native void convertToNegative(int[][] image);
    public native void convertToSepia(int[][] image, double sepiaIndicator);
}
