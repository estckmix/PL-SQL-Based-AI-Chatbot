CREATE VIEW chatbot_review_queue AS
SELECT question, COUNT(*) AS low_rating_count
FROM chatbot_feedback
WHERE user_rating <= 2
GROUP BY question
HAVING COUNT(*) > 5;