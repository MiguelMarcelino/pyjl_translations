# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _dll
using FromFile: @from
@from "_util.jl" using _util: ffi, check_null, check_false, dlls, HMODULE, PVOID
ffi.cdef(
    "\n\nHMODULE WINAPI LoadLibraryExW(LPCTSTR lpFileName, HANDLE hFile, DWORD dwFlags);\nBOOL WINAPI FreeLibrary(HMODULE hModule);\n\n",
)
function _LoadLibraryEx(lpFilename, hFile, dwFlags)::Int64
    result = check_null(
        LoadLibraryExW(dlls.kernel32, string(lpFilename), ffi.NULL, dwFlags),
        function_name = "LoadLibraryEx",
    )
    return HMODULE(result)
end

function _FreeLibrary(hModule)
    check_false(FreeLibrary(dlls.kernel32, PVOID(hModule)), function_name = "FreeLibrary")
end

end
