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
        /*anchors.fill: parent*/
        plugin: Plugin { name: "nokia" }
        center: currentCoordinate
        width: 480
        height: 800

        
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

        /*transform: Scale {*/
        /*    id: mapScale*/
        /*    property real scale: 1*/
        /*    origin.x: map.width / 2*/
        /*    origin.y: map.height / 2*/
        /*    xScale: scale*/
        /*    yScale: scale*/
        /*}*/

    }

    PinchArea {
        id: pinchArea
        anchors.fill: parent
        enabled: true
        property double oldZoom;
        property double previousScale: -1
        pinch.minimumScale: 0.8

        function zoomDelta(zoom, percent) {
            return zoom + Math.log(percent)/Math.log(2);
        }

        onPinchStarted: {
            oldZoom = map.zoomLevel;
        }

        onPinchUpdated:  {
            /*map.zoomLevel = zoomDelta(oldZoom, pinch.scale);*/
            if(previousScale == -1) {
                previousScale = pinch.scale;
            } else {
                /*mapScale.scale += Math.log(pinch.scale)/Math.log(2);*/
                if(map.scale > 0.6)
                    map.scale -= (previousScale - pinch.scale);
            }
        }

        onPinchFinished: {
            map.zoomLevel = zoomDelta(oldZoom, map.scale);
            map.scale = 1
            map.x = 0;
            map.y = 0;
            previousScale = -1;
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
