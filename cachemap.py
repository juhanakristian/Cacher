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

class CacheMap(QGraphicsGeoMap):
    def __init__(self, parent = None):
        self.serviceProvider = QGeoServiceProvider("nokia")
        self.mappingManager = self.serviceProvider.mappingManager()
        QGraphicsGeoMap.__init__(self, self.mappingManager)
        self.gps_coordinate = QGeoCoordinate()
        self.gps_marker = None
        self.lockOnGPS = False

    @QtCore.Slot()
    def createGPSMarker(self):
        self.gps_marker = QGeoMapPixmapObject(QGeoCoordinate(64, 24))
        self.gps_marker.setPixmap(QPixmap(gps_icon_path))
        self.gps_marker.setOffset(QPoint(-12, -12))
        self.gps_marker.setZValue(10)
        self.addMapObject(self.gps_marker)

    def _center(self):
        return self.center()

    def setCenterGC(self, c):
        self.setCenter(c)

    @QtCore.Slot(float, float)
    def setCenterF(self, lat, lon):
        self.setCenter(QGeoCoordinate(lat, lon))

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
        self.addMapObject(self.route_object)


    @QtCore.Slot(float, float)
    def addCache(self, latitude, longitude):
        po = QGeoMapPixmapObject(QGeoCoordinate(latitude, longitude))
        po.setPixmap(QPixmap(cache_icon_path))
        po.setOffset(QPoint(-27, -60))
        po.setZValue(10)
        self.addMapObject(po)

    @QtCore.Slot()
    def clearCaches(self):
        self.clearMapObjects()
        self.createGPSMarker()

    @QtCore.Slot(float, float)
    def setGPSPosition(self, latitude, longitude):
        coord = QGeoCoordinate(latitude, longitude)
        self.gps_coordinate = coord
        self.updateGPSMarker()

    def _gpsLatitude(self):
        return self.gps_coordinate.latitude()

    def setGPSLatitude(self, latitude):
        self.gps_coordinate.setLatitude(latitude)
        self.updateGPSMarker()

    def _gpsLongitude(self):
        return self.gps_coordinate.longitude()

    def setGPSLongitude(self, longitude):
        self.gps_coordinate.setLongitude(longitude)
        self.updateGPSMarker()

    def _lock(self):
        return self.lockOnGPS

    def setLock(self, l):
        self.lockOnGPS = l
        self.setCenterGC(self.gps_coordinate)

    def updateGPSMarker(self):
        if self.gps_marker:
            self.gps_marker.setCoordinate(self.gps_coordinate)
        if self.lockOnGPS:
            self.setCenterGC(self.gps_coordinate)

    gpsLatitude = QtCore.Property(float, _gpsLatitude, setGPSLatitude)
    gpsLongitude = QtCore.Property(float, _gpsLongitude, setGPSLongitude)
    follow = QtCore.Property(bool, _lock, setLock)
