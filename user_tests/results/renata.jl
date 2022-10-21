
fib(i::Int64) =
    if i == 0 || i == 1
        1
    else
        fib(i - 1) + fib(i - 2)
    end

fib(5)
fib(8)

# Time 1:27.09

comb_sort(seq::Vector{Int64}) =
    let gap = length(seq) 
        swap = true
        while gap > 1 || swap
            gap = max(1, floor(Int, gap / 1.25))
            swap = false
            for i in 0:length(seq)-1 - gap
                if seq[i+1] > seq[i+1 + gap]
                    seq[i+1], seq[i+1 + gap] = seq[i+1 + gap], seq[i+1]
                    swap = true
                end
            end
        end
        seq
    end

comb_sort([1,6,7,9,5,4,2,2])

# Time 8:54.84

binomial_coef(n::Int64, k::Int64) =
    let C = [[0 for x in 0:k] for x in 0:n]
        for i in 1:n+1
            for j in 1:min(i, k)+1
                if j == 1 || j == i
                    C[i][j] = 1
                elseif i-1 == 0 || j-1 == 0
                    nothing
                else
                    C[i][j] = C[i-1][j-1] + C[i-1][j]
                end
            end
        end
        C[n+1][k+1]
    end

binomial_coef(8, 2)
binomial_coef(2, 8)
binomial_coef(8, 8)

# Time 25:41.65

abstract type AbstractShape end
abstract type AbstractSquare <: AbstractShape end

struct Shape <: AbstractShape
    # Center on a 2-dimensional plane
    x
    y
end

position(shape::Shape) = (shape.x, shape.y)

struct Square <: AbstractSquare
    """Two-dimensional square"""
    side1
    side2
end

area(square::Square) = square.side1 * square.side2

s = Shape(2,3)
position(s)
q = Square(3,4)
area(q)

# Time 8:50.00

mandelbrot(limit, c) =
    let z = 0 + 0im
        i = 0
        for j in 0:limit
            if abs(z) > 2
                return j
            end
            z = z * z + c
            i = j
        end
        i + 1
    end

mandelbrot(1, 0.2 + 0.3im)
mandelbrot(5, 0.2 + 0.3im)
mandelbrot(6, 0.2 + 0.3im)
mandelbrot(6, 0.2 + 0.3)

# Time 16:54.63