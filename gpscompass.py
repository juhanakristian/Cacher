from PySide import QtCore

from QtMobility import Location
from QtMobility.Location import QGeoCoordinate, QGeoPositionInfo
from QtMobility.Sensors import QCompass

class GPSCompass(QtCore.QObject):
    '''GPSCompass gives distance and bearing to a gps position from the current gps position'''
    def __init__(self, parent):
        QtCore.QObject.__init__(self, parent)
        self.positionSource = Location.QGeoPositionInfoSource.createDefaultSource(self)
        if self.positionSource == None:
            self.valid = False 
            return
        self.positionSource.positionUpdated.connect(self.locationUpdated)
        self.currentPosition = QGeoCoordinate()
        self.positionSource.startUpdates()
        self.coordinate = QGeoCoordinate()
        self.compass = QCompass(self)
        self.compass.readingChanged.connect(self.compassReadingChanged)
        self.compass.setDataRate(10)
        self.compass.start()
        self.compassAzimuth = 0
        self.gpsactive = False

    location_changed = QtCore.Signal()
    bearing_changed = QtCore.Signal()
    destination_changed = QtCore.Signal()
    gps_activated = QtCore.Signal()

    def __del__(self):
        self.compass.stop()
        self.positionSource.stopUpdates()

    @QtCore.Slot()
    def compassReadingChanged(self):
        reading = self.compass.reading()
        if reading:
            self.compassAzimuth = reading.azimuth()
            self.bearing_changed.emit()

    @QtCore.Slot(float, float)
    def setDestination(self, lat, lon):
        self.coordinate = QGeoCoordinate(lat, lon)
        self.destination_changed.emit()

    def locationUpdated(self, update):
        self.currentPosition = update.coordinate()
        if not self.gpsactive:
            self.gpsactive = True
            self.gps_activated.emit()

        self.location_changed.emit()
        self.bearing_changed.emit()

    def _distance(self):
        if not self.currentPosition.isValid() or not self.coordinate.isValid():
            return 0
        return self.currentPosition.distanceTo(self.coordinate)

    def _bearing(self):
        if not self.currentPosition.isValid() or not self.coordinate.isValid():
            return 0
        return ((360 - self.compassAzimuth) - (360 - self.currentPosition.azimuthTo(self.coordinate)))

    def _destinationLatitude(self):
        return self.coordinate.latitude()

    def _destinationLongitude(self):
        return self.coordinate.longitude()

    def _latitude(self):
        return self.currentPosition.latitude()

    def _longitude(self):
        return self.currentPosition.longitude()

    def _gpsfix(self):
        return self.gpsactive

    distance = QtCore.Property(int, _distance, notify=location_changed)
    bearing = QtCore.Property(int, _bearing, notify=bearing_changed)
    latitude = QtCore.Property(float, _latitude, notify=location_changed)
    longitude = QtCore.Property(float, _longitude, notify=location_changed)
    dest_latitude = QtCore.Property(float, _destinationLatitude, notify=destination_changed)
    dest_longitude = QtCore.Property(float, _destinationLongitude, notify=destination_changed)
    gps = QtCore.Property(bool, _gpsfix, notify=gps_activated)
    
