
CREATE OR REPLACE PROCEDURE enter_student_grade (
    p_numeric_grade IN Class_Assessments.numeric_grade%TYPE,
    p_class_id IN Class_Assessments.class_id%TYPE,
    p_stu_id IN Class_Assessments.stu_id%TYPE,
    p_assessment_id IN Class_Assessments.assessment_id%TYPE
)
IS
    v_dummy NUMBER; -- dummy variable to check existence of records
BEGIN
    -- Validate student exists
    SELECT 1 INTO v_dummy
    FROM Students
    WHERE stu_id = p_stu_id;

    -- Validate class exists
    SELECT 1 INTO v_dummy
    FROM Classes
    WHERE class_id = p_class_id;

    -- Validate assessment exists
    SELECT 1 INTO v_dummy
    FROM Assessments
    WHERE assessment_id = p_assessment_id;

    -- Insert record
    INSERT INTO Class_Assessments (
        date_turned_in,
        numeric_grade,
        class_id,
        stu_id,
        assessment_id
    )
    VALUES (
        SYSDATE,
        p_numeric_grade,
        p_class_id,
        p_stu_id,
        p_assessment_id
    );

-- exception. Runs if SELECT INTO's above return 0 rows
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Student, class, or assessment does not exist'
        );
END;
/

SELECT * FROM Class_Assessments