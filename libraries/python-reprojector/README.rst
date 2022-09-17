|build status| |coverage report|

Python Reprojector
==================

This is a simple python library for coordinate transformations between different projections. It uses the
`pyproj library <https://github.com/jswhit/pyproj>`__ as a wrapper for `proj.4
<https://github.com/OSGeo/proj.4>`__. The goal is to make transformations as simple as possible.

Usage
-----

Get transformation function
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: python

    from pyreproj import Reprojector

    rp = Reprojector()
    transform = rp.get_transformation_function(from_srs=4326, to_srs='epsg:2056')
    transform(47.46614, 7.80071)
    # returns: (2627299.6594659993, 1257325.3550428299)

The arguments *from\_srs* and *to\_srs* can be one of the following:

-  Integer: value of the EPSG code, e.g. 2056
-  String: EPSG code with leading "epsg:", e.g. 'epsg:2056'
-  String: proj4 definition string
-  Object: instance of pyproj.Proj

The returned function is a `functools.partial
<https://docs.python.org/2/library/functools.html#functools.partial>`__ that can also be used as first
argument for `shapely.ops.transform <http://toblerity.org/shapely/shapely.html#shapely.ops.transform>`__.

Transform coordinates directly
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: python

    from shapely.geometry import Point
    from pyreproj import Reprojector

    rp = Reprojector()

    p1 = Point(47.46614, 7.80071)
    p2 = rp.transform(p1, from_srs=4326, to_srs=2056)
    p2.wkt
    # returns: 'POINT (2627299.659465999 1257325.35504283)'

    rp.transform([47.46614, 7.80071], from_srs=4326, to_srs=2056)
    # returns: [2627299.6594659993, 1257325.3550428299]

    rp.transform((47.46614, 7.80071), from_srs=4326, to_srs=2056)
    # returns: (2627299.6594659993, 1257325.3550428299)

The arguments *from\_srs* and *to\_srs* can be one of the following:

-  Integer: value of the EPSG code, e.g. 2056
-  String: EPSG code with leading "epsg:", e.g. 'epsg:2056'
-  String: proj4 definition string
-  Object: instance of pyproj.Proj

Get projection from service
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: python

    from pyreproj import Reprojector

    rp = Reprojector()
    proj = rp.get_projection_from_service(epsg=2056)
    type(proj)
    # returns: <class 'pyproj.Proj'>

.. |build status| image:: https://gitlab.com/geo-bl-ch/python-reprojector/badges/master/build.svg
   :target: https://gitlab.com/geo-bl-ch/python-reprojector/commits/master
.. |coverage report| image:: https://gitlab.com/geo-bl-ch/python-reprojector/badges/master/coverage.svg
   :target: https://gitlab.com/geo-bl-ch/python-reprojector/commits/master
