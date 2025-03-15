CREATE OR REPLACE PROCEDURE chatbot_response_ai(
    p_user_query IN VARCHAR2, 
    p_response OUT CLOB
) IS
    v_best_match VARCHAR2(500);
    v_answer CLOB;
    v_count NUMBER;
BEGIN
    -- Step 1: Exact Match
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
        -- Step 2: Use Oracle Text similarity search
        v_best_match := get_best_match(p_user_query);
        
        IF v_best_match IS NOT NULL THEN
            SELECT answer INTO v_answer FROM chatbot_knowledge_base WHERE question = v_best_match;
            p_response := v_answer;
        ELSE
            -- Step 3: Log unanswered question
            INSERT INTO chatbot_unanswered (question) VALUES (p_user_query);
            p_response := 'I am still learning. Your question has been logged for future learning.';
        END IF;
END chatbot_response_ai;
/
