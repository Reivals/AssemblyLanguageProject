package model;

import javafx.scene.control.Alert;

/**
 * @author Michal on 18.10.2018
 */

public class AlertClass {

    public static Alert sendAlert(String message, String header, Alert.AlertType alertType){
        Alert alert = new Alert(alertType);
        alert.setContentText(message);
        alert.setHeaderText(header);
        return alert;
    }


}
