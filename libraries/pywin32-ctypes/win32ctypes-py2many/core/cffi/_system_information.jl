# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _system_information
using FromFile: @from
@from "_util.jl" using _util: ffi, dlls
MAX_PATH = 260
MAX_PATH_BUF = "wchar_t[$(MAX_PATH)]"
ffi.cdef(
    "\n\nBOOL WINAPI Beep(DWORD dwFreq, DWORD dwDuration);\nUINT WINAPI GetWindowsDirectoryW(LPTSTR lpBuffer, UINT uSize);\nUINT WINAPI GetSystemDirectoryW(LPTSTR lpBuffer, UINT uSize);\n\n",
)
function _GetWindowsDirectory()
    buffer = ffi.new(MAX_PATH_BUF)
    directory = GetWindowsDirectoryW(dlls.kernel32, buffer, MAX_PATH)
    return ffi.unpack(buffer, directory)
end

function _GetSystemDirectory()
    buffer = ffi.new(MAX_PATH_BUF)
    directory = GetSystemDirectoryW(dlls.kernel32, buffer, MAX_PATH)
    return ffi.unpack(buffer, directory)
end

end
