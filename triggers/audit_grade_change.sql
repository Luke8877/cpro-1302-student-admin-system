create or replace trigger audit_grade_change after
   update of numeric_grade on class_assessments
   for each row
declare
   v_enrollment_date date;
begin
   if :old.numeric_grade != :new.numeric_grade then
      select enrollment_date
        into v_enrollment_date
        from enrollments
       where stu_id = :old.stu_id
         and class_id = :old.class_id;

      insert into grade_change_history (
         stu_id,
         class_id,
         enrollment_date,
         old_grade,
         new_grade,
         change_timestamp
      ) values ( :old.stu_id,
                 :old.class_id,
                 v_enrollment_date,
                 :old.numeric_grade,
                 :new.numeric_grade,
                 systimestamp );

   end if;
end;
/