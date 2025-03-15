CREATE TABLE chatbot_query_clusters (
    cluster_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    base_question VARCHAR2(500),
    similar_question VARCHAR2(500)
);