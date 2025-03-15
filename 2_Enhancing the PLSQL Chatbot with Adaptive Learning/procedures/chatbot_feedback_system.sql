CREATE TABLE chatbot_feedback (
    id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    question     VARCHAR2(500),
    user_rating  NUMBER CHECK (user_rating BETWEEN 1 AND 5),  -- Rating scale: 1 (bad) - 5 (good)
    feedback     VARCHAR2(1000),
    feedback_time TIMESTAMP DEFAULT SYSTIMESTAMP
);