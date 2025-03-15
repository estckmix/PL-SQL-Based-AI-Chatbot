CREATE OR REPLACE FUNCTION forecast_metric(
    p_metric_name VARCHAR2,
    p_timeframe INTERVAL DAY TO SECOND
) RETURN NUMBER IS
    v_forecast_value NUMBER;
BEGIN
    -- Calculate the moving average of the metric over the specified timeframe
    SELECT AVG(metric_value)
    INTO v_forecast_value
    FROM system_performance_metrics
    WHERE metric_name = p_metric_name
    AND collection_time >= SYSTIMESTAMP - p_timeframe;

    RETURN v_forecast_value;
END forecast_metric;
/
