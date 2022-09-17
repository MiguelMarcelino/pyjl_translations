# -*- coding: utf-8 -*-
import pytest

from pyreproj import InvalidFormatError
from pyreproj import Reprojector
from pyproj import Proj

@pytest.mark.parametrize("param", [
    "epsg:4326",
    "EPSG:4326",
    4326,
    "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
    Proj(init='epsg:4326')
])
def test_get_proj_from_parameter(param):
    rp = Reprojector()
    proj = rp._get_proj_from_parameter(param)
    assert isinstance(proj, Proj)


@pytest.mark.parametrize("param", [
    None,
    "invalid_parameter"
])
def test_get_proj_from_parameter_invalid(param):
    with pytest.raises(InvalidFormatError):
        rp = Reprojector()
        rp._get_proj_from_parameter(param)
