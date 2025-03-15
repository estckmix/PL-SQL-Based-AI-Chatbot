CREATE OR REPLACE PROCEDURE generate_workload_forecast AS
BEGIN
    -- Predict CPU usage for the next hour
    INSERT INTO workload_forecast (metric_name, predicted_value)
    VALUES ('CPU Usage (%)', forecast_metric('CPU Usage (%)', INTERVAL '6' HOUR));

    -- Predict Active Sessions for the next hour
    INSERT INTO workload_forecast (metric_name, predicted_value)
    VALUES ('Active Sessions', forecast_metric('Active Sessions', INTERVAL '6' HOUR));

    -- Predict Memory Usage for the next hour
    INSERT INTO workload_forecast (metric_name, predicted_value)
    VALUES ('SGA Memory (MB)', forecast_metric('SGA Memory (MB)', INTERVAL '6' HOUR));

    COMMIT;
END generate_workload_forecast;
/
