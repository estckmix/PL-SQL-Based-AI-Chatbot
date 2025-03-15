CREATE OR REPLACE FUNCTION ml_forecast_transformer (
    p_metric_name VARCHAR2
) RETURN NUMBER IS
    v_response CLOB;
    v_sequence CLOB;
    v_api_url VARCHAR2(500) := 'http://your_python_server:5000/predict_transformer';
    v_prediction NUMBER;
BEGIN
    -- Fetch last 24 workload values with day & hour
    SELECT JSON_ARRAYAGG(JSON_OBJECT('metric_value' VALUE metric_value, 'day_of_week' VALUE day_of_week, 'hour_of_day' VALUE hour_of_day) ORDER BY collection_time) 
    INTO v_sequence
    FROM (SELECT metric_value, day_of_week, hour_of_day 
          FROM workload_time_series 
          WHERE metric_name = p_metric_name 
          ORDER BY collection_time DESC FETCH FIRST 24 ROWS ONLY);

    -- Call Transformer API
    v_response := http_request(v_api_url, 'POST', '{"sequence": ' || v_sequence || '}');

    -- Extract predicted value
    v_prediction := JSON_VALUE(v_response, '$.predicted_value');

    RETURN v_prediction;
END ml_forecast_transformer;
/
