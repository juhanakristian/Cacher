import QtQuick 1.1
import com.meego 1.0

import QtMobility.location 1.2

Page {
    id: setupPage
    tools: setupPageTools

    ToolBarLayout {
        id: setupPageTools
        visible: true
        ToolIcon { 
            platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: pageStack.pop()
        }

        ToolButton {
            text: "Add"
            anchors.right: parent.right
            onClicked: {
                geocaches.add(nameText.text, parseFloat(latitudeText.text), parseFloat(longitudeText.text));
                pageStack.pop();
            }
        }
    }

    onStatusChanged: {
        if(status == PageStatus.Active) {
            latitudeText.text = appWindow.gps_latitude;                
            longitudeText.text = appWindow.gps_longitude;                
        }
    }

    Column {
        id: inputColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        anchors.topMargin: 30
        spacing: 10

        Label {
            text: "Enter latitude and longitude of a geocache"
            anchors.bottomMargin: 10
        }

        TextField {
            id: nameText
            anchors.left: parent.left
            anchors.right: parent.right
            placeholderText: "Name"
        }

        TextField {
            id: latitudeText
            anchors.left: parent.left
            anchors.right: parent.right
            placeholderText: "Latitude"
        }
        TextField {
            id: longitudeText
            anchors.left: parent.left
            anchors.right: parent.right
            placeholderText: "Longitude"
        }

    }

}
