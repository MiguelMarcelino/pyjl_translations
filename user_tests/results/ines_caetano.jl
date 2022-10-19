fib(i::Int) =
    if i == 0 || i == 1
        1
    else
        fib(i - 1) + fib(i - 2)
    end

# Teste 1: 1 min 21 seg

comb_sort(seq::Array{Int64}) =
    let gap = length(seq)
        swap = true
        while gap < 1 || swap
            gap = max(1, floor(Int, gap / 1.25))
            swap = false
            for i in 1:length(seq) - gap
                if seq[i]  > seq[i + gap]
                    seq[i], seq[i + gap] = seq[i + gap], seq[i]
                    swap = true
                end
            end
        end
        seq
    end


# Teste 2: 6 min 40 seg

binomial_coef(n::Int, k::Int) =
    let C = [[0 for x in 0:k+1] for x in 0:n+1]
        for i in 1:n+1
            for j in 1:min(i, k)+1
                if j == 0 || j == i
                    C[i][j] = 1
                else
                    C[i][j] = C[i - 1][j - 1] + C[i - 1][j]
                end
            end
        end
        C[n+1][k+1]
    end

@assert binomial_coef(0, 0) == 1
@assert binomial_coef(1, 1) == 1
@assert binomial_coef(100, 100) == 1
@assert binomial_coef(10, 6) == 210
@assert binomial_coef(20, 6) == 38760

# teste 3: 3 min

# struct Shape
#     __init__(self, x, y) =
#         let self.x, self.y = x, y
#         end

#     position(self) = (self.x, self.y)
# end

# struct Square
#     __init__(self, x, y, side1, side2) =
#         let super().__init__(x, y)
#             self.side1 = side1
#             self.side2 = side2
#         end

#     area(self) = self.side1 * self.side2
# end

#Teste 4: 3 min 43 seg

mandelbrot(limit, c) =
    let z = 0 + 0im
         for i in 0:limit+1
             if abs(z) > 2
                 i
            else
                z = z*z+c
            end
            i+1
        end
    end

# Test 5: 1 min 42 seg

# @assert mandelbrot(5, 0.2 + 0.3im) == 6
