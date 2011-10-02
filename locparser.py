from xml.etree.ElementTree import XMLParser

from PySide import QtCore

class LOCParserTarget:
    def __init__(self):
        self.locs = list()
        self.current = dict()
        self.ctag = "location"
    
    def start(self, tag, attrib):
        self.ctag = tag
        if tag == "name":
            self.current["id"] = attrib["id"] 
        elif tag == "coord":
            self.current["latitude"] = attrib["lat"]
            self.current["longitude"] = attrib["lon"]

    def end(self, tag):
        if tag == "waypoint":
            self.locs.append(self.current)
            self.current = dict()

    def data(self, data):
        if self.ctag == "name" and not "name" in self.current.keys():
            self.current["name"] = data 
        elif self.ctag == "link" and not "link" in self.current.keys():
            self.current["link"] = data

    def close(self):
        return self.locs


class LOCParser(QtCore.QObject):
    parsed_locations = QtCore.Signal(list)
    def __init__(self, parent = None):
        QtCore.QObject.__init__(self, parent)

    def parse(self, loc):
        target = LOCParserTarget()
        parser = XMLParser(target=target)
        parser.feed(loc)
        l = parser.close()
        self.parsed_locations.emit(l)
