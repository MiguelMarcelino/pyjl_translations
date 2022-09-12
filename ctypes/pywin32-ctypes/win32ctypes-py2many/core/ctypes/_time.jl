# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _time
using FromFile: @from
using Libdl

@from "_util.jl" using _util: dlls
_GetTickCount =
    (a0) -> ccall(Libdl.dlsym(dlls.kernel32, :GetTickCount), Culong, (Nothing,), a0)
end
