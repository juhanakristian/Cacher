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
    
    Label {
        id: distance
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        text: appWindow.distance + " meters"
    }

    Rectangle {
        id: compass
        width: 10
        height: 300
        anchors.centerIn: parent
        color: "#ff0000"
        transform: Rotation {
            origin.x: 5
            origin.y: 150
            angle: appWindow.bearing
        }

        Rectangle{
            width: 20
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: "#00ff00"
        }
    }
}
