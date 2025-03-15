from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Load trained model
model = joblib.load("workload_forecast_model.pkl")

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    timestamp = np.array(data['timestamp']).reshape(-1, 1)
    prediction = model.predict(timestamp)
    return jsonify({'predicted_value': prediction.tolist()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
