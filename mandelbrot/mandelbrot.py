# The Computer Language Benchmarks Game
# https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
#
# contributed by Joerg Baumann

from contextlib import closing
from itertools import islice
import sys


# @resumable
def pixels(y: int, n: int, abs):
    range7 = bytearray(range(7))
    pixel_bits = bytearray(128 >> pos for pos in range(8))
    c1 = 2.0 / float(n)
    c0 = -1.5 + 1j * y * c1 - 1j
    x = 0
    while True:
        pixel = 0
        c = x * c1 + c0
        for pixel_bit in pixel_bits:
            z = c
            for _ in range7:
                for _ in range7:
                    z = z * z + c
                if abs(z) >= 2.0:
                    break
            else:
                pixel += pixel_bit
            c += c1
        yield pixel
        x += 8


def compute_row(p: tuple[int, int]):
    y, n = p

    result = bytearray(islice(pixels(y, n, abs), (n + 7) // 8))
    result[-1] &= 0xFF << (8 - n % 8)
    return y, result


# @resumable(lower_yield_from=True)
def compute_rows(n: int, f):
    row_jobs = ((y, n) for y in range(n))
    yield from map(f, row_jobs)


def mandelbrot(n: int):
    write = sys.stdout.buffer.write

    with closing(compute_rows(n, compute_row)) as rows:
        write("P4\n{0} {0}\n".format(n).encode())
        for row in rows:
            write(row[1])


if __name__ == "__main__":
    mandelbrot(int(sys.argv[1]))
