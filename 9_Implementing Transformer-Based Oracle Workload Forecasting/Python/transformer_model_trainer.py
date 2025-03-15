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
query = "SELECT metric_value, day_of_week, hour_of_day FROM workload_time_series"
df = pd.read_sql(query, conn)
conn.close()

# Normalize values for stability
scaler = MinMaxScaler()
df[['metric_value', 'day_of_week', 'hour_of_day']] = scaler.fit_transform(df[['metric_value', 'day_of_week', 'hour_of_day']])

# Convert into sequences
sequence_length = 24  # Use past 24 readings for forecasting
X, y = [], []

for i in range(len(df) - sequence_length):
    X.append(df[['metric_value', 'day_of_week', 'hour_of_day']].iloc[i:i+sequence_length].values)
    y.append(df['metric_value'].iloc[i+sequence_length])

X, y = np.array(X), np.array(y)

# Convert to PyTorch tensors
X_train, y_train = torch.tensor(X[:-1000], dtype=torch.float32), torch.tensor(y[:-1000], dtype=torch.float32)
X_test, y_test = torch.tensor(X[-1000:], dtype=torch.float32), torch.tensor(y[-1000:], dtype=torch.float32)

# Transformer Model Configuration
config = TimeSeriesTransformerConfig(
    d_model=64,  # Hidden layer size
    n_heads=4,   # Number of attention heads
    num_encoder_layers=3,
    num_decoder_layers=3,
    dropout=0.1
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
torch.save(model.state_dict(), "transformer_workload.pth")
joblib.dump(scaler, "scaler.pkl")