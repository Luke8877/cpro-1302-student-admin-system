--TODO Implement procedure

CREATE OR REPLACE PROCEDURE show_missing_grades (
    p_start_date IN DATE DEFAULT NULL,
    p_end_date   IN DATE DEFAULT NULL
)
IS
    -- Cursor to fetch required records
    CURSOR c_missing_grades IS
        SELECT class_id,
               stu_id,
               status,
               enrollment_date
        FROM enrollments
        WHERE final_letter_grade IS NULL
        AND enrollment_date BETWEEN 
            NVL(p_start_date, ADD_MONTHS(SYSDATE, -12)) 
            AND 
            NVL(p_end_date, SYSDATE)
        ORDER BY enrollment_date DESC;
BEGIN
    -- Loop through results and display
    FOR rec IN c_missing_grades LOOP
        DBMS_OUTPUT.PUT_LINE(
            'CLASS_ID: ' || rec.class_id ||
            ' | STU_ID: ' || rec.stu_id ||
            ' | STATUS: ' || rec.status ||
            ' | ENROLLMENT_DATE: ' || TO_CHAR(rec.enrollment_date, 'YYYY-MM-DD')
        );
    END LOOP;
END;
/

SELECT * FROM Enrollments