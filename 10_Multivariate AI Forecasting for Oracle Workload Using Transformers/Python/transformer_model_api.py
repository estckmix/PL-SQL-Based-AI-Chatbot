from flask import Flask, request, jsonify
import torch
import numpy as np
import joblib
from transformers import TimeSeriesTransformerModel, TimeSeriesTransformerConfig

app = Flask(__name__)

# Load Model & Scaler
config = TimeSeriesTransformerConfig(d_model=128, n_heads=8, num_encoder_layers=4, num_decoder_layers=4, dropout=0.1, num_features=5)
model = TimeSeriesTransformerModel(config)
model.load_state_dict(torch.load("multivariate_transformer_workload.pth"))
model.eval()
scaler = joblib.load("multivariate_scaler.pkl")

@app.route('/predict_multivariate', methods=['POST'])
def predict():
    data = request.json['sequence']
    sequence = np.array(data).reshape(1, len(data), 5)  # 5 workload metrics
    sequence = torch.tensor(sequence, dtype=torch.float32)

    # Predict
    with torch.no_grad():
        prediction = model(sequence).squeeze().numpy()

    # Convert back to original scale
    predicted_values = scaler.inverse_transform([prediction])

    return jsonify({
        'CPU Usage (%)': predicted_values[0][0],
        'Active Sessions': predicted_values[0][1],
        'Buffer Cache Hit Ratio': predicted_values[0][2],
        'Disk I/O Throughput': predicted_values[0][3],
        'Redo Log Wait Time': predicted_values[0][4]
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)