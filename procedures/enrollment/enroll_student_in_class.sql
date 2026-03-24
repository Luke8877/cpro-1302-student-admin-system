-- TODO: implement procedure

create or replace procedure enroll_student_in_class (
   p_stu_id   in number,
   p_class_id in number
) as
   v_count number;
begin
  -- ENROLLMENT CHECK -- 
   select count(*)
     into v_count
     from enrollments
    where stu_id = p_stu_id
      and class_id = p_class_id;

   if v_count > 0 then
      raise_application_error(
         -20001,
         'student is already enrolled in this class'
      );
   end if;

  -- INSERTION IF CHECK PASSED -- 
   insert into enrollments (
      stu_id,
      class_id,
      enrollment_date,
      status
   ) values ( p_stu_id,
              p_class_id,
              sysdate,
              'Enrolled' );

   dbms_output.put_line('Student was enrolled successfully!');
exception
   when others then
      dbms_output.put_line('Error: ' || sqlerrm);
end;
/