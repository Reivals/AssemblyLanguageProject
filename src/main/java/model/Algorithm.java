package model;

import javafx.scene.control.Alert;

/**
 * @author Michal on 17.10.2018
 */

public class Algorithm extends TimeComparable {
    private CDllLibrary cDllLibrary;
    private AssemblerDllLibrary assemblerDllLibrary;

    public Algorithm(){
        cDllLibrary = new CDllLibrary();
        assemblerDllLibrary = new AssemblerDllLibrary();
    }


    public void runAlgorithm(String algorithmName, int[][] array, double sepiaIndicator) {
        if (algorithmName.equals("Negative C++")) {
            cDllLibrary.convertToNegative(array);

        } else if (algorithmName.equals("Negative assembler")) {
            assemblerDllLibrary.convertToNegative(array,array[0].length,array.length);

        } else if (algorithmName.equals("Sepia C++")) {
            if(sepiaIndicator < 20 || sepiaIndicator > 40){
                AlertClass.sendAlert("Sepia indicator must have value between <20;40>","Information", Alert.AlertType.INFORMATION).show();
            }
            cDllLibrary.convertToSepia(array, sepiaIndicator);

        } else if (algorithmName.equals("Sepia assember")) {
            if(sepiaIndicator < 20 || sepiaIndicator > 40){
                AlertClass.sendAlert("Sepia indicator must have value between <20;40>","Information", Alert.AlertType.INFORMATION).show();
            }
            assemblerDllLibrary.convertToSepia(array,array[0].length,array.length);
        }
    }


}
