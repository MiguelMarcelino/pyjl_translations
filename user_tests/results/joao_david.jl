# Test 1

#0:28.2
function fib(i::Int)::Int
    if i == 0 || i == 1
        return 1
    else
        return fib(i-1) + fib(i-2)
    end
end

# Test 2

# 1:39.77 - primeira, tinha type hints errados
# 2:25.72 - arranjei um False que tinha ficado à python, e converter floor para Int

function comb_sort(seq::Vector{ Int })::Vector{ Int }
    gap = length(seq)
    swap = true
    while gap > 1 || swap
        gap = max(1, Int(floor(gap / 1.25)))
        swap = false
        for i in 0:length(seq) - gap - 1
            if seq[i+1] > seq[i + 1 + gap]
                seq[i + 1], seq[i + 1+ gap] = seq[i + 1 + gap], seq[i + 1]
                swap = true
            end
        end
    end
    return seq
end

# Test 3

# def binomial_coef(n: int, k: int):
#     C = [[0 for x in range(k + 1)] for x in range(n + 1)]
#     for i in range(n + 1):
#         for j in range(min(i, k) + 1):
#             if j == 0 or j == i:
#                 C[i][j] = 1
#             else:
#                 C[i][j] = C[i - 1][j - 1] + C[i - 1][j]
#     return C[n][k]

# 1:59.46 - primeira
# 2:17.20 - arranjar bug, faltava os +1 no return
function binomial_coef(n::Int, k::Int)
    C = [[0 for x in 0:k] for x in 0:n]
    for i in 0:n
        for j in 0:min(i,k)
            if j == 0 || j == i
                C[i+1][j+1] = 1
            else
                C[i+1][j+1] = C[i][j] + C[i][j+1]
            end
        end
    end
    return C[n+1][k+1]
end


# Test 4

# 1:54.65
# 3:04.99 depois de algum googling e meter a Shape para poder ser inicializada (maior parte foi pesquisa)

abstract type AbstractShape end

position(s::AbstractShape) = (s.x, s.y)

struct Shape <: AbstractShape
    x::Real
    y::Real
end

struct Square <: AbstractShape
    x::Real
    y::Real
    side1::Real
    side2::Real
end

# position(s::Shape) = (s.x, s.y)
area(s::Square) = (s.side1 * s.side2)


# Test 5

# inicio
# 0:12.35 - fui procurar imaginarios no google
# 0:22.90 - voltei
# 1:30.38 - primeira solucao
# 2:38.13 - solucao arranjada depois de mudar o for para um while por causa do scope, e tinha <= em vez de <

function mandelbrot(limit, c)
    z = 0 + 0im
    i = 0
    while i < limit
        if abs(z) > 2
            return i
        end
        z = z * z + c
        i = i + 1
    end
    return i + 1
end

# Some tests to check for correctness

@assert(fib(0) == 1)
@assert(fib(1) == 1)
@assert(fib(10) == 89)
@assert(fib(20) == 10946)
# comb_sort
unsorted = [14, 11, 19, 5, 16, 10, 19, 12, 5, 12]
expected = [5, 5, 10, 11, 12, 12, 14, 16, 19, 19]
@assert(comb_sort(unsorted) == expected)
# binomial_coef
@assert(binomial_coef(0, 0) == 1)
@assert(binomial_coef(1, 1) == 1)
@assert(binomial_coef(100, 100) == 1)
@assert(binomial_coef(10, 6) == 210)
@assert(binomial_coef(20, 6) == 38760)
# Classes
# shape = Shape(1, 3)
# square = Square(2, 4, 5, 5)
# @assert(shape.position() == (1, 3))
# @assert(square.position() == (2, 4))
# @assert(square.area() == 25)
# Scopes
@assert(mandelbrot(1, 0.2 + 0.3im) == 2)
@assert(mandelbrot(5, 0.2 + 0.3im) == 6)
@assert(mandelbrot(6, 0.2 + 0.3im) == 7)
@assert(mandelbrot(10000, 1 + 0.3im) == 2)