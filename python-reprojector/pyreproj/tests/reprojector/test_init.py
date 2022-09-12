# -*- coding: utf-8 -*-
from pyreproj import Reprojector


def test_init():
    rp = Reprojector()
    assert isinstance(rp, Reprojector)
    assert hasattr(rp, 'srs_service_url')
    assert rp.srs_service_url == 'http://spatialreference.org/ref/epsg/{epsg}/proj4/'


def test_init_with_srs_service_url():
    rp = Reprojector(srs_service_url='http://justatest.org/{epsg}')
    assert isinstance(rp, Reprojector)
    assert hasattr(rp, 'srs_service_url')
    assert rp.srs_service_url == 'http://justatest.org/{epsg}'

# Added for testing
if __name__ == "__main__":
    test_init()
    test_init_with_srs_service_url()
