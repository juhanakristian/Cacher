import QtQuick 1.1
import com.meego 1.0

PageStackWindow {
    id: appWindow

    Component.onCompleted: {
        theme.inverted = true;
        console.log(geocaches.count)
    }

    property int distance: compass.distance
    property int bearing: compass.bearing
    property double gps_latitude: compass.latitude
    property double gps_longitude: compass.longitude
    property double dest_latitude: compass.dest_latitude
    property double dest_longitude: compass.dest_longitude
    /*property variant route: routehandler.route*/

    /*property alias geocacheModel: geocaches*/


    //Used to determine should we center the map on the cache
    property bool new_cache: true
    property string goal: ""

    initialPage: cacheListPage

    CacheListPage{id: cacheListPage}
    MainPage{id: mainPage}
    SetupPage{id: setupPage}
    MapPage{id: mapPage}
    AboutPage{id: aboutPage}
}
