import pytest
from app.utils import add

def test_add():
	assert add(2, 3) == 5, "2 + 3 = 5"
	assert add(-1, 1) == 0, "-1 + 1 = 0"
