import json
import os

from flask import Flask, request, Response, send_from_directory
from flask_cors import CORS
from flask_htpasswd import HtPasswdAuth
from api.auth import Auth
from api.password import Password
from api.utils import Utils
from api.config import Config

app = Flask(__name__)
app.config['FLASK_HTPASSWD_PATH'] = \
    f'{str(os.path.dirname(os.path.realpath(__file__)))}/config/.htpasswd'
app.config['FLASK_SECRET'] = '8675309'
CORS(app)
htpasswd = HtPasswdAuth(app)


# The next two routes are for serving the app
@app.route('/')
def fwd_root():
    return root('index.html')


@app.route('/<path:path>')
def root(path):
    return send_from_directory('client', path)


@app.route('/js/<path:path>')
def rootjs(path):
    return send_from_directory('client/js', path)


@app.route('/css/<path:path>')
def rootcss(path):
    return send_from_directory('client/css', path)


@app.route('/ui/<path:path>')
def rootui(path):
    return send_from_directory('client/ui', path)


# jwt to access this thing with 4-27-21
@app.route('/auth', methods=['GET'])
@htpasswd.required
def get_token(user):
    if request.method == 'GET':
        return format_return(Auth.get_token())
    return 'access to that route not allowed', 204


# get the whole thing -- limit to get for now since config is assembled
@app.route('/config', methods=['GET'])
@htpasswd.required
def get_config(user):
    if request.method == 'GET':
        config = Config.get_config()
        config['users'] = Password.get_users()
        return format_return(config)
    return 'access to that route not allowed', 204


@app.route('/config/features', methods=['GET'])
@htpasswd.required
def get_features(user):
    if request.method == 'GET':
        return format_return(Config.get_features())
    return 'access to that route not allowed', 204


@app.route('/config/server', methods=['GET', 'PUT'])
@htpasswd.required
def handle_server(user):
    if request.method == 'GET':
        return format_return(Config.get_server())
    elif request.method == 'PUT':
        return format_return(Config.put_server(request.get_json()))
    return 'access to that route not allowed', 204



@app.route('/config/enabled', methods=['GET', 'PUT'])
@htpasswd.required
def handle_enabled(user):
    if request.method == 'GET':
        return format_return(Config.get_enabled())
    elif request.method == 'PUT':
        return format_return(Config.put_enabled(request.get_json()))
    else:
        return 'access to that route not allowed', 204


@app.route('/config/things/<thing>', methods=['GET', 'PUT', 'DELETE'])
@htpasswd.required
def handle_thing(user, thing):
    if request.method == 'GET':
        return format_return(Config.get_thing(thing))
    elif request.method == 'PUT':
        return format_return(Config.put_thing(thing, request.get_json()))
    elif request.method == 'DELETE':
        return format_return(Config.delete_thing(thing))
    else:
        return 'access to that service not allowed', 204


@app.route('/config/helpers/<helper>', methods=['GET', 'PUT', 'DELETE'])
@htpasswd.required
def handle_helpers(user, helper):
    if request.method == 'GET':
        return format_return(Config.get_helper(helper))
    elif request.method == 'PUT':
        return format_return(Config.put_helper(helper, request.get_json()))
    elif request.method == 'DELETE':
        return format_return(Config.delete_helper(helper))
    else:
        return 'access to that service not allowed', 204


@app.route('/config/pip/<package>', methods=['GET', 'PUT', 'DELETE'])
@htpasswd.required
def handle_pip(user, package):
    if request.method == 'GET':
        if package != '--list--':
            return format_return(Utils.get_pip(package))
        else:
            return format_return(Utils.get_pip_list())
    elif request.method == 'PUT':
        return format_return(Utils.put_pip(package))
    elif request.method == 'DELETE':
        return format_return(Utils.delete_pip(package))
    else:
        return 'access to that service not allowed', 204


@app.route('/<service>/<action>', methods=['GET'])
@htpasswd.required
def handle_service(user, service, action):
    if service in ['m2ag-thing', 'm2ag-indicator', 'nodered', 'motion', 'pigpiod']:
        # the service web component prefixes everything with m2ag-
        return format_return(Utils.service_action(service, action))
    else:
        return 'access to that service not allowed', 200


@app.route('/status/<service>', methods=['GET'])
@htpasswd.required
def handle_status(user, service):
    return format_return(Utils.service_status(service))


@app.route('/config/user/<id>', methods=['PUT', 'GET', 'POST', 'DELETE'])
@htpasswd.required
def handle_password(user, id):
    # TODO: add more user info - and permissions
    # id is not used
    if request.method == 'PUT':
        result = Password.change_password(request.get_json())
        htpasswd.load_users(app)
        return format_return(result)
    if request.method == 'GET':
        return format_return(Password.get_users())
    if request.method == 'POST':
        result = Password.add_user(request.get_json())
        htpasswd.load_users(app)
        return format_return(result)
    if request.method == 'DELETE':
        result = Password.delete_user(request.get_json())
        htpasswd.load_users(app)
        return format_return(result)
    return 'access to that route not allowed', 204


def format_return(data):
    return Response(json.dumps({'data': data}), mimetype='application/json')


# TODO: move to tornado app
if __name__ == '__main__':
    print('m2ag.labs webthings builder service beta 2.0')
    print('copyright 2021 https://m2aglabs.com')
    if os.path.isfile('config/ssl/server.crt') and os.path.isfile(
            'config/ssl/server.key'):
        context = ('config/ssl/server.crt', 'config/ssl/server.key')
        app.run(host='0.0.0.0', port=8443, ssl_context=context)
    else:
        app.run(host='0.0.0.0', port=8443)
