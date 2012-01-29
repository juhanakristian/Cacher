import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: aboutPage
    tools: ToolBarLayout {
        visible: true
        ToolIcon { 
            platformIconId: "toolbar-back"
            anchors.left: parent.left
            onClicked: pageStack.pop()
        }
    }

    orientationLock: PageOrientation.LockPortrait

    Image{
        id: logo
        source: "images/logo.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40
    }

    Text{
        id: versionText
        anchors.top: logo.bottom
        anchors.right: parent.right
        anchors.margins: 45
        anchors.topMargin: 5
        text: "Version 1.0"
        color: "#ffffff"
        font.pixelSize: 18
        font.family: "Nokia Pure Text"
        
    }

    Text{
        id: aboutText
        anchors.top: versionText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 45
        anchors.topMargin: 40
        horizontalAlignment: Text.AlignJustify
        textFormat: Text.RichText
        text: "<p>Cacher supports LOC-files for adding geocaches.</p> <p>Download more geocaches from <a href=\"http://geocaching.com\">geocaching.com</a> and place the LOC-files in the \"Cacher\"-folder on your device.</p>"
        wrapMode: Text.WordWrap
        color: "#ffffff"
        font.pixelSize: 24
        font.family: "Nokia Pure Text"
        onLinkActivated: Qt.openUrlExternally(link)
        
    }

    Text{
        id: copyrightText
        textFormat: Text.RichText
        anchors.top: aboutText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        text: "© 2011 Juhana Jauhiainen"
        color: "#ffffff"
        font.pixelSize: 18
        font.family: "Nokia Pure Text" 
    }
}
