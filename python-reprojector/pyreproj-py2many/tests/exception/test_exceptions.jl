module test_exceptions
using FromFile: @from

@from "../../exception/__init__.jl" using exception:
    Error, InvalidFormatError, InvalidTargetError
function test_error()
    param_args = [Error, InvalidFormatError, InvalidTargetError]
    for err in param_args
        e = err("test")
        @assert(e.message == "test")
        @assert(String(e) == repr("test"))
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    test_error()
end
end
