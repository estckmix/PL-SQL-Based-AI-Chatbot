import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import cx_Oracle

# Connect to Oracle and fetch historical workload data
dsn = cx_Oracle.makedsn("DB_HOST", 1521, service_name="DB_SERVICE")
conn = cx_Oracle.connect(user="DB_USER", password="DB_PASS", dsn=dsn)

query = """
SELECT collection_time, cpu_usage, active_sessions, memory_usage
FROM system_performance_metrics
WHERE collection_time >= SYSDATE - 30
ORDER BY collection_time
"""

df = pd.read_sql(query, conn)
conn.close()

# Convert timestamps to numeric values for ML training
df['timestamp'] = (df['collection_time'] - df['collection_time'].min()).dt.total_seconds()

# Train a Linear Regression Model for CPU Usage
X = df[['timestamp']]
y_cpu = df['cpu_usage']

cpu_model = LinearRegression()
cpu_model.fit(X, y_cpu)

# Train a Linear Regression Model for Sessions
y_sessions = df['active_sessions']
sessions_model = LinearRegression()
sessions_model.fit(X, y_sessions)

# Train a Linear Regression Model for Memory Usage
y_memory = df['memory_usage']
memory_model = LinearRegression()
memory_model.fit(X, y_memory)

print("ML Models Trained Successfully!")