INSERT INTO chatbot_query_clusters (base_question, similar_question)
SELECT q1.question, q2.question
FROM chatbot_knowledge_base q1, chatbot_knowledge_base q2
WHERE q1.question <> q2.question
AND CONTAINS(q1.question, q2.question) > 0;