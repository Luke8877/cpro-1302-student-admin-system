--TODO Implement function

CREATE OR REPLACE FUNCTION convert_grade (
    p_grade IN NUMBER
)
RETURN VARCHAR2
IS
    v_letter_grade VARCHAR2(1);
BEGIN
    IF p_grade >= 90 THEN
            RETURN 'A';
        ELSIF p_grade >= 80 THEN
            RETURN 'B';
        ELSIF p_grade >= 70 THEN
            RETURN 'C';
        ELSIF p_grade >= 60 THEN
            RETURN 'D';
        ELSE
            RETURN 'F';
    END IF;
   
END;
/