package model;

/**
 * @author Michal on 16.10.2018
 */

public class CppDllLibrary {
    static{
        System.loadLibrary("CppDllLibrary");
    }
    public native void convertToNegative(int[][] image);
    public native void convertToSepia(int[][] image, double sepiaIndicator);
}
