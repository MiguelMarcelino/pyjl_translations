# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _resource
using FromFile: @from
using Libdl


@from "_common.jl" using _common: LONG_PTR, IS_INTRESOURCE
@from "_util.jl" using _util: check_null, check_zero, check_false, dlls


function ENUMRESTYPEPROC(callback)
    function wrapped(handle, type_, param)
        if IS_INTRESOURCE(UInt64(type_))
            type_ = convert(Int, type_)
        else
            type_ = unsafe_string(Base.cconvert(Cwstring, type_))
        end
        return Base.cconvert(Clong, callback(handle, type_, param))
    end

    return @cfunction($wrapped, Clong, (Ptr{Cvoid}, Ptr{Cvoid}, LONG_PTR))
end

function ENUMRESNAMEPROC(callback)
    function wrapped(handle, type_, name, param)
        if IS_INTRESOURCE(UInt64(type_))
            type_ = convert(Int, type_)
        else
            type_ = unsafe_string(Base.cconvert(Cwstring, type_))
        end
        if name === nothing
            return false
        elseif IS_INTRESOURCE(UInt64(name))
            name = convert(Int, name)
        else
            name = unsafe_string(Base.cconvert(Cwstring, name))
        end
        return Base.cconvert(Clong, callback(handle, type_, name, param))
    end

    return @cfunction($wrapped, Clong, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, LONG_PTR))
end

function ENUMRESLANGPROC(callback)
    function wrapped(handle, type_, name, language, param)
        if IS_INTRESOURCE(UInt64(type_))
            type_ = convert(Int, type_)
        else
            type_ = unsafe_string(Base.cconvert(Cwstring, type_))
        end
        if IS_INTRESOURCE(UInt64(name))
            name = convert(Int, name)
        else
            name = unsafe_string(Base.cconvert(Cwstring, name))
        end
        return Base.cconvert(Clong, callback(handle, type_, name, language, param))
    end

    return @cfunction(
        $wrapped,
        Clong,
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Cushort, LONG_PTR)
    )
end

function _UpdateResource(hUpdate, lpType, lpName, wLanguage, lpData, cbData)
    lp_type =
        isa(lpType, String) ? Cwstring(pointer(transcode(Cwchar_t, lpType))) :
        Cwstring(Ptr{Cwchar_t}(lpType))
    lp_name =
        isa(lpName, String) ? Cwstring(pointer(transcode(Cwchar_t, lpName))) :
        Cwstring(Ptr{Cwchar_t}(lpName))
    _BaseUpdateResource(hUpdate, lp_type, lp_name, wLanguage, lpData, cbData)
end

function _EnumResourceNames(hModule, lpszType, lpEnumFunc, lParam)
    resource_type =
        isa(lpszType, String) ? Cwstring(pointer(transcode(Cwchar_t, lpszType))) :
        Cwstring(Ptr{Cwchar_t}(lpszType))
    _BaseEnumResourceNames(hModule, resource_type, lpEnumFunc, lParam)
end

function _EnumResourceLanguages(hModule, lpType, lpName, lpEnumFunc, lParam)
    resource_type =
        isa(lpType, String) ? Cwstring(pointer(transcode(Cwchar_t, lpType))) :
        Cwstring(Ptr{Cwchar_t}(lpType))
    resource_name =
        isa(lpName, String) ? Cwstring(pointer(transcode(Cwchar_t, lpName))) :
        Cwstring(Ptr{Cwchar_t}(lpName))
    _BaseEnumResourceLanguages(hModule, resource_type, resource_name, lpEnumFunc, lParam)
end

function _FindResourceEx(hModule, lpType, lpName, wLanguage)
    resource_type =
        isa(lpType, String) ? Cwstring(pointer(transcode(Cwchar_t, lpType))) :
        Cwstring(Ptr{Cwchar_t}(lpType))
    resource_name =
        isa(lpName, String) ? Cwstring(pointer(transcode(Cwchar_t, lpName))) :
        Cwstring(Ptr{Cwchar_t}(lpName))
    return _BaseFindResourceEx(hModule, resource_type, resource_name, wLanguage)
end

_EnumResourceTypes =
    (a0, a1, a2) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :EnumResourceTypesW),
            Clong,
            (Ptr{Cvoid}, Ptr{Cvoid}, LONG_PTR),
            Ptr{Cvoid}(a0),
            a1,
            a2,
        )
        EnumResourceTypesW() = Libdl.dlsym(dlls.kernel32, :EnumResourceTypesW)
        return check_false(res, EnumResourceTypesW, (a0, a1, a2))
    end
_LoadResource =
    (a0, a1) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :LoadResource),
            Ptr{Cvoid},
            (Ptr{Cvoid}, Ptr{Cvoid}),
            Ptr{Cvoid}(a0),
            a1,
        )
        LoadResource() = Libdl.dlsym(dlls.kernel32, :LoadResource)
        return check_null(res, LoadResource, (a0, a1))
    end
_LockResource =
    (a0) -> begin
        res = ccall(Libdl.dlsym(dlls.kernel32, :LockResource), Ptr{Cvoid}, (Ptr{Cvoid},), a0)
        LockResource() = Libdl.dlsym(dlls.kernel32, :LockResource)
        return check_null(res, LockResource, (a0,))
    end
_SizeofResource =
    (a0, a1) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :SizeofResource),
            Culong,
            (Ptr{Cvoid}, Ptr{Cvoid}),
            Ptr{Cvoid}(a0),
            a1,
        )
        SizeofResource() = Libdl.dlsym(dlls.kernel32, :SizeofResource)
        return check_zero(res, SizeofResource, (a0, a1))
    end
_BeginUpdateResource =
    (a0, a1) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :BeginUpdateResourceW),
            Ptr{Cvoid},
            (Cwstring, Clong),
            a0,
            a1,
        )
        BeginUpdateResourceW() = Libdl.dlsym(dlls.kernel32, :BeginUpdateResourceW)
        return check_null(res == C_NULL ? (nothing) : (res), BeginUpdateResourceW, (a0, a1))
    end
_EndUpdateResource =
    (a0, a1) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :EndUpdateResourceW),
            Clong,
            (Ptr{Cvoid}, Clong),
            Ptr{Cvoid}(a0),
            a1,
        )
        EndUpdateResourceW() = Libdl.dlsym(dlls.kernel32, :EndUpdateResourceW)
        return check_false(res, EndUpdateResourceW, (a0, a1))
    end
_BaseEnumResourceNames =
    (a0, a1, a2, a3) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :EnumResourceNamesW),
            Clong,
            (Ptr{Cvoid}, Cwstring, Ptr{Cvoid}, LONG_PTR),
            Ptr{Cvoid}(a0),
            a1,
            a2,
            a3,
        )
        EnumResourceNamesW() = Libdl.dlsym(dlls.kernel32, :EnumResourceNamesW)
        return check_false(res, EnumResourceNamesW, (a0, a1, a2, a3))
    end
_BaseEnumResourceLanguages =
    (a0, a1, a2, a3, a4) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :EnumResourceLanguagesW),
            Clong,
            (Ptr{Cvoid}, Cwstring, Cwstring, Ptr{Cvoid}, LONG_PTR),
            Ptr{Cvoid}(a0),
            a1,
            a2,
            a3,
            a4,
        )
        EnumResourceLanguagesW() = Libdl.dlsym(dlls.kernel32, :EnumResourceLanguagesW)
        return check_false(res, EnumResourceLanguagesW, (a0, a1, a2, a3, a4))
    end
_BaseFindResourceEx =
    (a0, a1, a2, a3) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :FindResourceExW),
            Ptr{Cvoid},
            (Ptr{Cvoid}, Cwstring, Cwstring, Cushort),
            Ptr{Cvoid}(a0),
            a1,
            a2,
            a3,
        )
        FindResourceExW() = Libdl.dlsym(dlls.kernel32, :FindResourceExW)
        return check_null(res, FindResourceExW, (a0, a1, a2, a3))
    end
_BaseUpdateResource =
    (a0, a1, a2, a3, a4, a5) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :UpdateResourceW),
            Clong,
            (Ptr{Cvoid}, Cwstring, Cwstring, Cushort, Ptr{Cvoid}, Culong),
            Ptr{Cvoid}(a0),
            a1,
            a2,
            a3,
            a4,
            a5,
        )
        UpdateResourceW() = Libdl.dlsym(dlls.kernel32, :UpdateResourceW)
        return check_false(res, UpdateResourceW, (a0, a1, a2, a3, a4, a5))
    end
end
