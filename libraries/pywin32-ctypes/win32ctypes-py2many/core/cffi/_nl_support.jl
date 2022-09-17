# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _nl_support
using FromFile: @from
@from "_util.jl" using _util: ffi, dlls
ffi.cdef("\n\nUINT WINAPI GetACP(void);\n\n")
function _GetACP()
    return GetACP(dlls.kernel32)
end

end
