import QtQuick 1.1
import com.nokia.meego 1.0

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

    /*Image{
        source: "images/bg.png"
        anchors.centerIn: parent
    }*/

    onStatusChanged: {
        if(status == PageStatus.Active) {
            if(gps_latitude != undefined && gps_longitude != undefined) {
                latitudeText.text = gps_latitude;                
                longitudeText.text = gps_longitude;                
            } else {
                latitudeText.text = 51.4791;
                longitudeText.text = 0.0000;
            }
        }
    }

    Flickable{
        anchors.fill: parent
        anchors.topMargin: 30
        contentWidth: parent.width
        contentHeight: inputColumn.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: inputColumn
            spacing: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10

            Label{
                text: "Name"
                wrapMode: Text.WordWrap
            }

            TextField {
                id: nameText
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: "Name"
            }


            Label{
                text: "Latitude as decimal"
                wrapMode: Text.WordWrap
            }

            TextField {
                id: latitudeText
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: "Latitude"
            }

            Label{
                text: "Longitude as decimal"
                wrapMode: Text.WordWrap
            }

            TextField {
                id: longitudeText
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: "Longitude"
            }

        }
    }
}
