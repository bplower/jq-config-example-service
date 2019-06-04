
build:
	python setup.py sdist

install:
	pip install .

uninstall:
	pip uninstall -y example-service

reinstall: uninstall install

run:
	gunicorn --bind 0.0.0.0:8000 'example_service:build_app()'

run-dev:
	gunicorn --bind 0.0.0.0:8000 'src:build_app()'
