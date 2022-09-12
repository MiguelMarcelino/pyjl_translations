# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module _common
using FromFile: @from
using Libdl
pythonapi = Libdl.dlopen(
    "C:/Users/Miguel Marcelino/AppData/Local/Programs/Python/Python39/python39.dll",
)





@from "_util.jl" using _util
abstract type AbstractLibraries end
PPy_UNICODE = Ptr{Cvoid}
LPBYTE = pointer_from_objref(Cuint)
is_64bits = typemax(Int) > (2^32)
Py_ssize_t = is_64bits ? (Cssize_t) : (Clong)
if sizeof(Clong) == sizeof(Ptr{Cvoid})
    LONG_PTR = Clong
elseif sizeof(Cssize_t) == sizeof(Ptr{Cvoid})
    LONG_PTR = Cssize_t
end
_PyBytes_FromStringAndSize =
    (a0, a1) -> ccall(
        Libdl.dlsym(pythonapi, :PyBytes_FromStringAndSize),
        Ptr{Cvoid},
        (Ptr{Cchar}, Py_ssize_t),
        a0,
        a1,
    )
function IS_INTRESOURCE(x::Csize_t)::Bool
    return (x >> 16) == 0
end

byreference = x -> pointer_from_objref(x)
function dereference(x)
    return x.contents
end

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
