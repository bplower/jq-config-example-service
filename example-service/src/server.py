import json
from flask import Flask
from flask import Response
from flask import request

class ExampleService(Flask):
    def __init__(self, app_config):
        super().__init__(__name__)
        # Service management routes
        self.route('/')(self.index)
        self.route('/health')(self.health)
        # Read the configuration file
        self.app_config = app_config

    # Business routes ----------------------------------------------------------

    def index(self):
        content = json.dumps({
            'message': 'ExampleService {}'.format('0.1.0')
        })
        return Response(content, mimetype='application/json')

    def health(self):
        # This isn't really the sort of content that would go in a health check
        # but it doesn't really matter for this test case
        response_dict = {
            'success': True,
            'response': {
                'app_database': 'okay',
                'vendor_database': 'okay',
                'external_service': 'okay',
                'redis': 'okay'
            }
        }
        # This is obv not how implementing debug settings in an API would be
        # implemented, but works well for testing w/ postman. Also the 'X-Header'
        # pattern was apparently depricated in 2012
        if request.headers.get('X-Debug') is not None:
            response_dict['debug'] = {
                'config': self.app_config
            }
        return Response(
            json.dumps(response_dict),
            mimetype='application/json'
        )
