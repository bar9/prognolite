#!flask/bin/python
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def call_model(date):
    return {
        "noon": 56,
        "evening": 28,
        "date": date
    }

def train_model():
    pass

@app.route('/api/v1.0/guests/<string:date>', methods=['GET'])
def get_prediction(date):
    return jsonify(call_model(date))

if __name__ == '__main__':
    train_model()
    app.run(host='0.0.0.0', port=8081, debug=True)

