# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module core
using FromFile: @from


@from "_winerrors.jl" using _winerrors

abstract type AbstractBackendLoader end
abstract type AbstractBackendFinder end
_backend = "ctypes"
mutable struct BackendLoader <: AbstractBackendLoader
    redirect_module::Any
end
function load_module(self::AbstractBackendLoader, fullname)
    module_ = @eval @from import Symbol(self.redirect_module)
    sys.modules[fullname+1] = module_
    return module_
end

function module_repr(self::AbstractBackendLoader, module_)
    throw(NotImplementedError)
end

mutable struct BackendFinder <: AbstractBackendFinder
    modules::Any
    redirected_modules::Any
    BackendFinder(
        modules,
        redirected_modules = ("win32ctypes.core.$(module_)" for module_ in modules),
    ) = new(modules, redirected_modules)
end
function find_module(self::AbstractBackendFinder, fullname, path = nothing)::BackendLoader
    if fullname ∈ self.redirected_modules
        module_name = split(fullname, ".")[end]
        if _backend == "ctypes"
            redirected = "win32ctypes.core.ctypes.{}"
        else
            redirected = "win32ctypes.core.cffi.{}"
        end
        return BackendLoader(format(redirected, module_name))
    else
        return nothing
    end
end

end
