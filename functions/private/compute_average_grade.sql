--TODO Implement Function

CREATE OR REPLACE FUNCTION compute_average_grade (
    p_class_id IN Classes.class_id%TYPE
)
RETURN number
IS
    v_avg_grade number;
BEGIN
    SELECT NVL(AVG(numeric_grade),0)
    INTO v_avg_grade
    FROM class_assessments
    WHERE class_id = p_class_id;
    RETURN v_avg_grade;
END compute_average_grade;
/
