CREATE TABLE workload_forecast (
    forecast_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    metric_name VARCHAR2(100),
    predicted_value NUMBER,
    forecast_time TIMESTAMP DEFAULT SYSTIMESTAMP
);
