# MLOps Personal Template

[![Python application](https://github.com/mboukabous/functions-from-zero-mlops2/actions/workflows/main.yml/badge.svg)](https://github.com/mboukabous/functions-from-zero-mlops2/actions/workflows/main.yml)

## Configure Development Environment

- Create devcontainer (shift+cmd+p) -> https://containers.dev/features
- Add Extensions
```bash
{
	"name": "Ubuntu",
	"image": "mcr.microsoft.com/vscode/devcontainers/universal:linux",
	"features": {
		"ghcr.io/devcontainers/features/aws-cli:1": {}
	},
	"customizations": {
		"vscode": {
			"extensions": [
				"GitHub.copilot",
				"ms-vscode.makefile-tools",
				"ms-azuretools.vscode-docker",
				"ms-python.python"
			]
		}
	}
}
```

- touch Makefile + requirements.txt
```bash
env-config:
	@echo "Creating virtual environment..."
	python3 -m venv .venv
	@echo "✅ Environment ready. Now run:"
	@echo "   source .venv/bin/activate"

install:
	@echo "Installing dependencies..."
	pip install --upgrade pip
	pip install -r requirements.txt
	@echo "✅ Dependencies installed."

container-build:
	@read -p "Enter image name (lowercase): " IMAGE_NAME; \
	echo "🔧 Building Docker image '$$IMAGE_NAME'..."; \
	docker build -t $$IMAGE_NAME .; \
	echo "📦 Listing Docker images..."; \
	docker image ls; \
	echo "🚀 Run with: docker run -p 127.0.0.1:8080:8080 $$IMAGE_NAME"; \
	echo "✅ Done."

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

config: env-config install aws-config

all: install lint test format deploy
```
```
pytest
pytest-cov
pylint
black
fire
fastapi
uvicorn[standard]
pydantic
boto3
...
```

- Create virtual environment: `python -m venv .venv`
- Modify: `vim ~/.bashrc` with `:wq`
- Add: `source .venv/bin/activate`

- Aws configs
`mkdir ~/.aws`
`vim ~/.aws/credentials`
```bash
[default]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET
```

`vim ~/.aws/config`
```bash
[default]
region=us-east-1
```

## Interactive debugging

```python
import ipdb
ipdb.set_trace()
```

## Create Action File (main.yml)

```bash
name: Python application

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python 3.12
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install dependencies
        run: make install

      - name: Format code
        run: make format

      - name: Lint with pylint
        run: make lint

      - name: Test with pytest
        run: make test
```

## Build a library and use it

- `mkdir myLib`
- `touch myLib/__init__.py`
- `touch (necessary python libraries for the project)`

## Build a FastAPI script

- `touch main.py`
```python
from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
from mylib.module import function

app = FastAPI()

class ClassName(BaseModel):
    attr1: str
    attr2: int

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/link")
async def function_cli(var: ClassName):
    result = function(var.attr1, var.attr2)
    payload = {"Result": result}
    return payload

if __name__ == "__main__":
    uvicorn.run(app, port=8080, host='0.0.0.0')
```

- `touch invoke.sh`
```bash
curl -X 'POST' \
  'http://0.0.0.0:8080/function' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "attr1": "abc",
  "attr2": xyz
}'
```

## Create a docker file

- `touch Dockerfile`
```bash
FROM public.ecr.aws/lambda/python:3.12

RUN mkdir -p /app
COPY ./requirements.txt /app/
COPY ./main.py /app/
COPY ./myLib /app/myLib
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
WORKDIR /app
EXPOSE 8080
CMD [ "main.py" ]
ENTRYPOINT [ "python" ]
```

- `docker build .`
- `docker image ls`
- `docker run -p 127.0.0.1:8080:8080 ImageID`
- Test it: `bash invoke.sh`

## ECR

- Deploy the container to AWS ECR using the commands in ECR
- Fill in the deploy section in Makefile then in actions (main.yml)
- TODO: auto creation of ECR using a scripts
