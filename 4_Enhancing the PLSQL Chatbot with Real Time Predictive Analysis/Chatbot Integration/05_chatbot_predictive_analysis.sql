SET SERVEROUTPUT ON;
DECLARE
    v_response CLOB;
BEGIN
    chatbot_performance_check('How is my database performance?', v_response);
    DBMS_OUTPUT.PUT_LINE('Chatbot Response: ' || v_response);
END;
/