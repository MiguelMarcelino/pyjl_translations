# --------------------------------------
function fib(i::Int)
    if i == 0 || i == 1
        return 1
    else
        return fib(i - 1) + fib(i - 2)
    end
end

# 0:25

# Errei o or
# Esqueci um :
# Esqueci um end

fib(5)
# 0:55
# --------------------------------------
function comb_sort(seq::Vector{Int})
    gap = length(seq)
    swap = true
    while gap > 1 || swap
        gap = max(1, floor(Int, gap / 1.25))
        swap = false
        for i in 0:length(seq) - 1 - gap
            if seq[i + 1] > seq[i + 1 + gap]
                seq[i + 1], seq[i + 1 + gap] = seq[i + 1 + gap], seq[i + 1]
                swap = true
            end
        end
    end
    return seq
end

# 1:46

comb_sort([1,3,2,4])
# Errei o or.
# Errei o range.
# 3:33

# --------------------------------------
##############################
# Test 3
function binomial_coef(n::Int, k::Int)
    C = [[0 for x in 0:k] for x in 0:n]
    for i in 0:n
        for j in 0:min(i, k)
            if j == 0 || j == i
                C[i+1][j+1] = 1
            else
                C[i+1][j+1] = C[i][j] + C[i][j+1]
            end
        end
    end
    return C[n+1][k+1]
end

# 2:01

binomial_coef(3, 2)
# 2:17

# --------------------------------------
##############################
# Test 4
abstract type AbstractShape end

struct Shape <: AbstractShape
    x
    y
end

function position(self::AbstractShape)
    (self.x, self.y)
end

abstract type AbstractSquare <: AbstractShape end

# Two-dimensional square
struct Square <: AbstractSquare
    x
    y
    side1
    side2
end

function area(self::AbstractSquare)
    self.side1 * self.side2
end

# 3:08

position(Shape(1, 2))
area(Square(1, 2, 3, 4))

# 3:42
# --------------------------------------
##############################
# Test 5
function mandelbrot(limit, c)
    z = 0 + 0im
    for i in 0:limit
        if abs(z) > 2
            return i
        end
        z = z * z + c
    end
    return limit + 1
end

# 0:58

mandelbrot(1000, 1 + 2im)
# 1:12

# --------------------------------------
# Some tests to check for correctness
# Fibonacci
using Test

@assert fib(0) == 1
@assert fib(1) == 1
@assert fib(10) == 89
@assert fib(20) == 10946

# comb_sort
unsorted = [14, 11, 19, 5, 16, 10, 19, 12, 5, 12]
expected = [5, 5, 10, 11, 12, 12, 14, 16, 19, 19]
@assert comb_sort(unsorted) == expected
# binomial_coef
@assert binomial_coef(0, 0) == 1
@assert binomial_coef(1, 1) == 1
@assert binomial_coef(100, 100) == 1
@assert binomial_coef(10, 6) == 210
@assert binomial_coef(20, 6) == 38760
# Classes
shape = Shape(1, 3)
square = Square(2, 4, 5, 5)
@assert position(shape) == (1, 3)
@assert position(square) == (2, 4)
@assert area(square) == 25

# 2:45 e passou tudo
# Scopes
@assert mandelbrot(1, 0.2 + 0.3im) == 2
# Detectou um erro de scope!

@assert mandelbrot(5, 0.2 + 0.3im) == 6
@assert mandelbrot(6, 0.2 + 0.3im) == 7
@assert mandelbrot(10000, 1 + 0.3im) == 2
# 3:45