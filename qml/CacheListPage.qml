import QtQuick 1.1
import com.meego 1.0

Page {
    id: cacheListPage
    
    tools: ToolBarLayout {
        visible: true

        /*ToolIcon {*/
        /*    platformIconId: "toolbar-settings";*/
        /*}*/
        ToolIcon {
            platformIconId: "toolbar-directory";
            anchors.rightMargin: 20
            anchors.right: addIcon.left
        }

        ToolIcon {
            id: addIcon
            platformIconId: "toolbar-add";
            onClicked: pageStack.push(setupPage)
            anchors.right: parent===undefined ? undefined : parent.right
        }
    }

    Label {
        id: nocaches
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        text: "No saved geocaches"
        font.pixelSize: 32
        visible: (cacheList.model.count == 0) 
    }

    ListView {
        id: cacheList
        anchors.fill: parent
        model: geocaches
        /*model: ListModel {*/
        /*    ListElement{*/
        /*        name: "Kätkön nimi"*/
        /*        latitude: 64.07323*/
        /*        longitude: 24.521*/
        /*    }*/
        /*}*/
        delegate: Item {
            id: cacheListDelegate
            height: 75
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            Rectangle {
                height: 1
                width: parent.width
                color: "#666666"
                anchors.bottom: parent.bottom
            }

            Item {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: childrenRect.height
                Label {
                    id: cacheName
                    anchors.left: parent.left
                    anchors.margins: 10
                    text: name
                    font.pixelSize: 26
                    font.weight: Font.Bold
                }

                Row {
                    anchors.top: cacheName.bottom
                    anchors.left: parent.left
                    anchors.margins: 5
                    anchors.leftMargin: 10
                    spacing: 10
                    Label {
                        id: latLabel
                        text: "Latitude: " + latitude
                        font.pixelSize: 20
                        color: "#aaaaaa"
                    }
                    Label {
                        id: lonLabel
                        text: "Longitude: " + longitude
                        font.pixelSize: 20
                        color: "#aaaaaa"
                    }
                }
            }

            MouseArea{
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    compass.setDestination(latitude, longitude);
                    new_cache = true;
                    pageStack.push(mainPage);
                }

                onPressAndHold: {
                    cacheMenu.cacheIndex = index;
                    cacheMenu.open(); 
                }
            }

        }


    }

    Menu {
        id: cacheMenu
        visualParent: pageStack
        property int cacheIndex: -1
        MenuLayout {
            MenuItem {text: "Delete cache"; onClicked: geocaches.remove(cacheMenu.cacheIndex); }
        }
    }

}
