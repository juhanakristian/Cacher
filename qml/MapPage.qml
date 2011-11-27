import QtQuick 1.1
import com.meego 1.0

import QtMobility.location 1.2
import UIElements 1.0

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

    orientationLock: PageOrientation.LockPortrait

    onStatusChanged: {
        if(status == PageStatus.Active && new_cache) {
            map.clearCaches();
            destCoordinate.latitude = dest_latitude;                
            destCoordinate.longitude = dest_longitude;                
            map.zoomLevel = 14;
            new_cache = false;
            map.setCenter(gps_latitude, gps_longitude)
            routehandler.calculateRoute(gps_latitude, 
                                        gps_longitude,
                                        destCoordinate.latitude,
                                        destCoordinate.longitude);
            routehandler.routeCalculationReady.connect(map.setRoute);
            map.addCache(dest_latitude, dest_longitude)
        }
    }

    Coordinate {
        id: destCoordinate
    }


    CacheMap {
        id: map
        anchors.fill: parent

        gpsLatitude: gps_latitude
        gpsLongitude: gps_longitude

    }

    /*Travel modes not implemented yet*/
    /*ButtonRow {*/
    /*    anchors.left: parent.left*/
    /*    anchors.top: parent.top*/
    /*    anchors.margins: 15*/
    /*    width: 240*/
    /*    z: 10 */
    /*    Button {*/
    /*        text: "Car"*/
    /*        onClicked: {*/
    /*            routehandler.setMode(1);*/
    /*            routehandler.calculateRoute(gps_latitude, */
    /*                                        gps_longitude,*/
    /*                                        destCoordinate.latitude,*/
    /*                                        destCoordinate.longitude);*/
    /*        }*/
    /*    }*/

    /*    Button {*/
    /*        text: "Foot"*/
    /*        onClicked: {*/
    /*            routehandler.setMode(2);*/
    /*            routehandler.calculateRoute(gps_latitude, */
    /*                                        gps_longitude,*/
    /*                                        destCoordinate.latitude,*/
    /*                                        destCoordinate.longitude);*/
    /*        }*/
    /*    }*/
    /*}*/

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
            if(previousScale == -1) {
                previousScale = pinch.scale;
            } else {
                if(map.scale > 0.6 && map.scale < 2.3)
                    map.scale -= (previousScale - pinch.scale);
            }
        }

        onPinchFinished: {
            map.zoomLevel = zoomDelta(oldZoom, map.scale);
            map.scale = 1
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
