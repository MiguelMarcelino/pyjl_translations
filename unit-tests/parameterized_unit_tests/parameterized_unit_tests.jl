module ex
using ParameterTests
using Test

function palindrome_detector(s::String)::Bool
    s = replace(lowercase(s), " " => "")
    return s == s[end:-1:begin]
end

@paramtest "test_palindrome_detector" begin
    @given (input, expected) ∈ [("madam", true), ("false", false)]
    @test(palindrome_detector(input) == expected)
end

end
