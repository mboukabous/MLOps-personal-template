install:
	pip install --upgrade pip
	pip install -r requirements.txt

test:
	#python -m pytest -vv --cov=Project test_*.py myLib/test_*.py

format:
	black *.py myLib/*.py

lint:
	pylint --disable=R,C --ignore-pattern=test_*.py *.py myLib/*.py

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

refactor: format lint

deploy:
	echo "Deploying to production..."
	# Add your deployment commands here

all: install lint test format deploy