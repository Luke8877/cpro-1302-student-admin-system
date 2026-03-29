
-- sequence for assignment identifier
CREATE SEQUENCE ASSESSMENT_ID_SEQ
START WITH 1
INCREMENT BY 1;

-- procedure for creating assignment
CREATE OR REPLACE PROCEDURE create_assignment(
    p_desc IN VARCHAR2
)
IS
BEGIN
    INSERT INTO Assessments (
        assessment_id,
        description
    )
    VALUES (
        ASSESSMENT_ID_SEQ.NEXTVAL,
        p_desc
    );
    
    DBMS_OUTPUT.PUT_LINE('Assignment created successfully.');
END;
/


