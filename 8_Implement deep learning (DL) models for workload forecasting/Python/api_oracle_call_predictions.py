from flask import Flask, request, jsonify
import numpy as np
import joblib
import tensorflow as tf

app = Flask(__name__)

# Load LSTM Model & Scaler
model = tf.keras.models.load_model("lstm_workload_forecast.h5")
scaler = joblib.load("scaler.pkl")

@app.route('/predict_lstm', methods=['POST'])
def predict():
    data = request.json['sequence']
    
    # Convert data to numpy array & reshape for LSTM
    sequence = np.array(data).reshape(1, len(data), 1)

    # Predict
    prediction = model.predict(sequence)
    
    # Convert back to original scale
    predicted_value = scaler.inverse_transform(prediction)[0][0]
    
    return jsonify({'predicted_value': predicted_value})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
