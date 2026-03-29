--TODO Implement procedure

create or replace procedure show_missing_grades (
   p_start_date in date default null,
   p_end_date   in date default null
) is
    -- Cursor to fetch required records
   cursor c_missing_grades is
   select class_id,
          stu_id,
          status,
          enrollment_date
     from enrollments
    where final_letter_grade is null
      and enrollment_date between nvl(
      p_start_date,
      add_months(
           sysdate,
           -12
        )
   ) and nvl(
      p_end_date,
      sysdate
   )
    order by enrollment_date desc;
begin
    -- Loop through results and display
   for rec in c_missing_grades loop
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
   end loop;
end;
/
