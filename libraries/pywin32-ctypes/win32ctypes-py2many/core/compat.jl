# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module compat
function is_bytes(b)
    return isa(b, Array{UInt8})
end

function is_text(s)
    return isa(s, String)
end

function is_integer(i)
    return isa(i, Int64)
end

end
