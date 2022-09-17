# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _time
using FromFile: @from
@from "_util.jl" using _util: ffi, dlls
ffi.cdef("\n\nDWORD WINAPI GetTickCount(void);\n\n")
function _GetTickCount()
    return GetTickCount(dlls.kernel32)
end

end
