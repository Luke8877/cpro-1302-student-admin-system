create or replace trigger audit_grade_change after
   update of final_letter_grade on enrollments
   for each row
begin
   -- Only log if the grade changed
   if :old.final_letter_grade != :new.final_letter_grade then
      insert into grade_change_history (
         stu_id,
         class_id,
         enrollment_date,
         old_grade,
         new_grade,
         change_timestamp
      ) values ( :old.stu_id,
                 :old.class_id,
                 :old.enrollment_date,
                 :old.final_letter_grade,
                 :new.final_letter_grade,
                 systimestamp );

   end if;
end;
/