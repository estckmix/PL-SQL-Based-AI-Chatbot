CREATE OR REPLACE PROCEDURE send_alert_email(p_message IN VARCHAR2) AS
    v_mail_conn UTL_SMTP.connection;
    v_sender    VARCHAR2(100) := 'alert@yourcompany.com';
    v_recipient VARCHAR2(100) := 'dba@yourcompany.com';
    v_subject   VARCHAR2(100) := 'Database Performance Alert';
BEGIN
    -- Establish SMTP connection
    v_mail_conn := UTL_SMTP.open_connection('smtp.yourcompany.com', 25);
    UTL_SMTP.helo(v_mail_conn, 'yourcompany.com');
    UTL_SMTP.mail(v_mail_conn, v_sender);
    UTL_SMTP.rcpt(v_mail_conn, v_recipient);

    -- Send email
    UTL_SMTP.open_data(v_mail_conn);
    UTL_SMTP.write_data(v_mail_conn, 'Subject: ' || v_subject || CHR(13) || CHR(10));
    UTL_SMTP.write_data(v_mail_conn, 'Performance Alert: ' || p_message);
    UTL_SMTP.close_data(v_mail_conn);
    UTL_SMTP.quit(v_mail_conn);
END send_alert_email;
/
