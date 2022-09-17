# -*- coding: utf-8 -*-
from shapely.geometry import Point

import pytest

from pyreproj import InvalidTargetError
from pyreproj import Reprojector


@pytest.mark.parametrize("type,target,from_srs,to_srs", [
    ("tuple", (45.0, 45.0), 'EPSG:4326', 'EPSG:3857'),
    ("list", [45.0, 45.0], 'EPSG:4326', 'EPSG:3857'),
    ("shapely", Point(45.0, 45.0), 'EPSG:4326', 'EPSG:3857'),
    ("invalid", 'not a valid target', 'EPSG:4326', 'EPSG:3857')
])
def test_transform(type, target, from_srs, to_srs):
    rp = Reprojector()
    if type == 'invalid':
        try:
            rp.transform(target, from_srs=from_srs, to_srs=to_srs)
        except InvalidTargetError as e:
            assert e.message == 'Invalid target to transform. Valid targets are [x, y], (x, y) or a shapely' \
                                ' geometry object.'
    else:
        trf = rp.transform(target, from_srs=from_srs, to_srs=to_srs)
        if type == 'tuple':
            assert isinstance(trf, tuple)
            assert len(trf) == 2
        elif type == 'list':
            assert isinstance(trf, list)
            assert len(trf) == 2
        elif type == 'shapely':
            assert isinstance(trf, Point)


def test_transform_epsg_2056():
    rp = Reprojector()
    from_srs = 4326
    to_srs = 2056
    xy = (47.48911, 7.72866)
    expected = (2621858.036, 1259856.747)
    trf = rp.transform(xy, from_srs=from_srs, to_srs=to_srs)
    assert round(trf[0], 3) == expected[0]
    assert round(trf[1], 3) == expected[1]

# Added for testing
if __name__ == "__main__":
    test_transform_epsg_2056()
