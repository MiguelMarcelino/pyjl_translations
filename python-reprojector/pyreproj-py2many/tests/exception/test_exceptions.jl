module test_exceptions
using FromFile: @from
using ParameterTests
using Test

@from "../../exception/__init__.jl" using exception:
    Error, InvalidFormatError, InvalidTargetError
@paramtest "test_error" begin
    @given err ∈ [Error, InvalidFormatError, InvalidTargetError]
    e = err("test")
    @test(e.message == "test")
    @test(String(e) == repr("test"))
end

end
