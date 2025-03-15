from flask import Flask, request, jsonify
import torch
import numpy as np
import joblib
from transformers import TimeSeriesTransformerModel, TimeSeriesTransformerConfig

app = Flask(__name__)

# Load Model & Scaler
config = TimeSeriesTransformerConfig(d_model=64, n_heads=4, num_encoder_layers=3, num_decoder_layers=3, dropout=0.1)
model = TimeSeriesTransformerModel(config)
model.load_state_dict(torch.load("transformer_workload.pth"))
model.eval()
scaler = joblib.load("scaler.pkl")

@app.route('/predict_transformer', methods=['POST'])
def predict():
    data = request.json['sequence']
    sequence = np.array(data).reshape(1, len(data), 3)  # 3 features: metric_value, day_of_week, hour_of_day
    sequence = torch.tensor(sequence, dtype=torch.float32)

    # Predict
    with torch.no_grad():
        prediction = model(sequence).squeeze().numpy()

    # Convert back to original scale
    predicted_value = scaler.inverse_transform([[prediction]])[0][0]

    return jsonify({'predicted_value': predicted_value})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
