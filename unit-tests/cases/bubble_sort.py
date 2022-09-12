#!/usr/bin/env python3

from typing import List

# @offset_arrays # For PyJL
def bubble_sort(seq: List[int]) -> List[int]:
    l = len(seq)
    for _ in range(l):
        for n in range(1, l):
            if seq[n] < seq[n - 1]:
                seq[n - 1], seq[n] = seq[n], seq[n - 1]
    return seq


if __name__ == "__main__":
    unsorted = [14, 11, 19, 5, 16, 10, 19, 12, 5, 12]
    expected = [5, 5, 10, 11, 12, 12, 14, 16, 19, 19]

    assert bubble_sort(unsorted) == expected
    print("OK")
