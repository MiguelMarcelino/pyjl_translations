# -*- coding: utf-8 -*-
from functools import partial

from pyreproj import Reprojector


def test_get_transformation_function():
    rp = Reprojector()
    trf = rp.get_transformation_function(from_srs=4326, to_srs=3857)
    assert isinstance(trf, partial)
    p = trf(45.0, 45.0)
    assert isinstance(p, tuple)
    assert len(p) == 2
