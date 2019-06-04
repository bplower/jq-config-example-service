import sys
import json

from .server import ExampleService

def load_config(cfg_path):
    try:
        with open(cfg_path, 'r') as stream:
            try:
                return json.loads(stream.read())
            except Exception as error:
                sys.exit(str(error))
    except FileNotFoundError:
        sys.exit("No such file or directory: '{}'".format(cfg_path))
    except:
        sys.exit("General error while opening config file: '{}'".format(cfg_path))

def build_app(settings_path="./settings.json"):
    """ Main entrypoint for ExampleService """
    app_config = load_config(settings_path)
    app = ExampleService(app_config)
    return app