
install:
	pip install .

uninstall:
	pip uninstall -y example-service

reinstall: uninstall install

run:
	gunicorn --bind 0.0.0.0:8000 'src:build_app()'
