CREATE OR REPLACE FUNCTION get_best_match(p_user_query IN VARCHAR2) RETURN VARCHAR2 IS
    v_best_match VARCHAR2(500);
    v_score NUMBER;
BEGIN
    -- Find the best match based on Oracle Text search
    SELECT question INTO v_best_match 
    FROM chatbot_knowledge_base
    WHERE CONTAINS(question, p_user_query) > 0 
    ORDER BY SCORE(1) DESC
    FETCH FIRST 1 ROW ONLY;

    RETURN v_best_match;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END get_best_match;
/
