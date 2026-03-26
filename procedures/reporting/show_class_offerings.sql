--TODO Implement procedure

CREATE OR REPLACE PROCEDURE show_class_offerings (
    p_start_date IN DATE DEFAULT NULL,
    p_end_date IN DATE DEFAULT NULL
)
IS
    -- cursor for retrieving class offerings within a certain time frame
    CURSOR c_class_offerings IS
        SELECT
            Classes.class_id,
            Classes.start_date,
            Courses.course_title,
            Sections.section_code,
            Instructors.first_name || ' ' || Instructors.last_name AS instructor_name,
            compute_average_grade(Classes.class_id) AS average_grade --function call
        FROM Classes
        JOIN Courses ON
            Classes.course_id = Courses.course_id
        JOIN Sections ON
            Courses.section_code = Sections.section_code
        JOIN Instructors ON
            Classes.instr_id = Instructors.instructor_id
        WHERE Classes.start_date BETWEEN 
            NVL(p_start_date, ADD_MONTHS(SYSDATE,-12)) AND 
            NVL(p_end_date, SYSDATE);
BEGIN
    FOR r IN c_class_offerings LOOP
        DBMS_OUTPUT.PUT_LINE(
            'CLASS_ID: ' || r.class_id ||
            ' | START_DATE: ' || TO_CHAR(r.start_date, 'YYYY-MM-DD') ||
            ' | COURSE_TITLE: ' || r.course_title ||
            ' | SECTION_CODE: ' || r.section_code ||
            ' | INSTRUCTOR: ' || r.first_name ||
            ' | AVERAGE_GRADE: ' || r.average_grade
        );
    END LOOP;
END;
/

SELECT * FROM Instructors
        