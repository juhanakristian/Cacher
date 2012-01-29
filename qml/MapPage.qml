import QtQuick 1.1
import com.nokia.meego 1.0

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

        ToolButton { 
            id: recalculateRoute
            text: "Calculate route"
            anchors.right: parent.right
            onClicked: {
                routehandler.calculateRoute(gps_latitude, 
                                            gps_longitude,
                                            destCoordinate.latitude,
                                            destCoordinate.longitude);

            }
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
            map.setCenterF(gps_latitude, gps_longitude)
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

    /*Map {
        id : map
        plugin: Plugin{name: "nokia"}
        anchors.fill: parent

    }*/

    CacheMap {
        id: map
        anchors.fill: parent
        /*width: parent.width*/
        /*height: parent.height*/


        property int parentWidth: parent.width
        property int parentHeight: parent.height

        /*anchors.leftMargin: (parent.width/2) - (width/2)*/
        /*anchors.topMargin: (parent.height/2) - (height/2)*/

        gpsLatitude: gps_latitude
        gpsLongitude: gps_longitude
        Component.onCompleted: {
            createGPSMarker();
        }

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

    Button {
        id: followButton
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 15
        checkable: true
        width: height
        z: 10 
        iconSource: "images/follow_icon.png"
        onClicked: map.follow = followButton.checked
    }

    PinchArea {
        id: pinchArea
        anchors.fill: parent
        enabled: true
        property double oldZoom: 0
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
                if(map.scale > 0.6 && map.scale < 2.3) {
                    map.scale -= (previousScale - pinch.scale);
                    var map_width = map.width * map.scale;
                    map.x = (map.parentWidth/2) - (map_width/2);
                    var map_height = map.height * map.scale;
                    map.y = (map.parentHeight/2) - (map_height/2);
                    /*console.log("Map width:" + map.width);*/
                }
            }
        }

        onPinchFinished: {
            map.zoomLevel = zoomDelta(oldZoom, map.scale);
            map.scale = 1
            previousScale = -1;
            map.x = 0;
            map.y = 0;
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
