# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module win32cred
using FromFile: @from
using Logging

@from "pywin32/win32cred.jl" using win32cred: *
@warn "DeprecationWarning: Please use \'from win32ctypes.pywin32 import win32cred\'"
end
