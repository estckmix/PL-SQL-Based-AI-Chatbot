CREATE TABLE system_performance_metrics (
    metric_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    metric_name VARCHAR2(100),
    metric_value NUMBER,
    collection_time TIMESTAMP DEFAULT SYSTIMESTAMP
);
