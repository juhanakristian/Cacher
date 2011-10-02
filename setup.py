from distutils.core import setup
import os, sys, glob

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(name="cacher",
      scripts=['cacher', 'gpscompass.py', 'sqllistmodel.py', 'locparser.py'],
      version='0.1.0',
      maintainer="Juhana Jauhiainen",
      maintainer_email="email@example.com",
      description="A PySide example",
      long_description=read('cacher.longdesc'),
      data_files=[('share/applications',['cacher.desktop']),
                  ('share/icons/hicolor/64x64/apps', ['cacher.png']),
                  ('share/cacher/qml', glob.glob('qml/*.qml')), ],)
