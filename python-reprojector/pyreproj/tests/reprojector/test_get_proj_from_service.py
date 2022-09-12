# -*- coding: utf-8 -*-
from requests import HTTPError

import pytest
import requests_mock

from pyreproj import Reprojector
from pyproj import Proj


@pytest.mark.parametrize("param", [
    4326,
    '4326',
    'invalid_code'
])
def test_get_proj_from_service(param):
    with requests_mock.mock() as m:
        m.get('http://spatialreference.org/ref/epsg/4326/proj4/',
              text='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ')
        m.get('http://spatialreference.org/ref/epsg/invalid_code/proj4/',
              text='Not found, /ref/epsg/invalid_code/proj4/. ',
              status_code=404)
        rp = Reprojector()
        if param == 'invalid_code':
            with pytest.raises(HTTPError):
                rp.get_projection_from_service(param)
        else:
            proj = rp.get_projection_from_service(param)
            assert isinstance(proj, Proj)
