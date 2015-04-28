from flask import Flask, make_response, request, jsonify
import pprint
import requests
import json

app = Flask(__name__)


def get_token():
    ''' Get a fresh auth token for Google api '''

    url = "https://accounts.google.com/o/oauth2/token"
    headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    data = {
        'client_id': "385694945364-4tuedte76t1u6jpd9gncv5fo4kokktk4.apps.googleusercontent.com",
        'client_secret': "pSeJEWlUIiZlpj_cYSpPyRXX",
        'refresh_token': "1/VKUiCYsw96HCzKYI4RH6qpY3TWvoI55HoJQzLI4ky_oMEudVrK5jSpoR30zcRFq6",
        'grant_type': 'refresh_token'
    }
    r = requests.post(url, headers=headers, data=data)
    tok = r.json()['access_token']
    return tok


def send_query(query):
    ''' Send the query to Google and return response object '''

    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}

    query['access_token'] = get_token()

    try:
        resp = requests.post('http://juliet:1082/query', data=json.dumps(query), headers=headers)
    except Exception as e:
        print(e.message)

    try:
        return resp.json()
    except ValueError:
        print(resp.text)


@app.route("/get_engine_data", methods=('GET', 'POST'))
def get_engine_data():

    query = json.loads(request.form['query']) or {}
    data = send_query(query) or {"error": "Internal Server Error"}

    response = make_response(jsonify(data))
    response.headers.add('Access-Control-Allow-Origin', 'null')

    return response



if __name__ == "__main__":
    app.run(debug=True)
