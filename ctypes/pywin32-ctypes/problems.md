## Most notable problems so far

### TODO
- ~~win32ctypes\tests\test_win32api.py: Imports to `win32ctypes: pywin32` and `win32ctypes.pywin32.pywintypes: error` are failing~~
- ~~win32ctypes\tests\test_win32api.py: Function calls are missing arguments~~
- `win32ctypes-py2many\core\ctypes\_common.jl` --> `argtypes` are missing when calling `_util.function_factory` with `ctypes.pythonapi.PyBytes_FromStringAndSize` (ctypes does not recognize `_NamedFuncPointer`)

### Mapping
- ~~WindowsError~~
- ~~ctypes.byref~~
- ~~ctypes.WINFUNCTYPE~~
- ~~pointer_from_objref~~
- ~~ctypes.memset~~
- os.environ
- ctypes.py_object
- shutil
- tempfile
- _common --> function_factory is not correctly mapped (should be _util.function_factory)


# Changed
- `win32ctypes\pywin32\win32api.py` --> changed imports (We only need ctypes)
- `win32ctypes\pywin32\win32cred.py` --> changed imports (We only need ctypes)
- `win32ctypes\core\ctypes\_common.py` --> Removed `return_type` from `_PyBytes_FromStringAndSize`
- `win32ctypes\core\__init__.py` --> changed imports
- `win32ctypes\core\ctypes\authentication.py` --> Changed import to `win32ctypes.core.compat`
- `win32ctypes\tests\test_win32api.py` --> Changed `mport win32api` to `import win32ctypes.pywin32.win32api as win32api` 