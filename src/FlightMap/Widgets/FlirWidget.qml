

/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick 2.4
import QtPositioning 5.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

import QGroundControl 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Palette 1.0
import QGroundControl.Vehicle 1.0
import QGroundControl.Controllers 1.0
import QGroundControl.FactSystem 1.0
import QGroundControl.FactControls 1.0

/// Flir page for controlling a Duo Pro R
Column {
    width: pageWidth
    spacing: ScreenTools.defaultFontPixelHeight * 0.25

    property bool _recording: false
    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    GridLayout {
        columns: 2
        columnSpacing: ScreenTools.defaultFontPixelWidth * 2
        rowSpacing: ScreenTools.defaultFontPixelHeight
        anchors.horizontalCenter: parent.horizontalCenter

        QGCLabel {
            text: qsTr("Kamera Mode")
        }
        QGCComboBox {
            //id: displayMode
            model: ["IR", "RGB", "PIP"]
            onActivated: {
                switch (currentIndex) {
                case 0:
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               13, //servo instance
                                               1000) //servo value in us
                    break
                case 1:
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               13, //servo instance
                                               1500) //servo value in us
                    break
                case 2:
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               13, //servo instance
                                               2000) //servo value in us
                    break
                }
            }
        }

        QGCLabel {
            text: qsTr("Foto/Video")
        }
        QGCSwitch {
            id: videoMode
            onCheckedChanged: {
                if (checked) {
                    //Video mode
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               12, //servo instance
                                               2000) //servo value in us
                } else {
                    //Photo mode & stop recording video
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               11, //servo instance
                                               1001) //servo value in us
                    _recording = false
                    _activeVehicle.sendCommand(_activeVehicle, //ID
                                               183, //MAV_CMD
                                               true, //showError
                                               12, //servo instance
                                               1000) //servo value in us
                }
            }
        }

        QGCLabel {
            text: qsTr("REC")
        }

        /*QGCButton { // Button to start/stop video recording and trigger a photo
            text: "REC"
            onClicked: if (videoMode.checked) {
                           if (_recording) { //stop recording
                               _activeVehicle.sendCommand(_activeVehicle, //ID
                                                          183, //MAV_CMD
                                                          true, //showError
                                                          11, //servo instance
                                                          1000); //servo value in us
                               _recording = false;
                           } else { //start recording
                               _activeVehicle.sendCommand(_activeVehicle, //ID
                                                          183, //MAV_CMD
                                                          true, //showError
                                                          11, //servo instance
                                                          2000); //servo value in us
                               _recording = true;
                           }
                       } else { //take photo
                           //_activeVehicle.sendCommand(_activeVehicle,203,true,0,0,0,0,1,0,0);
                           _activeVehicle.sendCommand(_activeVehicle, //ID
                                                      184, //repeat servo
                                                      true, //showError
                                                      11, //servo instance
                                                      2000, //servo value in us
                                                      1, //count
                                                      1) //time
                       }
        }*/

        Item {
            anchors.margins: ScreenTools.defaultFontPixelHeight / 2
            height: ScreenTools.defaultFontPixelHeight * 2
            width: height
            Layout.alignment: Qt.AlignHCenter
            Rectangle {
                id: recordBtnBackground
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: height
                radius: height
                color: "red"
                SequentialAnimation on opacity {
                    running: videoMode.checked
                             && _recording //change this to video recording running
                    loops: Animation.Infinite
                    PropertyAnimation {
                        to: 0.5
                        duration: 500
                    }
                    PropertyAnimation {
                        to: 1.0
                        duration: 500
                    }
                }
            }
            QGCColoredImage {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: height * 0.625
                sourceSize.width: width
                source: "/qmlimages/CameraIcon.svg"
                //visible:                    recordBtnBackground.visible
                fillMode: Image.PreserveAspectFit
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: if (videoMode.checked) {
                               if (_recording) {
                                   //stop recording
                                   _activeVehicle.sendCommand(_activeVehicle,
                                                              //ID
                                                              183, //MAV_CMD
                                                              true, //showError
                                                              11,
                                                              //servo instance
                                                              1000) //servo value in us
                                   _recording = false
                               } else {
                                   //start recording
                                   _activeVehicle.sendCommand(_activeVehicle,
                                                              //ID
                                                              183, //MAV_CMD
                                                              true, //showError
                                                              11,
                                                              //servo instance
                                                              2000) //servo value in us
                                   _recording = true
                               }
                           } else {
                               //take photo
                               //_activeVehicle.sendCommand(_activeVehicle,203,true,0,0,0,0,1,0,0);
                               _activeVehicle.sendCommand(_activeVehicle, //ID
                                                          184, //repeat servo
                                                          true, //showError
                                                          11, //servo instance
                                                          2000,
                                                          //servo value in us
                                                          1, //count
                                                          1) //time
                           }
            }
        }
    }
}
