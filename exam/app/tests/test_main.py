import pytest
from app.main import process_numbers

def test_process_numbers():
	assert process_numbers() == "Result = 12", "Result must be 'Result = 12'"
