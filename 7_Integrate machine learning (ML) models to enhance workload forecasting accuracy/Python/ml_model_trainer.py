import pandas as pd
import cx_Oracle
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
import joblib

# Connect to Oracle Database
dsn = cx_Oracle.makedsn("your_db_host", "your_db_port", "your_db_service")
conn = cx_Oracle.connect("your_username", "your_password", dsn)
query = "SELECT metric_name, metric_value, collection_time FROM workload_history"
df = pd.read_sql(query, conn)
conn.close()

# Convert timestamps to numerical values
df['timestamp'] = pd.to_datetime(df['collection_time']).astype(int) / 10**9  # Convert to UNIX time

# Prepare features and labels
X = df[['timestamp']]
y = df['metric_value']

# Split into train and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train a model (RandomForest in this case)
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Save the trained model
joblib.dump(model, "workload_forecast_model.pkl")