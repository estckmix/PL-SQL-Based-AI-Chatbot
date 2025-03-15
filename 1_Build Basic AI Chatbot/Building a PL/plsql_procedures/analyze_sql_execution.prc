CREATE OR REPLACE PROCEDURE analyze_sql_execution(p_sql_query IN VARCHAR2, p_suggestions OUT CLOB) IS
    v_plan_table SYS.DBMS_XPLAN_TYPE_TABLE;
BEGIN
    -- Generate an execution plan
    EXECUTE IMMEDIATE 'EXPLAIN PLAN FOR ' || p_sql_query;
    
    -- Fetch the plan
    SELECT * BULK COLLECT INTO v_plan_table FROM TABLE(DBMS_XPLAN.DISPLAY);
    
    -- Analyze for optimization suggestions
    p_suggestions := 'Execution Plan: ' || CHR(10) || LISTAGG(v_plan_table.plan_table_output, CHR(10)) WITHIN GROUP (ORDER BY NULL);
    
    IF p_suggestions LIKE '%FULL TABLE SCAN%' THEN
        p_suggestions := p_suggestions || CHR(10) || 'Optimization Tip: Consider adding indexes to avoid full table scans.';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        p_suggestions := 'Error analyzing execution plan: ' || SQLERRM;
END analyze_sql_execution;
/
