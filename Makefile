install:
	pip install --upgrade pip
	pip install -r requirements.txt

test:
	#python -m pytest -vv --cov=Project test_*.py

format:
	black *.py

lint:
	pylint --disable=R,C --ignore-pattern=test_*.py *.py

refactor: format lint

deploy:
	echo "Deploying to production..."
	# Add your deployment commands here

all: install lint test format deploy