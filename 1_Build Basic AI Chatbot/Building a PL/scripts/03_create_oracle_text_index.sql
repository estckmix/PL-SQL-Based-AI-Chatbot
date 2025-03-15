BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX chatbot_idx ON chatbot_knowledge_base (question) 
    INDEXTYPE IS CTXSYS.CONTEXT';
END;
/