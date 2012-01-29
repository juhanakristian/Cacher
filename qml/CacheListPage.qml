import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: cacheListPage    
    tools: ToolBarLayout {
        visible: true
        ToolIcon {
            id: addIcon
            platformIconId: "toolbar-add";
            onClicked: pageStack.push(setupPage)
            anchors.right: parent===undefined ? undefined : parent.right
        }
        ToolIcon {
            id: helpIcon
            iconSource: "images/toolbar_icon_about.png"
            onClicked: pageStack.push(aboutPage)
            anchors.right: parent===undefined ? undefined : addIcon.left
        }
    }

    Component.onCompleted: console.log("CachelistPage")

    /*Image{
        source: "images/bg.png"
        anchors.centerIn: parent
    }*/


    ListView {
        id: cacheList
        anchors.fill: parent
        model: geocaches
        header: Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            anchors.bottomMargin: 20
            height: 105
            Label {
                id: headerLabel
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10
                font.pixelSize: 62
                text: "My caches"
            }

            Rectangle {
                id: separator
                height: 1
                width: parent.width
                color: "#666666"
                anchors.bottom: parent.bottom
            }
            Label {
                id: nocaches
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: separator.bottom
                anchors.topMargin: 20
                text: "No saved geocaches"
                font.pixelSize: 32
                visible: (geocaches.count == 0) 
            }
        }
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
                    elide: Text.ElideRight
                    width: cacheListDelegate.width-30
                    /*Component.onCompleted: {
                        //Truncate cache names that don't fit
                        var maxWidth = cacheListDelegate.width-30;
                        if(cacheName.paintedWidth > (maxWidth)) {
                            var m = maxWidth / cacheName.paintedWidth;
                            var p = cacheName.text.length * m;
                            p = p - 3;
                            cacheName.text = cacheName.text.slice(0, p);
                            cacheName.text += "...";
                        }
                    }*/
                }

                Row {
                    anchors.top: cacheName.bottom
                    anchors.left: parent.left
                    anchors.margins: 5
                    anchors.leftMargin: 10
                    spacing: 10
                    Label {
                        id: latLabel
                        text: gpsconverter.coordinateAsString(latitude,longitude)
                        font.pixelSize: 20
                        color: "#aaaaaa"
                    }
                    /*Label {*/
                    /*    id: lonLabel*/
                    /*    text: "Longitude: " + longitude*/
                    /*    font.pixelSize: 20*/
                    /*    color: "#aaaaaa"*/
                    /*}*/
                }
            }

            MouseArea{
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    compass.setDestination(latitude, longitude);
                    new_cache = true;
                    goal = name;
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
