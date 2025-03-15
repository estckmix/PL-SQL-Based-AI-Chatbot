CREATE OR REPLACE FUNCTION get_clustered_response(p_user_query IN VARCHAR2) RETURN CLOB IS
    v_best_match VARCHAR2(500);
    v_answer CLOB;
BEGIN
    -- Look for a match in the query clusters
    SELECT base_question INTO v_best_match 
    FROM chatbot_query_clusters 
    WHERE similar_question = p_user_query
    FETCH FIRST 1 ROW ONLY;

    -- Get the answer for the clustered question
    SELECT answer INTO v_answer FROM chatbot_knowledge_base WHERE question = v_best_match;

    RETURN v_answer;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END get_clustered_response;
/