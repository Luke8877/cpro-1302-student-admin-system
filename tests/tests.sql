   set serveroutput on;

-- =========================
-- ENROLLMENT MODULE TESTS
-- =========================

-- Enroll a student into a class
begin
   enrollment_pkg.enroll_student_in_class(
      101,
      4
   );
end;
/

-- Attempt duplicate enrollment 
begin
   enrollment_pkg.enroll_student_in_class(
      101,
      4
   );
end;
/

-- List enrollments for a student within a valid date range
begin
   enrollment_pkg.student_class_list(
      101,
      date '2004-01-01',
      sysdate
   );
end;
/

-- Overloaded version 
begin
   enrollment_pkg.student_class_list(
      date '2004-01-01',
      sysdate
   );
end;
/

-- No results due to invalid date range
begin
   enrollment_pkg.student_class_list(
      101,
      date '1990-01-01',
      date '1990-12-31'
   );
end;
/

-- No results due to no student with the id of 999
begin
   enrollment_pkg.student_class_list(
      999,
      date '2003-01-01',
      sysdate
   );
end;
/

-- Drop a student from a class
begin
   enrollment_pkg.drop_student_from_class(
      101,
      4
   );
end;
/

-- Attempt to drop again 
begin
   enrollment_pkg.drop_student_from_class(
      101,
      4
   );
end;
/