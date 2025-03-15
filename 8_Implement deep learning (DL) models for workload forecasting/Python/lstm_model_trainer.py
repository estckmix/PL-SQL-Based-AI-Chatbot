import pandas as pd
import numpy as np
import cx_Oracle
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
from sklearn.preprocessing import MinMaxScaler
import joblib

# Connect to Oracle & Load Data
dsn = cx_Oracle.makedsn("your_db_host", "your_db_port", "your_db_service")
conn = cx_Oracle.connect("your_username", "your_password", dsn)
query = "SELECT metric_value, collection_time FROM workload_time_series"
df = pd.read_sql(query, conn)
conn.close()

# Convert timestamp to UNIX time
df['timestamp'] = pd.to_datetime(df['collection_time']).astype(int) / 10**9
df = df.sort_values(by='timestamp')

# Normalize values for stable training
scaler = MinMaxScaler()
df['scaled_metric'] = scaler.fit_transform(df[['metric_value']])

# Convert into sequences
sequence_length = 24  # Using last 24 readings (past hour if sampled every 2.5 minutes)
X, y = [], []

for i in range(len(df) - sequence_length):
    X.append(df['scaled_metric'].iloc[i:i+sequence_length].values)
    y.append(df['scaled_metric'].iloc[i+sequence_length])

X, y = np.array(X), np.array(y)
X = X.reshape(X.shape[0], X.shape[1], 1)  # Reshape for LSTM

# Train/Test Split
train_size = int(len(X) * 0.8)
X_train, X_test = X[:train_size], X[train_size:]
y_train, y_test = y[:train_size], y[train_size:]

# Build LSTM Model
model = Sequential([
    LSTM(64, return_sequences=True, input_shape=(X.shape[1], 1)),
    LSTM(32),
    Dense(16, activation='relu'),
    Dense(1)
])

model.compile(optimizer='adam', loss='mse')
model.fit(X_train, y_train, epochs=30, batch_size=16, validation_data=(X_test, y_test))

# Save Model & Scaler
model.save("lstm_workload_forecast.h5")
joblib.dump(scaler, "scaler.pkl")