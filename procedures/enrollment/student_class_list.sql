create or replace procedure student_class_list (
   p_stu_id     in number,
   p_start_date in date,
   p_end_date   in date
) as
   cursor c_student_classes is
   select class_id,
          enrollment_date,
          status
     from enrollments
    where stu_id = p_stu_id
      and enrollment_date between p_start_date and p_end_date
    order by enrollment_date;
begin
   for rec in c_student_classes loop
      dbms_output.put_line('CLASS_ID: '
                           || rec.class_id
                           || ' | DATE: '
                           || to_char(
         rec.enrollment_date,
         'YYYY-MM-DD'
      )
                           || ' | STATUS: ' || rec.status);
   end loop;
exception
   when others then
      dbms_output.put_line('Error: ' || sqlerrm);
      raise;
end;
/

select class_id,
       enrollment_date,
       status
  from enrollments;