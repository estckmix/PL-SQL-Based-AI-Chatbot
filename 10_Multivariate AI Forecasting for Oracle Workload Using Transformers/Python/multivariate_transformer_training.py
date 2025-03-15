import pandas as pd
import numpy as np
import cx_Oracle
import torch
from torch import nn, optim
from transformers import TimeSeriesTransformerModel, TimeSeriesTransformerConfig
from sklearn.preprocessing import MinMaxScaler
import joblib

# Connect to Oracle & Load Data
dsn = cx_Oracle.makedsn("your_db_host", "your_db_port", "your_db_service")
conn = cx_Oracle.connect("your_username", "your_password", dsn)

query = """
SELECT collection_time, metric_name, metric_value, day_of_week, hour_of_day
FROM workload_multivariate_series
"""

df = pd.read_sql(query, conn)
conn.close()

# Pivot table: Convert rows → columns (multivariate format)
df = df.pivot(index="collection_time", columns="metric_name", values="metric_value").reset_index()
df.fillna(method="ffill", inplace=True)  # Fill missing values

# Normalize values for stability
scaler = MinMaxScaler()
scaled_data = scaler.fit_transform(df.iloc[:, 1:])  # Exclude time column

# Convert into sequences
sequence_length = 24  # Use past 24 readings
X, y = [], []

for i in range(len(df) - sequence_length):
    X.append(scaled_data[i:i+sequence_length, :])  # Use all workload metrics
    y.append(scaled_data[i+sequence_length, :])    # Predict all workload metrics

X, y = np.array(X), np.array(y)

# Convert to PyTorch tensors
X_train, y_train = torch.tensor(X[:-1000], dtype=torch.float32), torch.tensor(y[:-1000], dtype=torch.float32)
X_test, y_test = torch.tensor(X[-1000:], dtype=torch.float32), torch.tensor(y[-1000:], dtype=torch.float32)

# Transformer Model Configuration (Multivariate)
config = TimeSeriesTransformerConfig(
    d_model=128,  # Larger hidden layer size
    n_heads=8,   # More attention heads for complex patterns
    num_encoder_layers=4,
    num_decoder_layers=4,
    dropout=0.1,
    num_features=X_train.shape[-1]  # Number of workload metrics
)

model = TimeSeriesTransformerModel(config)

# Training
criterion = nn.MSELoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

for epoch in range(50):
    model.train()
    optimizer.zero_grad()
    output = model(X_train).squeeze()
    loss = criterion(output, y_train)
    loss.backward()
    optimizer.step()
    print(f'Epoch {epoch+1}, Loss: {loss.item()}')

# Save Model & Scaler
torch.save(model.state_dict(), "multivariate_transformer_workload.pth")
joblib.dump(scaler, "multivariate_scaler.pkl")
