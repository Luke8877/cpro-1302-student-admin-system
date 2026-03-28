--TODO Implement package

-- package specifications
CREATE OR REPLACE PACKAGE reporting_pkg IS
    
    PROCEDURE show_missing_grades (
       p_start_date DATE DEFAULT NULL,
       p_end_date   DATE DEFAULT NULL
    );

    PROCEDURE show_class_offerings (
       p_start_date DATE DEFAULT NULL,
       p_end_date   DATE DEFAULT NULL
    );

    FUNCTION count_classes_per_course (
       p_course_id Classes.course_id%TYPE
    ) RETURN NUMBER;

END reporting_pkg;
/

--package body
CREATE OR REPLACE PACKAGE BODY reporting_pkg IS

    -- show missing grades procedure
    PROCEDURE show_missing_grades (
       p_start_date in date default null,
       p_end_date   in date default null
    ) 
    IS
        -- Cursor to fetch required records
        CURSOR c_missing_grades is
        SELECT class_id,
              stu_id,
              status,
              enrollment_date
        FROM enrollments
        WHERE final_letter_grade IS NULL
        AND enrollment_date BETWEEN nvl(
          p_start_date,
          add_months(
               sysdate,
               -12
            )
           ) AND nvl(
              p_end_date,
              sysdate
           )
        ORDER BY enrollment_date desc;
    BEGIN
        -- Loop through results and display
       FOR rec IN c_missing_grades LOOP
          dbms_output.put_line('CLASS_ID: '
                               || rec.class_id
                               || ' | STU_ID: '
                               || rec.stu_id
                               || ' | STATUS: '
                               || rec.status
                               || ' | ENROLLMENT_DATE: ' || to_char(
             rec.enrollment_date,
             'YYYY-MM-DD'
          ));
       END LOOP;
    END;
    
    -- show class offerings procedure
    PROCEDURE show_class_offerings (
    p_start_date IN DATE DEFAULT NULL,
    p_end_date IN DATE DEFAULT NULL
    )
    IS
        -- cursor for retrieving class offerings within a certain time frame
        CURSOR c_class_offerings IS
            SELECT
                Classes.class_id,
                Classes.start_date,
                Courses.title,
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
                ' | COURSE_TITLE: ' || r.title ||
                ' | SECTION_CODE: ' || r.section_code ||
                ' | INSTRUCTOR: ' || r.instructor_name ||
                ' | AVERAGE_GRADE: ' || r.average_grade
            );
        END LOOP;
    END;
    
    -- count classses per course function
    FUNCTION count_classes_per_course (
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
    
    -- compute average grade function (PRIVATE function)
    FUNCTION compute_average_grade (
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
    
END reporting_pkg;
/