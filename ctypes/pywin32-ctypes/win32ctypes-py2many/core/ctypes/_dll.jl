# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _dll
using FromFile: @from
using Libdl

@from "_util.jl" using _util: check_null, check_false, dlls
_LoadLibraryEx =
    (a0, a1, a2) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :LoadLibraryExW),
            Ptr{Cvoid},
            (Cwstring, Ptr{Cvoid}, Culong),
            a0,
            Ptr{Cvoid}(a1),
            a2,
        )
        LoadLibraryExW() = Libdl.dlsym(dlls.kernel32, :LoadLibraryExW)
        return check_null(res == C_NULL ? (nothing) : (res), LoadLibraryExW, (a0, a1, a2))
    end
_FreeLibrary =
    (a0) -> begin
        res = ccall(
            Libdl.dlsym(dlls.kernel32, :FreeLibrary),
            Clong,
            (Ptr{Cvoid},),
            Ptr{Cvoid}(a0),
        )
        FreeLibrary() = Libdl.dlsym(dlls.kernel32, :FreeLibrary)
        return check_false(res, FreeLibrary, (a0,))
    end
end
