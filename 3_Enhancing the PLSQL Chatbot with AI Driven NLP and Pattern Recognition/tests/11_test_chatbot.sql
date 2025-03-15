SET SERVEROUTPUT ON;
DECLARE
    v_response CLOB;
BEGIN
    chatbot_response_ai('How do I optimize an index?', v_response);
    DBMS_OUTPUT.PUT_LINE('Chatbot Response: ' || v_response);
END;
/
