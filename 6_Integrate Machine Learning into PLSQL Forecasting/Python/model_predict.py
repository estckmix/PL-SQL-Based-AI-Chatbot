from datetime import datetime, timedelta

# Predict future workload 1 hour ahead
future_time = (datetime.now() - df['collection_time'].min()).total_seconds() + 3600

predicted_cpu = cpu_model.predict([[future_time]])[0]
predicted_sessions = sessions_model.predict([[future_time]])[0]
predicted_memory = memory_model.predict([[future_time]])[0]

# Insert the predictions into the Oracle database
conn = cx_Oracle.connect(user="DB_USER", password="DB_PASS", dsn=dsn)
cursor = conn.cursor()

insert_query = """
INSERT INTO workload_forecast (metric_name, predicted_value, forecast_time) 
VALUES (:1, :2, SYSTIMESTAMP)
"""

cursor.execute(insert_query, ('CPU Usage (%)', predicted_cpu))
cursor.execute(insert_query, ('Active Sessions', predicted_sessions))
cursor.execute(insert_query, ('SGA Memory (MB)', predicted_memory))

conn.commit()
conn.close()

print("Predictions Inserted into Oracle Successfully!")
