CREATE OR REPLACE PACKAGE BODY chatbot_pkg AS

    PROCEDURE process_chatbot_query(p_user_query IN VARCHAR2, p_final_response OUT CLOB) IS
        v_response CLOB;
    BEGIN
        chatbot_response(p_user_query, v_response);
        
        -- Log the interaction
        chatbot_logger(p_user_query, v_response);
        
        p_final_response := v_response;
    END process_chatbot_query;

END chatbot_pkg;
/