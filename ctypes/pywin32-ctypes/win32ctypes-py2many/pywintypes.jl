# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module pywintypes
using FromFile: @from
using Logging

@from "pywin32/pywintypes.jl" using pywintypes: *
@warn "DeprecationWarning: Please use \'from win32ctypes.pywin32 import pywintypes\'"
end
