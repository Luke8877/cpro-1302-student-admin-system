create or replace procedure enter_student_grade (
   p_numeric_grade in class_assessments.numeric_grade%type,
   p_class_id      in class_assessments.class_id%type,
   p_stu_id        in class_assessments.stu_id%type,
   p_assessment_id in class_assessments.assessment_id%type
) is
   v_dummy number; -- dummy variable to check existence of records
begin
    -- Validate student exists
   select 1
     into v_dummy
     from students
    where stu_id = p_stu_id;

    -- Validate class exists
   select 1
     into v_dummy
     from classes
    where class_id = p_class_id;

    -- Validate assessment exists
   select 1
     into v_dummy
     from assessments
    where assessment_id = p_assessment_id;

    -- Insert record
   insert into class_assessments (
      class_assessment_id,
      date_turned_in,
      numeric_grade,
      class_id,
      stu_id,
      assessment_id
   ) values ( class_assessment_id_seq.nextval,
              sysdate,
              p_numeric_grade,
              p_class_id,
              p_stu_id,
              p_assessment_id );

-- exception. Runs if SELECT INTO's above return 0 rows
exception
   when no_data_found then
      raise_application_error(
         -20001,
         'Student, class, or assessment does not exist'
      );
end;
/