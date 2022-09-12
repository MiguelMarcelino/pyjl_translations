# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module win32api
using FromFile: @from
using Logging
using Reexport

@from "pywin32/win32api.jl" using win32api: *
@reexport using .win32api
@warn "DeprecationWarning: Please use \'from win32ctypes.pywin32 import win32api\'"
end
