def mandelbrot(limit, c) -> int:
    z = 0 + 0j
    for i in range(limit + 1):
        if abs(z) > 2:
            return i
        z = z * z + c
    return i + 1
