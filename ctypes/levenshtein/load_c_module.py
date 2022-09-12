# Implementation from Guillaume Androz

import ctypes
import numpy as np


def load_module():
    cmodule = ctypes.cdll.LoadLibrary(
        "./levenshtein.so"
    )
    cmodule.levenshtein.argtypes = [
        ctypes.c_char_p,
        ctypes.c_char_p,
        ctypes.c_int,
        ctypes.c_int,
        ctypes.c_int,
    ]
    cmodule.levenshtein.restype = ctypes.c_int
    return cmodule


if __name__ == "__main__":
    cmodule = load_module()
    res = cmodule.levenshtein(
        "levenshtein".encode("utf-8"),
        "levenstein".encode("utf-8"),
        np.int32(1),
        np.int32(1),
        np.int32(2),
    )
    print(
        f"Levenshtein distance between 'levenshtein' and 'levenstein': {res}"
    )
