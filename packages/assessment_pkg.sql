-- package specification
CREATE OR REPLACE PACKAGE assessment_pkg AS
    
    PROCEDURE create_assignment(
        p_desc IN VARCHAR2
    );
    
    PROCEDURE enter_student_grade(
        numeric_grade
    );
    
    FUNCTION convert_grade;
    
END assessment_pkg;
/

-- package body
CREATE OR REPLACE PACKAGE BODY assessment_pkg AS

END assessment_pkg;
/
