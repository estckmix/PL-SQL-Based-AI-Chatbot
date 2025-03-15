CREATE OR REPLACE PROCEDURE chatbot_logger(p_user_query IN VARCHAR2, p_bot_response IN CLOB) IS
BEGIN
    INSERT INTO chatbot_logs (user_query, bot_response) 
    VALUES (p_user_query, p_bot_response);
    
    COMMIT;
END chatbot_logger;
/