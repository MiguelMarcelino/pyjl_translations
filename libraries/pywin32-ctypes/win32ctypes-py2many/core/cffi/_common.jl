# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _common
using FromFile: @from

@from "_util.jl" using _util: ffi
_keep_alive = WeakKeyDictionary()
function _PyBytes_FromStringAndSize(pointer, size)
    buffer = ffi.buffer(pointer, size)
    return buffer[begin:end]
end

function byreference(x)
    return ffi.new(ffi.getctype(ffi.typeof(x), "*"), x)
end

function dereference(x)
    return x[1]
end

end
