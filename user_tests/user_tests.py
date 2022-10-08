
##############################
# Recursion
##############################
# What I expect:
# - Equivalent translation to Julia
# - Translation of int --> (Int, Int32, Int64)?
def fib(i: int) -> int:
    if i == 0 or i == 1:
        return 1
    return fib(i - 1) + fib(i - 2)

##############################
# Data sructures
##############################
# What I expect:
# - Ranges should be adjusted to match Julia's 1-indexed arrays
# - Translation of int --> (Int, Int32, Int64)?
# Syntax swap:
# - "or" conditional operation to "||"
from math import floor
def comb_sort(seq: list[int]) -> list[int]:
    gap = len(seq)
    swap = True
    while gap > 1 or swap:
        gap = max(1, floor(gap / 1.25))
        swap = False
        for i in range(len(seq) - gap):
            if seq[i] > seq[i + gap]:
                seq[i], seq[i + gap] = seq[i + gap], seq[i]
                swap = True
    return seq

# What I expect:
# - Identify and replace the multidimensional list comprehension for a Julia Matrix
# - Ranges should be adjusted to match Julia's 1-indexed arrays
# - Translation of int --> (Int, Int32, Int64)?
# Syntax swap:
# - "or" conditional operation to "||"
def binomial_coef(n: int, k: int):
    C = [[0 for x in range(k + 1)] for x in range(n + 1)]
    for i in range(n + 1):
        for j in range(min(i, k) + 1):
            if j == 0 or j == i:
                C[i][j] = 1
            else:
                C[i][j] = C[i - 1][j - 1] + C[i - 1][j]
    return C[n][k]

##############################
# Classes
##############################
# What I expect:
# - Creation of two structs, Shape and Square to hold class fields 
# (a.k.a, those referenced by self in Python)
# - Creation of a hierarchy of abstract types to simulate inheritance
# - Self argument can be translated with dipatch on abstract types that correspond to class
# - String interpolation to rplace f-strings 
class Shape():
    def __init__(self, x, y):
        # Center on a 2-dimensional plane
        self.x = x
        self.y = y

    def position(self):
        return (self.x, self.y)

class Square(Shape):
    """Two-dimensional square"""
    def __init__(self, x, y, side1, side2):
        super().__init__(x, y)
        self.side1 = side1
        self.side2 = side2

    def area(self):
        return self.side1 * self.side2


##############################
# Scopes
##############################
# What I expect:
# - Identification that variable i is used in a hard 
# scope when translated to Julia. A local variable must 
# be created in the "mandelbrot" function
def mandelbrot(limit, c):
    z = 0 + 0j
    for i in range(limit + 1):
        if abs(z) > 2:
            return i
        z = z * z + c
    return i + 1


###################################################
# Optional

##############################
# Generator Functions
##############################
# What I expect:
# - Translation of Python's generators to Julia's channels
def fib_generators():
    a = 0
    b = 1
    while True:
        yield a
        a, b = b, a + b

# As an extra challenge: translate binary trees

if __name__ == "__main__":
    # Fibonacci
    assert fib(1) == 1
    assert fib(10) == 89
    assert fib(20) == 10946
    # comb_sort
    unsorted = [14, 11, 19, 5, 16, 10, 19, 12, 5, 12]
    expected = [5, 5, 10, 11, 12, 12, 14, 16, 19, 19]
    assert comb_sort(unsorted) == expected
    # binomial_coef
    assert binomial_coef(0, 0) == 1
    assert binomial_coef(1, 1) == 1
    assert binomial_coef(100, 100) == 1
    assert binomial_coef(10, 6) == 210
    assert binomial_coef(20, 6) == 38760
    assert binomial_coef(4000, 6) == 5667585757783866000
    # Classes
    shape = Shape(1, 3)
    square = Square(2, 4, 5, 5)
    assert shape.position() == (1, 3)
    assert square.position() == (2, 4)
    assert square.area() == 25
    # Scopes
    assert mandelbrot(1, 0.2 + 0.3j) == 2
    assert mandelbrot(5, 0.2 + 0.3j) == 6
    assert mandelbrot(6, 0.2 + 0.3j) == 7
    assert mandelbrot(10000, 1 + 0.3j) == 2
    assert mandelbrot(10000, 0.6 + 0.4j) == 4
    # Generator Functions
    fib_arr = []
    fib_gen = fib_generators()
    for i in range(0, 6):
        fib_arr.append(fib_gen.__next__())
    assert fib_arr == [0, 1, 1, 2, 3, 5]



