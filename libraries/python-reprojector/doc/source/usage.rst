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
-  String: EPSG code with leading “epsg:”, e.g. ‘epsg:2056’
-  String: proj4 definition string
-  Object: instance of pyproj.Proj

The returned function is a `functools.partial`_ that can also be used as first argument for `shapely.ops.transform`_.

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
-  String: EPSG code with leading “epsg:”, e.g. ‘epsg:2056’
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

.. _functools.partial: https://docs.python.org/2/library/functools.html#functools.partial
.. _shapely.ops.transform: http://toblerity.org/shapely/shapely.html#shapely.ops.transform