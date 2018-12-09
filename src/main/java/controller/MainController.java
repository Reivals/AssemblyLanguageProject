package controller;

import com.jfoenix.controls.JFXButton;
import com.jfoenix.controls.JFXTextField;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.embed.swing.SwingFXUtils;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ListView;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.stage.FileChooser;
import javafx.stage.Window;
import model.AlertClass;
import model.Algorithm;
import model.ImageConverter;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Michal on 16.10.2018
 */

public class MainController {
    private static ObservableList<String> observableArray;
    private static ObservableList<String> observableMessages;
    static{
        observableArray = FXCollections.observableArrayList("Negative C++", "Negative assembler",
                "Sepia C++", "Sepia assember");
        observableMessages = FXCollections.observableArrayList();
    }

    @FXML
    private JFXTextField sepiaIndicatorTextField;

    private Algorithm algorithm = new Algorithm();

    private File inputFile;

    @FXML
    private ImageView inputImage;

    @FXML
    private ImageView outputImage;

    @FXML
    private ChoiceBox<String> operationChoiceBox;

    @FXML
    private JFXButton executeButton;

    @FXML
    private JFXButton chooseInputImageButton;

    @FXML
    private ListView<String> informationListView;

    @FXML
    public void initialize(){
        informationListView.setItems(observableMessages);
        inputImage.preserveRatioProperty();
        operationChoiceBox.setItems(observableArray);
        operationChoiceBox.getSelectionModel().selectFirst();

        operationChoiceBox.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<String>() {
            public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
                if(newValue.equals("Sepia C++") || newValue.equals("Sepia assember")){
                    sepiaIndicatorTextField.setVisible(true);
                } else {
                    sepiaIndicatorTextField.setVisible(false);
                }
            }
        });

        sepiaIndicatorTextField.textProperty().addListener(new ChangeListener<String>() {
            public void changed(ObservableValue<? extends String> observable, String oldValue, String newValue) {
                if (!newValue.matches("\\d{0,7}([\\.]\\d{0,4})?")) {
                    sepiaIndicatorTextField.setText(oldValue);
                }
            }
        });
}

    @FXML
    void chooseInputImageButtonClicked(ActionEvent event) throws IOException {
        FileChooser chooser = new FileChooser();
        chooser.setTitle("Please select your image");
        Window window = ((JFXButton)event.getSource()).getScene().getWindow();
        inputFile = chooser.showOpenDialog(window);
        if(inputFile != null){
            Image image = new Image(inputFile.toURI().toString());
            if(ImageIO.read(inputFile) == null){
                AlertClass.sendAlert("Wrong file extention!","ERROR",Alert.AlertType.ERROR).show();
                inputFile=null;
            } else{
                inputImage.setImage(image);
            }
        }
    }

    @FXML
    void executeButtonClicked() {
        if(inputFile == null){
            AlertClass.sendAlert("Image is not selected!", "ERROR", Alert.AlertType.ERROR).show();
        }else{
            long startTime = System.nanoTime();
            try{
                BufferedImage bufferedImage = performActionOnImage(inputFile);
                long endTime = System.nanoTime();
                if(bufferedImage != null){
                    outputImage.setImage(SwingFXUtils.toFXImage(bufferedImage, null));
                }
                observableMessages.add("Wykonano \"" + operationChoiceBox.getSelectionModel().getSelectedItem() + "\" w czasie " +
                        Long.toString(((endTime-startTime)/1000000)) + "ms.");
            } catch(Exception e){
                observableMessages.add("Nie wykonano \"" + operationChoiceBox.getSelectionModel().getSelectedItem() + "\"");
            }

        }

    }

    public BufferedImage performActionOnImage (File file) throws Exception {
        BufferedImage bufferedImage;
        try {
            bufferedImage = convertFileToBufferImage(file);
        } catch (IOException e) {
            AlertClass.sendAlert("Cannot perform this action!", "ERROR", Alert.AlertType.ERROR).show();
            throw new Exception("Error occured");
        }

        int pixels[][] = ImageConverter.converToArrayOfPixels(bufferedImage);
        if(sepiaIndicatorTextField.getText().equals("")){
            sepiaIndicatorTextField.setText("32");
        }
        algorithm.runAlgorithm(operationChoiceBox.getSelectionModel().getSelectedItem(),pixels,Double.parseDouble(sepiaIndicatorTextField.getText()));
        return ImageConverter.getImageFromArray(convert2DArrayTo1D(pixels),bufferedImage.getWidth(),bufferedImage.getHeight());
    }

    private BufferedImage convertFileToBufferImage(File file) throws IOException {
        return ImageIO.read(file);
    }

    private int[] convert2DArrayTo1D(int [][] pixels){
        List<Integer> list = new ArrayList<Integer>();
        for(int i = 0; i < pixels.length; i++) {
            for(int j=0; j < pixels[0].length;j++){
                list.add(new Integer(pixels[i][j])); // java.util.Arrays
            }
        }
        int pixels2D[] = new int[list.size()];
        Integer[] bar = list.toArray(new Integer[list.size()]);
        for(int i=0;i<bar.length;i++){
            pixels2D[i]=bar[i].intValue();
        }
        return pixels2D;
    }

}


