# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module pywin32
using FromFile: @from
@from "pywintypes.jl" using pywintypes
@from "win32api.jl" using win32api
@from "win32cred.jl" using win32cred
export win32api, win32cred, pywintypes
end
