CREATE OR REPLACE PACKAGE chatbot_pkg AS
    PROCEDURE process_chatbot_query(p_user_query IN VARCHAR2, p_final_response OUT CLOB);
END chatbot_pkg;
/
