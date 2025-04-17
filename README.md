# functions-from-zero-mlops2

[![Python application](https://github.com/mboukabous/functions-from-zero-mlops2/actions/workflows/main.yml/badge.svg)](https://github.com/mboukabous/functions-from-zero-mlops2/actions/workflows/main.yml)

## Configure Development Environment

- Create devcontainer (shift+cmd+p)
- Add Extensions
- touch Makefile + requirements.txt
```bash
install:
	pip install --upgrade pip
	pip install -r requirements.txt

test:
	python -m pytest -vv --cov=Project test_*.py myLib/test_*.py

format:
	black *.py myLib/*.py

lint:
	pylint --disable=R,C --ignore-pattern=test_*.py *.py myLib/*.py

refactor: format lint

deploy:
	echo "Deploying to production..."
	# Add your deployment commands here

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
