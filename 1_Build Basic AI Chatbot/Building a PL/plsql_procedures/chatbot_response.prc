CREATE OR REPLACE PROCEDURE chatbot_response(p_user_query IN VARCHAR2, p_response OUT CLOB) IS
    v_best_match VARCHAR2(500);
    v_answer CLOB;
BEGIN
    -- Try to find an exact match in the knowledge base
    SELECT answer INTO v_answer 
    FROM chatbot_knowledge_base 
    WHERE LOWER(question) = LOWER(p_user_query);

    p_response := v_answer;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Use Oracle Text to find the closest matching question
        SELECT question INTO v_best_match 
        FROM chatbot_knowledge_base 
        WHERE CONTAINS(question, p_user_query) > 0 
        FETCH FIRST 1 ROW ONLY;

        SELECT answer INTO v_answer FROM chatbot_knowledge_base WHERE question = v_best_match;

        p_response := v_answer;
    WHEN OTHERS THEN
        p_response := 'I am unable to process your query at the moment. Please try again later.';
END chatbot_response;
/