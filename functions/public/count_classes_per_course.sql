--TODO Implement function

CREATE OR REPLACE FUNCTION count_classes_per_course (
    p_course_id IN Classes.course_id%TYPE
)
RETURN number
IS
   v_row_count number;
BEGIN
    SELECT count(*)
    INTO v_row_count
    FROM Classes
    WHERE course_id = p_course_id;
    RETURN v_row_count;
END count_classes_per_course;
/