CREATE TABLE chatbot_unanswered (
    id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    question     VARCHAR2(500),
    asked_count  NUMBER DEFAULT 1,
    last_asked   TIMESTAMP DEFAULT SYSTIMESTAMP
);