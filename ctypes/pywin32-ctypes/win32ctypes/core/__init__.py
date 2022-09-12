#
# (C) Copyright 2014-2018 Enthought, Inc., Austin, TX
# All right reserved.
#
# This file is open source software distributed according to the terms in
# LICENSE.txt
#
import sys
import importlib

from . import _winerrors  # noqa

# "del" is not supported by PyJL
# try-else not supported in PyJL
# try:
#     import cffi
# except ImportError:
#     _backend = 'ctypes'
# else:
#     del cffi
#     _backend = 'cffi'
# try:
#     from importlib.abc import MetaPathFinder, Loader
# except ImportError:
#     MetaPathFinder = object
#     Loader = object

# MetaPathFinder = object
# Loader = object
from importlib.abc import MetaPathFinder, Loader

_backend = 'ctypes'

# Setup module redirection based on the backend


class BackendLoader(Loader):

    def __init__(self, redirect_module):
        self.redirect_module = redirect_module

    def load_module(self, fullname):
        module = importlib.import_module(self.redirect_module)
        sys.modules[fullname] = module
        return module

    # NOTE: Defined here to make python 3.3.x happy
    def module_repr(self, module):
        # The exception will cause ModuleType.__repr__ to ignore this method.
        raise NotImplementedError

class BackendFinder(MetaPathFinder):

    def __init__(self, modules):
        self.redirected_modules = {
            'win32ctypes.core.{}'.format(module)
            for module in modules}
        # TODO: Temporary
        self.modules=None

    def find_module(self, fullname, path=None):
        if fullname in self.redirected_modules:
            module_name = fullname.split('.')[-1]
            if _backend == 'ctypes':
                redirected = 'win32ctypes.core.ctypes.{}'
            else:
                redirected = 'win32ctypes.core.cffi.{}'
            return BackendLoader(redirected.format(module_name))
        else:
            return None

# TODO: Temporary
# sys.meta_path.append(BackendFinder([
#     '_dll', '_authentication', '_time',
#     '_common', '_resource', '_nl_support',
#     '_system_information']))
