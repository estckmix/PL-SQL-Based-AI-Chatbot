CREATE TABLE chatbot_logs (
    log_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_query    VARCHAR2(500),
    bot_response  CLOB,
    log_time      TIMESTAMP DEFAULT SYSTIMESTAMP
);