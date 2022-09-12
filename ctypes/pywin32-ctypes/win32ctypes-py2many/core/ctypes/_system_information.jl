# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _system_information
using FromFile: @from
using Libdl
using PyCall
ctypes = pyimport("ctypes")


@from "_util.jl" using _util: check_zero, dlls
function _GetWindowsDirectory()
    buffer = ctypes.create_unicode_buffer(MAX_PATH)
    _BaseGetWindowsDirectory(buffer, MAX_PATH)
    return unsafe_string(Base.cconvert(Cwstring, buffer))
end

function _GetSystemDirectory()
    buffer = ctypes.create_unicode_buffer(MAX_PATH)
    _BaseGetSystemDirectory(buffer, MAX_PATH)
    return unsafe_string(Base.cconvert(Cwstring, buffer))
end

_BaseGetWindowsDirectory =
    (a0, a1) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :GetWindowsDirectoryW),
            Culong,
            (Cwstring, Culong),
            a0,
            a1,
        )
        GetWindowsDirectoryW() = Libdl.dlsym(dlls.kernel32, :GetWindowsDirectoryW)
        return check_zero(res, GetWindowsDirectoryW, (a0, a1))
    end
_BaseGetSystemDirectory =
    (a0, a1) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :GetSystemDirectoryW),
            Culong,
            (Cwstring, Culong),
            a0,
            a1,
        )
        GetSystemDirectoryW() = Libdl.dlsym(dlls.kernel32, :GetSystemDirectoryW)
        return check_zero(res, GetSystemDirectoryW, (a0, a1))
    end
end
