from typing import List


def mult_int_and_int():
    a = 2
    return a * 2


def mult_float_and_int():
    a = 2.0
    return a * 2


def mult_string_and_int():
    a: str = "test"
    return a * 2


def mult_int_and_string():
    a: int = 2
    return a * "test"


def mult_int_and_bool():
    a: bool = False
    return a * 1


def mult_bool_and_string():
    a: int = 1
    return a * False


def mult_list_and_int():
    a: List[int] = []
    for i in range(0, 10):
        a.append(i)

    # a: int = 2 # Should fail if uncommented
    return a * 2


def mult_tuple_and_int():
    mul_1 = (1,) * 2
    a = (1,)
    mul_2 = a * 2
    assert mul_1 == mul_2


def add_two_lists():
    a: List[int] = []
    b: List[int] = []
    for i in range(0, 10):
        a.append(i)
        b.append(i)

    return a + b


def and_op_int_and_int():
    a: int = 2
    return a & 2


def or_op_int_and_int():
    a: int = 2
    return a | 1


def arithmetic_shift_right_int_and_int():
    a: int = 2
    return a >> 1


def arithmetic_shift_left_int_and_int():
    a: int = 2
    return a << 1


def nested_bin_op():
    a: int = 10
    return a * (10 + 20) + a * (2 + (4 + (8 * (6 + 3))) * (80))


if __name__ == "__main__":
    assert mult_int_and_int() == 4
    assert mult_float_and_int() == 4.0
    assert mult_string_and_int() == "testtest"
    assert mult_int_and_string() == "testtest"
    assert mult_list_and_int() == [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
    ]
    assert add_two_lists() == [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
    ]
    assert mult_int_and_bool() == 0
    assert mult_bool_and_string() == 0
    assert and_op_int_and_int() == 2
    assert or_op_int_and_int() == 3
    assert arithmetic_shift_right_int_and_int() == 1
    assert arithmetic_shift_left_int_and_int() == 4
    assert nested_bin_op() == 61120
    mult_tuple_and_int()
