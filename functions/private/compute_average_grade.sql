create or replace function compute_average_grade (
   p_class_id in classes.class_id%type
) return number is
   v_avg_grade number;
begin
   select nvl(
      avg(numeric_grade),
      0
   )
     into v_avg_grade
     from class_assessments
    where class_id = p_class_id;
   return v_avg_grade;
end compute_average_grade;
/