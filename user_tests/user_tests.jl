# Transpiled with flags: 
# - fix_scope_bounds
# - loop_scope_warning
module user_tests
function fib(i::Int)::Int
    if (i == 0 || i == 1)
        return 1
    end
    return fib(i - 1) + fib(i - 2)
end

abstract type AbstractShape end
abstract type AbstractSquare <: AbstractShape end

function comb_sort(seq::Vector{Int})::Vector{Int}
    gap = length(seq)
    swap = true
    while (gap > 1 || swap)
        gap = max(1, floor(Int, gap / 1.25))
        swap = false
        for i = 1:length(seq)-gap
            if seq[i] > seq[i+gap]
                (seq[i], seq[i+gap]) = (seq[i+gap], seq[i])
                swap = true
            end
        end
    end
    return seq
end

function binomial_coef(n::Int, k::Int)
    C = [[0 for x = 0:k] for x = 0:n]
    for i = 0:n
        for j = 0:min(i, k)
            if (j == 0 || j == i)
                C[i+1][j+1] = 1
            else
                C[i+1][j+1] = C[i][j] + C[i][j+1]
            end
        end
    end
    return C[n+1][k+1]
end

mutable struct Shape <: AbstractShape
    x::Any
    y::Any
end
function position(self::AbstractShape)::Tuple
    return (self.x, self.y)
end

mutable struct Square <: AbstractSquare
    #= Two-dimensional square =#
    x::Any
    y::Any
    side1::Any
    side2::Any
    Square(x, y, side1, side2) = begin
        Shape(x, y)
        new(x, y, side1, side2)
    end
end
function area(self::AbstractSquare)
    return self.side1 * self.side2
end

function mandelbrot(limit, c)::Int
    i = 0
    z = 0 + 0im
    for _i = 0:limit
        i = _i
        if abs(z) > 2
            return i
        end
        z = z * z + c
    end
    return i + 1
end

function fib_generators()
    Channel() do ch_fib_generators
        a = 0
        b = 1
        while true
            put!(ch_fib_generators, a)
            (a, b) = (b, a + b)
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    @assert(fib(0) == 1)
    @assert(fib(1) == 1)
    @assert(fib(10) == 89)
    @assert(fib(20) == 10946)
    unsorted = [14, 11, 19, 5, 16, 10, 19, 12, 5, 12]
    expected = [5, 5, 10, 11, 12, 12, 14, 16, 19, 19]
    @assert(comb_sort(unsorted) == expected)
    @assert(binomial_coef(0, 0) == 1)
    @assert(binomial_coef(1, 1) == 1)
    @assert(binomial_coef(100, 100) == 1)
    @assert(binomial_coef(10, 6) == 210)
    @assert(binomial_coef(20, 6) == 38760)
    shape = Shape(1, 3)
    square = Square(2, 4, 5, 5)
    @assert(position(shape) == (1, 3))
    @assert(position(square) == (2, 4))
    @assert(area(square) == 25)
    @assert(mandelbrot(1, 0.2 + 0.3im) == 2)
    @assert(mandelbrot(5, 0.2 + 0.3im) == 6)
    @assert(mandelbrot(6, 0.2 + 0.3im) == 7)
    @assert(mandelbrot(10000, 1 + 0.3im) == 2)
    fib_arr = []
    fib_gen = fib_generators()
    for i = 1:6
        push!(fib_arr, take!(fib_gen))
    end
    @assert(fib_arr == [0, 1, 1, 2, 3, 5])
end
end
