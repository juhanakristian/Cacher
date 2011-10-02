import QtQuick 1.1
import com.meego 1.0

import QtMobility.location 1.2

Page {
    id: mapPage
    tools: ToolBarLayout {
        visible: true
        ToolIcon { 
            platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: pageStack.pop()
        }
    }

    onStatusChanged: {
        if(status == PageStatus.Active && new_cache) {
            currentCoordinate.latitude = dest_latitude;                
            currentCoordinate.longitude = dest_longitude;                
            destCoordinate.latitude = dest_latitude;                
            destCoordinate.longitude = dest_longitude;                
            map.zoomLevel = 14;
            new_cache = false;
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin { name: "nokia" }
        center: currentCoordinate

        
        Coordinate{
            id: currentCoordinate
        }

        Coordinate {
            id: destCoordinate
        }

        MapCircle {
            id: destCircle
            color: "#0099ee"
            radius: 15
            center: destCoordinate
        }

        MapCircle {
            id: gpsCircle
            color: "#cc3333"
            radius: 15
            center: Coordinate {
                latitude: appWindow.gps_latitude                
                longitude: appWindow.gps_longitude
            }
        }

    }

    PinchArea {
        id: pinchArea
        anchors.fill: parent
        enabled: true
        property double oldZoom;

        function zoomDelta(zoom, percent) {
            return zoom + Math.log(percent)/Math.log(2);
        }

        onPinchStarted: {
            oldZoom = map.zoomLevel;
        }

        onPinchUpdated:  {
            map.zoomLevel = zoomDelta(oldZoom, pinch.scale);
        }

        onPinchFinished: {
            map.zoomLevel = zoomDelta(oldZoom, pinch.scale);
        }
    }

    MouseArea {
        id: mapMouseArea
        anchors.fill: parent
        property int lastX: -1
        property int lastY: -1
        property bool mouseDown: false

        onPressed: {
            mouseDown = true;
            lastX = mouse.x; 
            lastY = mouse.y; 
        }

        onPositionChanged: {
            if(mouseDown) {
                var dx = mouse.x - lastX;
                var dy = mouse.y - lastY;
                map.pan(-dx, -dy);
                lastX = mouse.x; 
                lastY = mouse.y; 
            }
        }

        onReleased: {
            mouseDown = false;
        }

        onCanceled: {
            mouseDown = false;
        }
    }

}
