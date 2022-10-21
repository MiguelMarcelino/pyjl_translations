
# 0:37
fib(i::Int) = i==0 || i==1 ? 1 : fib(i-1) + fib(i-2)

################################
# 2:52
comb_sort(seq::Vector{Int}) =
    let gap = length(seq)
        swap = true
        while gap > 1 || swap
            gap = max(1, Int(floor(gap / 1.25)))
            swap = false
            for i in 1:(length(seq) - gap)
                if seq[i] > seq[i + gap]
                    seq[i], seq[i + gap] = seq[i + gap], seq[i]
                    swap = true
                end
            end
        end
        seq
    end

################################
# 9:59
binomial_coef(n::Int, k::Int) =
    let  C = [[0 for _ in 1:k+1] for _ in 1:n+1]
        for i in 1:n+1
            for j in 1:(min(i, k) + 1)
                if j == 1 || j == i
                    C[i][j] = 1
                elseif i-1 == 0 && j-1==0
                    C[i][j] = C[end][end] + C[end][j]
                elseif i-1 == 0
                    C[i][j] = C[end][j-1] + C[end][j]
                elseif i-1 == 0
                    C[i][j] = C[i-1][end] + C[i-1][j]
                else
                    C[i][j] = C[i-1][j-1] + C[i-1][j]
                end
            end
        end
        C[n+1][k+1]
    end

################################
# 4:39
struct Shape
    x
    y
end

position(s::Shape) = (s.x, s.y)

struct Square
    x
    y
    side1
    side2
end

position(s::Square) = (s.x, s.y)
area(s::Square) = s.side1 * s.side2


################################
# 3:46
mandelbrot(limit, c) =
    let z = 0 + 0im
        a = 0
        for i in 0:limit
            a = i
            if abs(z) > 2
                return i
            end
            z = z * z + c
        end
        return a + 1
    end

##


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
shape = Shape(1, 3)
square = Square(2, 4, 5, 5)
@assert(position(shape) == (1, 3))
@assert(position(square) == (2, 4))
# Scopes
@assert(mandelbrot(1, 0.2 + 0.3im) == 2)
@assert(mandelbrot(5, 0.2 + 0.3im) == 6)
@assert(mandelbrot(6, 0.2 + 0.3im) == 7)
@assert(mandelbrot(10000, 1 + 0.3im) == 2)