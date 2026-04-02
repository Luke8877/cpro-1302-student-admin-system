-- sequence for assignment identifier
-- CREATE SEQUENCE ASSESSMENT_ID_SEQ
-- START WITH 1
-- INCREMENT BY 1;

-- procedure for creating assignment
create or replace procedure create_assignment (
   p_desc in varchar2
) is
begin
   insert into class_assessments (
      class_assessment_id,
      date_turned_in,
      numeric_grade,
      class_id,
      stu_id,
      assessment_id
   ) values ( (
      select nvl(
         max(class_assessment_id),
         0
      ) + 1
        from class_assessments
   ),
              sysdate,
              p_numeric_grade,
              p_class_id,
              p_stu_id,
              p_assessment_id );

   dbms_output.put_line('Assignment created successfully.');
end;
/