from utils import add
from main import add1

def test_add():
	assert add(2, 3) == 5, "db is reachable, select test is over"

def test_add1():
	assert add1(2, 3) == 1, "user1 is in the db, authorization test is over"
