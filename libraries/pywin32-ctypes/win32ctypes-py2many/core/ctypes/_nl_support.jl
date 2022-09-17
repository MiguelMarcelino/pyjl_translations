# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _nl_support
using FromFile: @from
using Libdl

@from "_util.jl" using _util: dlls
_GetACP = (a0) -> ccall(Libdl.dlsym(dlls.kernel32, :GetACP), Culong, (Nothing,), a0)
end
