import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: mainPage
    tools: ToolBarLayout {
        visible: true
        ToolIcon { 
            platformIconId: "toolbar-back"
            anchors.left: parent.left
            onClicked: pageStack.pop()
        }
        ToolIcon{
            iconSource: "images/toolbar_icon_map.png"
            anchors.right: parent.right
            onClicked: pageStack.push(mapPage)
        }
    }

    orientationLock: PageOrientation.LockPortrait

    function formatDistance(d)
    {
        if(d > 1000)
            return (d/1000.00).toFixed(2) + " km";
        else
            return d + " meters";
    }


    Text {
        id: goal_name
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
        text: goal
        wrapMode: Text.WordWrap
        color: "#ffffff"
    }

    Label {
        id: dest_position
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: goal_name.bottom
        anchors.margins: 15
        font.pixelSize: 22
        text: gpsconverter.coordinateAsString(dest_latitude, dest_longitude)
    }
    
    Label {
        id: distance
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: dest_position.bottom
        anchors.topMargin: 15
        font.pixelSize: 42
        text: formatDistance(appWindow.distance)
    }

    Image {
        id: compassBackground
        source: "images/compass_bg.png"
        y: (parent.height / 2) - (compassBackground.height / 2) + 25
        anchors.horizontalCenter: parent.horizontalCenter

        Image{
            id: compassNeedle
            source: "images/compass_needle.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            transform: Rotation {
                origin.x: 10
                origin.y: 124
                angle: appWindow.bearing
            }
        }

        Image {
            id: compassCap
            source: "images/compass_cap.png"
            y: (parent.height / 2) - (height / 2) - 1
            x: (parent.width / 2) - (width / 2)
        }

        //Disable for performance reasons
        /*Image {*/
        /*    id: compassGloss*/
        /*    source: "images/compass_gloss.png"*/
        /*    anchors.horizontalCenter: parent.horizontalCenter*/
        /*    y: (parent.height / 2) - (height / 2) - 12*/
        /*}*/
    }

    Label {
        id: position
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: compassBackground.bottom
        anchors.topMargin: 30
        font.pixelSize: 32
        text: (compass.gps) ? gpsconverter.coordinateAsString(gps_latitude, gps_longitude) : "No GPS"
    }

}
