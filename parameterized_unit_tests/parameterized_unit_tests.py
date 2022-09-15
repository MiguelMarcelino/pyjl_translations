import pytest

def palindrome_detector(s: str):
    s = s.lower().replace(' ', '')
    return s == s[::-1]

@pytest.mark.parametrize("input,expected", [
    ("madam", True),
    ("false", False)])
def test_palindrome_detector(input, expected):
    assert palindrome_detector(input) == expected