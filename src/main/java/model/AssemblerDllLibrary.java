package model;

/**
 * @author Michal on 17.10.2018
 */
public class AssemblerDllLibrary {
    static{
        System.loadLibrary("AssemblerDllLibrary");
    }

    public native void convertToNegative(int[][] image, int width, int height);
    public native void convertToSepia(int[][] image, int width, int height);
}
