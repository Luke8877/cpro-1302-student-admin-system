-- package specifications
create or replace package reporting_pkg is
   procedure show_missing_grades (
      p_start_date date default null,
      p_end_date   date default null
   );

   procedure show_class_offerings (
      p_start_date date default null,
      p_end_date   date default null
   );

   function count_classes_per_course (
      p_course_id classes.course_id%type
   ) return number;

   function compute_average_grade (
      p_class_id classes.class_id%type
   ) return number;

end reporting_pkg;
/

--package body
create or replace package body reporting_pkg is

    -- show missing grades procedure
   procedure show_missing_grades (
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
    
    -- show class offerings procedure
   procedure show_class_offerings (
      p_start_date in date default null,
      p_end_date   in date default null
   ) is
        -- cursor for retrieving class offerings within a certain time frame
      cursor c_class_offerings is
      select classes.class_id,
             classes.start_date,
             courses.title,
             sections.section_code,
             instructors.first_name
             || ' '
             || instructors.last_name as instructor_name,
             compute_average_grade(classes.class_id) as average_grade --function call
        from classes
        join courses
      on classes.course_id = courses.course_id
        join sections
      on courses.section_code = sections.section_code
        join instructors
      on classes.instr_id = instructors.instructor_id
       where classes.start_date between nvl(
         p_start_date,
         add_months(
                 sysdate,
                 -12
              )
      ) and nvl(
         p_end_date,
         sysdate
      );
   begin
      for r in c_class_offerings loop
         dbms_output.put_line('CLASS_ID: '
                              || r.class_id
                              || ' | START_DATE: '
                              || to_char(
            r.start_date,
            'YYYY-MM-DD'
         )
                              || ' | COURSE_TITLE: '
                              || r.title
                              || ' | SECTION_CODE: '
                              || r.section_code
                              || ' | INSTRUCTOR: '
                              || r.instructor_name
                              || ' | AVERAGE_GRADE: ' || r.average_grade);
      end loop;
   end;
    
    -- count classses per course function
   function count_classes_per_course (
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
    
    -- compute average grade
   function compute_average_grade (
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

end reporting_pkg;
/