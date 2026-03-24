--TODO Add Success Test Cases

-- Test for student enrollment procedure --
-- This procedure accepts a student ID and class ID. 
-- Checks if the student is enrolled
-- If not the student gets enolled and a record is inserted into enrollments.CALCULATE_TAX
-- If already enrolled an error is raised that prevents duplicate data. 
begin
   enroll_student_in_class(
      101,
      4
   );
end;
/

-- Test for student drop procedure --

begin
   drop_student_from_class(
      101,
      4
   );
end;
/