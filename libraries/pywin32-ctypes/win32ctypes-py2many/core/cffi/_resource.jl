# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _resource
using FromFile: @from
@from "_util.jl" using _util:
    ffi, check_null, check_zero, check_false, HMODULE, PVOID, RESOURCE, resource, dlls
ffi.cdef(
    "\n\ntypedef int WINBOOL;\ntypedef WINBOOL (__stdcall *ENUMRESTYPEPROC) (HANDLE, LPTSTR, LONG_PTR);\ntypedef WINBOOL (__stdcall *ENUMRESNAMEPROC) (HANDLE, LPCTSTR, LPTSTR, LONG_PTR);\ntypedef WINBOOL (__stdcall *ENUMRESLANGPROC) (HANDLE, LPCTSTR, LPCTSTR, WORD, LONG_PTR);\n\nBOOL WINAPI EnumResourceTypesW(\n    HMODULE hModule, ENUMRESTYPEPROC lpEnumFunc, LONG_PTR lParam);\nBOOL WINAPI EnumResourceNamesW(\n    HMODULE hModule, LPCTSTR lpszType,\n    ENUMRESNAMEPROC lpEnumFunc, LONG_PTR lParam);\nBOOL WINAPI EnumResourceLanguagesW(\n    HMODULE hModule, LPCTSTR lpType,\n    LPCTSTR lpName, ENUMRESLANGPROC lpEnumFunc, LONG_PTR lParam);\nHRSRC WINAPI FindResourceExW(\n    HMODULE hModule, LPCTSTR lpType, LPCTSTR lpName, WORD wLanguage);\nDWORD WINAPI SizeofResource(HMODULE hModule, HRSRC hResInfo);\nHGLOBAL WINAPI LoadResource(HMODULE hModule, HRSRC hResInfo);\nLPVOID WINAPI LockResource(HGLOBAL hResData);\n\nHANDLE WINAPI BeginUpdateResourceW(LPCTSTR pFileName, BOOL bDeleteExistingResources);\nBOOL WINAPI EndUpdateResourceW(HANDLE hUpdate, BOOL fDiscard);\nBOOL WINAPI UpdateResourceW(HANDLE hUpdate, LPCTSTR lpType, LPCTSTR lpName, WORD wLanguage, LPVOID lpData, DWORD cbData);\n\n",
)
function ENUMRESTYPEPROC(callback)
    function wrapped(hModule, lpszType, lParam)
        return callback(hModule, resource(lpszType), lParam)
    end

    return wrapped
end

function ENUMRESNAMEPROC(callback)
    function wrapped(hModule, lpszType, lpszName, lParam)::Bool
        if lpszName == ffi.NULL
            return false
        end
        return callback(hModule, resource(lpszType), resource(lpszName), lParam)
    end

    return wrapped
end

function ENUMRESLANGPROC(callback)
    function wrapped(hModule, lpszType, lpszName, wIDLanguage, lParam)
        return callback(
            hModule,
            resource(lpszType),
            resource(lpszName),
            wIDLanguage,
            lParam,
        )
    end

    return wrapped
end

function _EnumResourceTypes(hModule, lpEnumFunc, lParam)
    callback = ffi.callback("ENUMRESTYPEPROC", lpEnumFunc)
    check_false(
        EnumResourceTypesW(dlls.kernel32, PVOID(hModule), callback, lParam),
        function_name = "EnumResourceTypes",
    )
end

function _EnumResourceNames(hModule, lpszType, lpEnumFunc, lParam)
    callback = ffi.callback("ENUMRESNAMEPROC", lpEnumFunc)
    check_false(
        EnumResourceNamesW(
            dlls.kernel32,
            PVOID(hModule),
            RESOURCE(lpszType),
            callback,
            lParam,
        ),
        function_name = "EnumResourceNames",
    )
end

function _EnumResourceLanguages(hModule, lpType, lpName, lpEnumFunc, lParam)
    callback = ffi.callback("ENUMRESLANGPROC", lpEnumFunc)
    check_false(
        EnumResourceLanguagesW(
            dlls.kernel32,
            PVOID(hModule),
            RESOURCE(lpType),
            RESOURCE(lpName),
            callback,
            lParam,
        ),
        function_name = "EnumResourceLanguages",
    )
end

function _FindResourceEx(hModule, lpType, lpName, wLanguage)
    return check_null(
        FindResourceExW(
            dlls.kernel32,
            PVOID(hModule),
            RESOURCE(lpType),
            RESOURCE(lpName),
            wLanguage,
        ),
        function_name = "FindResourceEx",
    )
end

function _SizeofResource(hModule, hResInfo)
    return check_zero(
        SizeofResource(dlls.kernel32, PVOID(hModule), hResInfo),
        function_name = "SizeofResource",
    )
end

function _LoadResource(hModule, hResInfo)
    return check_null(
        LoadResource(dlls.kernel32, PVOID(hModule), hResInfo),
        function_name = "LoadResource",
    )
end

function _LockResource(hResData)
    return check_null(LockResource(dlls.kernel32, hResData), function_name = "LockResource")
end

function _BeginUpdateResource(pFileName, bDeleteExistingResources)::Int64
    result = check_null(
        BeginUpdateResourceW(dlls.kernel32, string(pFileName), bDeleteExistingResources),
    )
    return HMODULE(result)
end

function _EndUpdateResource(hUpdate, fDiscard)
    check_false(
        EndUpdateResourceW(dlls.kernel32, PVOID(hUpdate), fDiscard),
        function_name = "EndUpdateResource",
    )
end

function _UpdateResource(hUpdate, lpType, lpName, wLanguage, cData, cbData)
    lpData = ffi.from_buffer(cData)
    check_false(
        UpdateResourceW(
            dlls.kernel32,
            PVOID(hUpdate),
            RESOURCE(lpType),
            RESOURCE(lpName),
            wLanguage,
            PVOID(lpData),
            cbData,
        ),
        function_name = "UpdateResource",
    )
end

end
