#!flask/bin/python
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def call_model(date):
    return {
        'guests': 34,
        'distribution': [16,43]
    }

@app.route('/api/v1.0/guests', methods=['GET'])
def get_tasks():
    return jsonify(call_model("date"))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081, debug=True)

