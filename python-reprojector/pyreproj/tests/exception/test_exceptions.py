# -*- coding: utf-8 -*-
import pytest
from pyreproj.exception import Error, InvalidFormatError, InvalidTargetError


@pytest.mark.parametrize("err", [
    Error,
    InvalidFormatError,
    InvalidTargetError
])
def test_error(err):
    e = err('test')
    assert e.message == 'test'
    assert str(e) == repr('test')
