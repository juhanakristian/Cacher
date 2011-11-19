import QtQuick 1.1
import com.meego 1.0

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
            platformIconId: "toolbar-gallery"
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
    
    Label {
        id: distance
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 35
        font.pixelSize: 42
        text: formatDistance(appWindow.distance)
    }

    Image {
        id: compassBackground
        source: "images/compass_bg.png"
        anchors.centerIn: parent

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
            anchors.horizontalCenter: parent.horizontalCenter
            y: (parent.height / 2) - (height / 2) - 2
        }

        Image {
            id: compassGloss
            source: "images/compass_gloss.png"
            anchors.horizontalCenter: parent.horizontalCenter
            y: (parent.height / 2) - (height / 2) - 12
        }
    }

    Label {
        id: position
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        font.pixelSize: 32
        text: appWindow.gps_latitude.toFixed(6) + " " + appWindow.gps_longitude.toFixed(6)
    }

}
