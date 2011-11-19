from PySide import QtCore
from QtMobility import Location
from QtMobility.Location import *


class RouteHandler(QtCore.QObject):
    routeCalculationReady = QtCore.Signal(str)
    def __init__(self):
        QtCore.QObject.__init__(self)
        p = QGeoServiceProvider.availableServiceProviders()
        for sp in p:
            print "Service provider: %s" % sp
        self.serviceProvider = QGeoServiceProvider("nokia")
        self.routingManager = self.serviceProvider.routingManager()
        #self.routingManager.finished.connect(self.routeCalculated)
        #self.routingManager.error.connect(self.routeCalculationError)
        self.currentRoute = list()
        self.reply = None

    @QtCore.Slot(float, float, float, float)
    def calculateRoute(self, start_lat, start_lon, destination_lat, destination_lon):
        start = QGeoCoordinate(start_lat, start_lon)
        destination = QGeoCoordinate(destination_lat, destination_lon)
        print "Calculating route %s %s" % (start.toString(), destination.toString())
        request = QGeoRouteRequest(start, destination)
        self.reply = self.routingManager.calculateRoute(request)
        if self.reply.isFinished():
            if self.reply.error() == QGeoRouteReply.NoError:
                self.routeCalculated(reply)
            else:
                self.routeCalculationError(self.reply, reply.error(), reply.errorString())
            return
        self.reply.finished.connect(self.routeCalculated)
        self.reply.error.connect(self.routeCalculationError)

        print "Called"

    @QtCore.Slot()
    def routeCalculated(self):
        print "Route calculated"
        if len(self.reply.routes()) > 0:
            r = self.reply.routes()[0]
            self.routeCalculationReady.emit(self.makeRouteString(r))

    @QtCore.Slot(QGeoRouteReply.Error, str)
    def routeCalculationError(self, error, error_string):
        print "Error calculating route %s" % error_string

    def _route(self):
        return self.currentRoute

    @QtCore.Slot()
    def get_route(self):
        print self.currentRoute
        return self.currentRoute

    def makeRouteString(self, route):
        path = route.path()
        route_string = "{"
        for coordinate in path:
            route_string += "(%s,%s);" % (coordinate.latitude(), coordinate.longitude()) 
        route_string = route_string[:len(route_string)-1]
        route_string += "}"
        return route_string
 
    route = QtCore.Property("QVariant", read=_route, notify=routeCalculationReady)
