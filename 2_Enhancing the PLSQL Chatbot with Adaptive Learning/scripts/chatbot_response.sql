CREATE OR REPLACE PROCEDURE chatbot_response(p_user_query IN VARCHAR2, p_response OUT CLOB) IS
    v_best_match VARCHAR2(500);
    v_answer CLOB;
    v_count NUMBER;
BEGIN
    -- Check for an exact match
    SELECT answer, hit_count INTO v_answer, v_count 
    FROM chatbot_knowledge_base 
    WHERE LOWER(question) = LOWER(p_user_query);

    -- Update hit count
    UPDATE chatbot_knowledge_base 
    SET hit_count = v_count + 1, last_updated = SYSTIMESTAMP 
    WHERE LOWER(question) = LOWER(p_user_query);

    p_response := v_answer;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Try to find a close match using Oracle Text
        BEGIN
            SELECT question INTO v_best_match 
            FROM chatbot_knowledge_base 
            WHERE CONTAINS(question, p_user_query) > 0 
            FETCH FIRST 1 ROW ONLY;

            SELECT answer INTO v_answer FROM chatbot_knowledge_base WHERE question = v_best_match;
            
            p_response := v_answer;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Log unanswered question
                MERGE INTO chatbot_unanswered u
                USING (SELECT p_user_query AS question FROM dual) d
                ON (LOWER(u.question) = LOWER(d.question))
                WHEN MATCHED THEN
                    UPDATE SET u.asked_count = u.asked_count + 1, u.last_asked = SYSTIMESTAMP
                WHEN NOT MATCHED THEN
                    INSERT (question) VALUES (p_user_query);

                p_response := 'I am still learning. Your question has been logged for review.';
        END;
    WHEN OTHERS THEN
        p_response := 'I encountered an error. Please try again.';
END chatbot_response;
/