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
            Instructors.instructor_name,
            compute_average_grade(Classes.class_id) AS average_grade --function call
        FROM Classes
        JOIN Courses ON
            Classes.course_id = Courses.course_id
        JOIN Sections ON
            Courses.section_code = Sections.section_code
        JOIN Instructors ON
            Classes.instr_id = Instructors.instructor_id
        JOIN Enrollments ON
            Classes.class_id = Enrollments.class_id
        WHERE Classes.start_date BETWEEN 
            MVL(p_start_date, ADD_MONTHS(SYSDATE,-12)) AND 
            MVL(p_end_date, SYSDATE);
BEGIN
    FOR rec IN c_class_offerings LOOP
        DBMS_OUTPUT.PUT_LINE(
            'CLASS_ID: ' || rec.class_id ||
            ' | START_DATE: ' || TO_CHAR(rec.start_date, 'YYYY-MM-DD') ||
            ' | COURSE_TITLE: ' || rec.course_title ||
            ' | SECTION_CODE: ' || rec.section_code ||
            ' | INSTRUCTOR: ' || rec.instructor_name ||
            ' | AVERAGE_GRADE: ' || ROUND(rec.average_grade, 2)
        );
    END LOOP;
END;
/
        