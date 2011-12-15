from distutils.core import setup
import os, sys, glob

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(name="cacher",
      scripts=['cacher', 'gpscompass.py', 
                'sqllistmodel.py', 'locparser.py', 
                'routehandler.py', 'cachemap.py'],
      version='1.0.0',
      maintainer="Juhana Jauhiainen",
      maintainer_email="juhana.jauhiainen@gmail.com",
      description="A simple geocaching app",
      long_description=read('cacher.longdesc'),
      data_files=[('share/applications',['cacher.desktop']),
                  ('share/icons/hicolor/80x80/apps', ['cacher.png']),
                  ('share/cacher/qml', glob.glob('qml/*.qml')), 
                  ('share/cacher/qml/images', glob.glob('qml/images/*.png')),
                  ('share/cacher/', ['splash.png'])],)
