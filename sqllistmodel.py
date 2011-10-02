from PySide.QtCore import Qt
from PySide import QtCore
from PySide import QtSql

class SqlListModel(QtSql.QSqlTableModel):
    def __init__(self):
        QtSql.QSqlTableModel.__init__(self)
        self.roles = dict()
        self.cache = dict()

    def generate_roles(self):
        self.roles = dict()
        m = QtSql.QSqlTableModel()
        m.setTable(self.tableName())
        m.select()
        for i in range(self.columnCount()):
            self.roles[Qt.UserRole + i] = str(self.headerData(i, Qt.Horizontal))
        self.setRoleNames(self.roles)
        print "ROLES:", self.roles


    def data(self, index, role):
        if not index.row() in self.cache.keys():
            return None

        t = self.cache[index.row()]

        if role in t.keys():
            return t[role];

        return None


    def load(self):
        m = QtSql.QSqlTableModel()
        m.setTable(self.tableName())
        m.select()

        for i in range(m.rowCount()):
            r = m.record(i)
            h = dict()
            for key, role in self.roles.items():
                v = r.value(role)
                h[key] = v
            self.cache[i] = h
        self.select()

    @QtCore.Slot(str, float, float)
    def add(self, name, latitude, longitude, cacheid=""):
        row = self.rowCount()
        self.insertRow(row)
        self.setData(self.createIndex(row, 1), name)
        self.setData(self.createIndex(row, 2), cacheid)
        self.setData(self.createIndex(row, 3), latitude)
        self.setData(self.createIndex(row, 4), longitude)
        if not self.submitAll():
            print self.lastError()
        self.load()

    @QtCore.Slot(int)
    def remove(self, index):
        if not self.removeRow(index):
            print self.lastError()
        if not self.submitAll():
            print self.lastError()
        self.load()

    def cachenames(self):
        indices = list()
        for i in range(self.rowCount()):
            indices.append(self.index(i, 0))

        nkey = 0
        for key, value in self.roles.items():
            if value == "name":
                nkey = key
        
        names = list()
        for ind in indices:
            names.append(self.data(ind, nkey))
        return names

    def cacheids(self):
        indices = list()
        for i in range(self.rowCount()):
            indices.append(self.index(i, 0))

        nkey = 0
        for key, value in self.roles.items():
            if value == "cacheID":
                nkey = key
        
        ids = list()
        for ind in indices:
            ids.append(self.data(ind, nkey))
        return ids
