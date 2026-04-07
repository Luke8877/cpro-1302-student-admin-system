   SET SERVEROUTPUT ON;

pro    ============================================
pro    STUDENT ADMIN SYSTEM - FULL TEST EXECUTION
pro    ============================================


-- =========================================================
-- ENROLLMENT MODULE TESTS
-- =========================================================
pro   
pro    ===== ENROLLMENT MODULE =====

pro    --- TEST 1: Enroll student (SUCCESS) ---

begin
   enrollment_pkg.enroll_student_in_class(
      101,
      4
   );
end;
/

pro    --- TEST 2: Enroll student again (ERROR EXPECTED) ---

begin
   enrollment_pkg.enroll_student_in_class(
      101,
      4
   );
end;
/

pro    --- TEST 3: List classes for student 101 ---

begin
   enrollment_pkg.student_class_list(
      101,
      date '2004-01-01',
      sysdate
   );
end;
/

pro    --- TEST 4: List ALL enrollments (overloaded version) ---

begin
   enrollment_pkg.student_class_list(
      date '2004-01-01',
      sysdate
   );
end;
/

pro    --- TEST 5: No results (invalid date range) ---

begin
   enrollment_pkg.student_class_list(
      101,
      date '1990-01-01',
      date '1990-12-31'
   );
end;
/

pro    --- TEST 6: No results (invalid student) ---

begin
   enrollment_pkg.student_class_list(
      999,
      date '2003-01-01',
      sysdate
   );
end;
/

pro    --- TEST 7: Drop student (SUCCESS) ---

begin
   enrollment_pkg.drop_student_from_class(
      101,
      4
   );
end;
/

pro    --- TEST 8: Drop student again (ERROR EXPECTED) ---

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
pro --- TEST 9: Show missing grades ---

update enrollments
   set
   final_letter_grade = null
 where stu_id = 101
   and class_id = 1;

commit;

begin
   reporting_pkg.show_missing_grades(
      date '2000-01-01',
      sysdate
   );
end;
/

pro    --- TEST 10: Show class offerings ---

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

pro    --- TEST 11: Count classes per course ---

declare
   v_count number;
begin
   v_count := reporting_pkg.count_classes_per_course(1002);
   dbms_output.put_line('Classes for course 1: ' || v_count);
end;
/

pro    --- TEST 12: Convert numeric grade to letter ---

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

pro    --- TEST 13: Create assignment ---

begin
   assessment_pkg.create_assignment('Final Exam');
end;
/

pro    --- TEST 14: Enter student grade (SUCCESS) ---

begin
   assessment_pkg.enter_student_grade(
      88,   -- grade
      1,    -- class_id
      101,  -- stu_id
      1     -- assessment_id 
   );
end;
/

pro    --- TEST 15: Enter student grade (ERROR EXPECTED - invalid student) ---

begin
   assessment_pkg.enter_student_grade(
      90,
      1,
      999,  -- invalid student
      1
   );
end;
/

pro --- TEST 16: invalid assessment (ERROR EXPECTED) ---

begin
   assessment_pkg.enter_student_grade(
      85,
      1,
      101,
      999
   );
end;
/

-- =========================================================
-- TRIGGER TEST
-- =========================================================
pro   
pro    ===== TRIGGER TEST =====

pro    ===== TRIGGER TEST =====

delete from grade_change_history;
commit;

pro    --- TEST 17: Update final grade (should trigger audit) ---

update enrollments
   set
   final_letter_grade = 'B'
 where stu_id = 101
   and class_id = 1;

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