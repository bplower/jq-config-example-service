
from setuptools import setup

setup(
    name = 'example_service',
    version = '0.1.0',
    description = 'An example API service for demonstrating jq templated configs',
    author = 'Brahm Lower',
    author_email = 'bplower@gmail.com',

    packages = ['example_service'],
    package_dir = {'example_service': 'src'},
    install_requires = [
        'Flask'
    ]
)
