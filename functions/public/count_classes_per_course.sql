create or replace function count_classes_per_course (
   p_course_id in classes.course_id%type
) return number is
   v_row_count number;
begin
   select count(*)
     into v_row_count
     from classes
    where course_id = p_course_id;
   return v_row_count;
end count_classes_per_course;
/