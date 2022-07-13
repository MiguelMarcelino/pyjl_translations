function mandelbrot(limit, c)::Int
    z = 0 + 0im
    i = 0
    for _i = 0:limit
        i = _i
        if abs(z) > 2
            return i
        end
        z = z * z + c
    end
    return i + 1
end
