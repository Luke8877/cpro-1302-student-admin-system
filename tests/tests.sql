   SET SERVEROUTPUT ON;

pro    ============================================
pro    STUDENT ADMIN SYSTEM - FULL TEST EXECUTION
pro    ============================================


-- =========================================================
-- ENROLLMENT MODULE TESTS
-- =========================================================
pro   
pro    ===== ENROLLMENT MODULE =====

pro    --- Enroll student (SUCCESS) ---

begin
   enrollment_pkg.enroll_student_in_class(
      101,
      4
   );
end;
/

pro    --- Enroll student again (ERROR EXPECTED) ---

begin
   enrollment_pkg.enroll_student_in_class(
      101,
      4
   );
end;
/

pro    --- List classes for student 101 ---

begin
   enrollment_pkg.student_class_list(
      101,
      date '2004-01-01',
      sysdate
   );
end;
/

pro    --- List ALL enrollments (overloaded version) ---

begin
   enrollment_pkg.student_class_list(
      date '2004-01-01',
      sysdate
   );
end;
/

pro    --- No results (invalid date range) ---

begin
   enrollment_pkg.student_class_list(
      101,
      date '1990-01-01',
      date '1990-12-31'
   );
end;
/

pro    --- No results (invalid student) ---

begin
   enrollment_pkg.student_class_list(
      999,
      date '2003-01-01',
      sysdate
   );
end;
/

pro    --- Drop student (SUCCESS) ---

begin
   enrollment_pkg.drop_student_from_class(
      101,
      4
   );
end;
/

pro    --- Drop student again (ERROR EXPECTED) ---

begin
   enrollment_pkg.drop_student_from_class(
      101,
      4
   );
end;
/


-- =========================================================
-- REPORTING MODULE TESTS
-- =========================================================
pro   
pro    ===== REPORTING MODULE =====

pro    --- Show missing grades ---

begin
   reporting_pkg.show_missing_grades;
end;
/

pro    --- Show class offerings ---

begin
   reporting_pkg.show_class_offerings(
      date '2000-01-01',
      sysdate
   );
end;
/


-- =========================================================
-- FUNCTION TESTS
-- =========================================================
pro   
pro    ===== FUNCTION TESTS =====

pro    --- Count classes per course ---

declare
   v_count number;
begin
   v_count := reporting_pkg.count_classes_per_course(1);
   dbms_output.put_line('Classes for course 1: ' || v_count);
end;
/

pro    --- Convert numeric grade to letter ---

declare
   v_letter varchar2(2);
begin
   v_letter := assessment_pkg.convert_grade(85);
   dbms_output.put_line('Grade 85 = ' || v_letter);
end;
/


-- =========================================================
-- ASSESSMENT MODULE TESTS
-- =========================================================
pro   
pro    ===== ASSESSMENT MODULE =====

pro    --- Create assignment ---

begin
   assessment_pkg.create_assignment('Final Exam');
end;
/

pro    --- Enter student grade (SUCCESS) ---

begin
   assessment_pkg.enter_student_grade(
      88,   -- grade
      1,    -- class_id
      101,  -- stu_id
      1     -- assessment_id (must exist)
   );
end;
/

pro    --- Enter student grade (ERROR EXPECTED - invalid student) ---

begin
   assessment_pkg.enter_student_grade(
      90,
      1,
      999,  -- invalid student
      1
   );
end;
/


-- =========================================================
-- TRIGGER TEST
-- =========================================================
pro   
pro    ===== TRIGGER TEST =====

pro    --- Update final grade (should trigger audit) ---

update enrollments
   set
   final_letter_grade = 'A'
 where stu_id = 101
   and class_id = 1;

pro    --- Check audit log ---

select *
  from grade_change_history;


pro   
pro    ============================================
pro    ALL TESTS COMPLETED
pro    ============================================