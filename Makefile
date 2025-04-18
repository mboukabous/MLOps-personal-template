env:
	@echo "Creating virtual environment..."
	python3 -m venv .venv
	@echo "✅ Environment ready. Now run:"
	@echo "   source .venv/bin/activate"

install:
	@echo "Installing dependencies..."
	pip install --upgrade pip
	pip install -r requirements.txt
	@echo "✅ Dependencies installed."

test:
	#python -m pytest -vv --cov=Project test_*.py myLib/test_*.py

format:
	black *.py myLib/*.py

lint:
	pylint --disable=R,C --ignore-pattern=test_*.py *.py myLib/*.py

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

refactor: format lint

aws-config:
	@mkdir -p ~/.aws
	@echo "Enter AWS Access Key ID:"; \
	read AWS_KEY; \
	echo "Enter AWS Secret Access Key:"; \
	read AWS_SECRET; \
	echo "Enter AWS Region (default: us-east-1):"; \
	read AWS_REGION; \
	AWS_REGION=$${AWS_REGION:-us-east-1}; \
	echo "[default]" > ~/.aws/credentials; \
	echo "aws_access_key_id = $$AWS_KEY" >> ~/.aws/credentials; \
	echo "aws_secret_access_key = $$AWS_SECRET" >> ~/.aws/credentials; \
	echo "[default]" > ~/.aws/config; \
	echo "region = $$AWS_REGION" >> ~/.aws/config; \
	echo "✅ AWS credentials configured successfully."

deploy:
	@echo "Deploying to production..."

all: install lint test format deploy