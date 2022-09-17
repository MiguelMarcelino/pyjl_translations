# -*- coding: utf-8 -*-
import os
import sys

from setuptools import setup, find_packages
from datetime import datetime

VERSION = '2.0.0'

test_mode = False
timestamp = datetime.now().strftime('%Y%m%d%H%M')

if "--test" in sys.argv:
    test_mode = True
    sys.argv.remove("--test")

here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, 'README.rst')) as f:
    README = f.read()
with open(os.path.join(here, 'CHANGES.rst')) as f:
    CHANGES = f.read()

requires = [
    'pyproj>=2.2.0',
    'shapely',
    'requests'
    ]

setup(name='pyreproj',
      version=VERSION + '-dev.{0}'.format(timestamp) if test_mode else VERSION,
      description='Python Reprojector',
      license='BSD',
      long_description='\n'.join([
          README,
          '',
          'Changelog',
          '---------',
          '',
          CHANGES
      ]),
      classifiers=[
          "Development Status :: 4 - Beta" if test_mode else "Development Status :: 5 - Production/Stable",
          "Programming Language :: Python :: 2.7",
          "Programming Language :: Python :: 3.5",
          "Programming Language :: Python :: 3.6",
          "Programming Language :: Python :: 3.7",
          "Topic :: Scientific/Engineering :: GIS",
          "Topic :: Utilities",
          "Natural Language :: English",
          "License :: OSI Approved :: BSD License",
          "Intended Audience :: Developers",
          "Operating System :: OS Independent"
      ],
      author='Karsten Deininger',
      author_email='karsten.deininger@bl.ch',
      url='https://gitlab.com/geo-bl-ch/python-reprojector',
      keywords='web proj coordinate transformation',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      install_requires=requires
      )
