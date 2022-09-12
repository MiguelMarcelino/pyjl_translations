# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _util
#=  Utility functions to help with ctypes wrapping.
 =#
using Libdl




abstract type AbstractLibraries end



function make_error(function_::Function, function_name = nothing)::SystemError
    code = Base.Libc.GetLastError()
    description = strip(Base.Libc.FormatMessage(code))
    if function_name === nothing
        function_name = nameof(function_)
    end
    return Base.windowserror(function_name, code)
end

function check_null_factory(function_name = nothing)
    function check_null(result, function_, arguments, args...)
        if result === nothing
            throw(make_error(function_, function_name))
        end
        return result
    end

    return check_null
end

check_null = check_null_factory()
function check_zero_factory(function_name = nothing)
    function check_zero(result, function_, arguments, args...)
        if result == 0
            throw(make_error(function_, function_name))
        end
        return result
    end

    return check_zero
end

check_zero = check_zero_factory()
function check_false_factory(function_name = nothing)
    function check_false(result, function_, arguments, args...)
        if !Bool(result)
            throw(make_error(function_, function_name))
        else
            return true
        end
    end

    return check_false
end

check_false = check_false_factory()
mutable struct Libraries <: AbstractLibraries
    __dict__::Dict{Symbol,Any}
    Libraries(__dict__::Dict{Symbol,Any} = Dict{Symbol,Any}()) = new(__dict__)
end
function Base.getproperty(self::Libraries, name::Symbol)
    if hasproperty(self, Symbol(name))
        return Base.getfield(self, Symbol(name))
    end
    library = Libdl.dlopen(name)
    self.__dict__[Symbol(name)] = library
    return library
end
dlls = Libraries()
end
