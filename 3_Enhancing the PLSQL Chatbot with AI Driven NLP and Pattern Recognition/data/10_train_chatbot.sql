INSERT INTO chatbot_knowledge_base (question, answer)
SELECT DISTINCT question, 'Pending human review' 
FROM chatbot_unanswered
WHERE question NOT IN (SELECT question FROM chatbot_knowledge_base);