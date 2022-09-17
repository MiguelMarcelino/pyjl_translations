# Transpiled with flags: 
# - use_modules
# - use_resumables
# - fix_scope_bounds
# - loop_scope_warning
# - remove_nested_resumables
module pywintypes
#=  A module which supports common Windows types.  =#
using DataTypesBasic

mutable struct error <: Exception
    winerror::Any
    funcname::Any
    strerror::Any
    error(args...) = begin
        nargs = length(args)
        if nargs > 0
            winerror = args[1]
        else
            winerror = nothing
        end
        if nargs > 1
            funcname = args[2]
        else
            funcname = nothing
        end
        if nargs > 2
            strerror = args[3]
        else
            strerror = nothing
        end
        new()
    end
end

pywin32error() = @ContextManager function (cont)
    res = nothing
    try
        res = cont()
    catch exn
        let exception = exn
            if exception isa SystemError
                throw(error(exception.errnum, exception.prefix))
            end
        end
    end
    res
end

end
