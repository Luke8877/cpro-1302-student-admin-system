create or replace procedure drop_student_from_class (
   p_stu_id   in number,
   p_class_id in number
) as
   v_count number;
begin
    -- CHECK FOR ENROLLMENT --
   select count(*)
     into v_count
     from enrollments
    where stu_id = p_stu_id
      and class_id = p_class_id;

   if v_count = 0 then
      raise_application_error(
         -20002,
         'Student is not enrolled in this class.'
      );
   end if;

    -- DELETE ENROLLMENT -- 
   delete from enrollments
    where stu_id = p_stu_id
      and class_id = p_class_id;

   dbms_output.put_line('Student dropped from class successfully.');
exception
   when others then
      dbms_output.put_line('Error: ' || sqlerrm);
end;
/