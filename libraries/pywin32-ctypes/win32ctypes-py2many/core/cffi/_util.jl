# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _util
#=  Utility functions to help with cffi wrapping.
 =#
using FromFile: @from
@from "../core/compat.jl" using compat: is_bytes, is_integer
using cffi: FFI
abstract type AbstractErrorWhen end
abstract type AbstractLibraries end
ffi = FFI()
set_unicode(ffi, true)
function HMODULE(cdata)::Int64
    return convert(Int, cast(ffi, "intptr_t", cdata))
end

function PVOID(x)
    return cast(ffi, "void *", x)
end

function IS_INTRESOURCE(x)::Bool
    #=  Check if x is an index into the id list.

         =#
    return (convert(Int, cast(ffi, "uintptr_t", x)) >> 16) == 0
end

function RESOURCE(resource)
    #=  Convert a resource into a compatible input for cffi.

         =#
    if is_integer(resource)
        resource = cast(ffi, "wchar_t *", resource)
    elseif is_bytes(resource)
        resource = string(resource)
    end
    return resource
end

function resource(lpRESOURCEID)
    #=  Convert the windows RESOURCE into a python friendly object.
         =#
    if IS_INTRESOURCE(lpRESOURCEID)
        resource = convert(Int, cast(ffi, "uintptr_t", lpRESOURCEID))
    else
        resource = string(ffi, lpRESOURCEID)
    end
    return resource
end

mutable struct ErrorWhen <: AbstractErrorWhen
    #=  Callable factory for raising errors when calling cffi functions.

         =#
    _check::Any
    _raise_on_zero::Any
    ErrorWhen(check, raise_on_zero = true) = new(check, raise_on_zero)
end
function __call__(self::AbstractErrorWhen, value, function_name = "")
    if value == self._check
        _raise_error(self, function_name)
    else
        return value
    end
end

function _raise_error(self::AbstractErrorWhen, function_name = "")
    (code, message) = getwinerror(ffi)
    throw(Base.windowserror(function_name, code))
end

check_null = ErrorWhen(ffi.NULL)
check_zero = ErrorWhen(0)
check_false = ErrorWhen(false)
mutable struct Libraries <: AbstractLibraries
    __dict__::Dict{Symbol,Any}
    Libraries(__dict__::Dict{Symbol,Any} = Dict{Symbol,Any}()) = new(__dict__)
end
function Base.getproperty(self::Libraries, name::Symbol)
    if hasproperty(self, Symbol(name))
        return Base.getfield(self, Symbol(name))
    end
    library = dlopen(ffi, "$(name).dll")
    self.__dict__[Symbol(name)] = library
    return library
end
dlls = Libraries()
end
