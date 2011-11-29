from PySide import QtCore

from QtMobility.Location import *
from PySide.QtDeclarative import *
from PySide.QtGui import QPixmap
from PySide.QtGui import QPen
from PySide.QtCore import QPoint

cache_icon_path = "/usr/share/cacher/qml/images/cache_marker.png"
gps_icon_path = "/usr/share/cacher/qml/images/gps_marker.png"

CAR = 1
WALK = 2

class CacheMap(QDeclarativeItem):
    def __init__(self):
        QDeclarativeItem.__init__(self)
        self.serviceProvider = QGeoServiceProvider("nokia")
        self.geomap = QGraphicsGeoMap(self.serviceProvider.mappingManager(), self)
        self.gps_coordinate = QGeoCoordinate()
        self.routingMode = CAR
        self.createGPSMarker()

    def createGPSMarker(self):
        self.gps_marker = QGeoMapPixmapObject()
        self.gps_marker.setPixmap(QPixmap(gps_icon_path))
        self.gps_marker.setOffset(QPoint(-12, -12))
        self.gps_marker.setZValue(10)
        self.geomap.addMapObject(self.gps_marker)

    def geometryChanged(self, new, old):
        self.geomap.setGeometry(new) 

    def _center(self):
        return self.geomap.center()

    def setCenter(self, c):
        print "Set center:", c
        self.geomap.setCenter(c)

    @QtCore.Slot(float, float)
    def setCenter(self, lat, lon):
        print "Set center %f %f" % (lat,lon)
        self.geomap.setCenter(QGeoCoordinate(lat, lon))

    def _zoomLevel(self):
        return self.geomap.zoomLevel()

    def setZoomLevel(self, z):
        self.geomap.setZoomLevel(z)

    @QtCore.Slot(float, float)
    def pan(self, dx, dy):
        c = self.geomap.coordinateToScreenPosition(self.geomap.center())
        c = c + QtCore.QPointF(dx, dy)
        gc = self.geomap.screenPositionToCoordinate(c)
        self.geomap.setCenter(gc)

    @QtCore.Slot(str)
    def setRoute(self, route):
        t = route.strip("{}")
        cs = t.split(";")
        path = list()
        for c in cs:
            c = c.strip("()")
            latitude = c[0:c.rfind(",")]
            longitude = c[c.rfind(",")+1:len(c)]
            path.append(QGeoCoordinate(float(latitude), float(longitude)))
        self.route = QGeoRoute()
        self.route.setPath(path)
        self.route_object = QGeoMapPolylineObject()
        self.route_object.setPath(path)
        pen = QPen(QtCore.Qt.red)
        pen.setWidth(5)
        self.route_object.setPen(pen)
        self.route_object.setZValue(1)
        self.geomap.addMapObject(self.route_object)


    @QtCore.Slot(float, float)
    def addCache(self, latitude, longitude):
        po = QGeoMapPixmapObject(QGeoCoordinate(latitude, longitude))
        po.setPixmap(QPixmap(cache_icon_path))
        po.setOffset(QPoint(-27, -60))
        po.setZValue(10)
        self.geomap.addMapObject(po)

    @QtCore.Slot()
    def clearCaches(self):
        self.geomap.clearMapObjects()
        self.createGPSMarker()

    @QtCore.Slot(float, float)
    def setGPSPosition(self, latitude, longitude):
        self.gps_marker.setCoordinate(QGeoCoordinate(latitude, longitude))

    def _gpsLatitude(self):
        return self.gps_coordinate.latitude()

    def setGPSLatitude(self, latitude):
        self.gps_coordinate.setLatitude(latitude)
        self.gps_marker.setCoordinate(self.gps_coordinate)

    def _gpsLongitude(self):
        return self.gps_coordinate.longitude()

    def setGPSLongitude(self, longitude):
        self.gps_coordinate.setLongitude(longitude)
        self.gps_marker.setCoordinate(self.gps_coordinate)

    zoomLevel = QtCore.Property(float, _zoomLevel, setZoomLevel)
    gpsLatitude = QtCore.Property(float, _gpsLatitude, setGPSLatitude)
    gpsLongitude = QtCore.Property(float, _gpsLongitude, setGPSLongitude)
