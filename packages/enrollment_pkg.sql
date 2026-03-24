-- Package interface -- 
create or replace package enrollment_pkg as

   -- Enroll a student into a class 
   procedure enroll_student_in_class (
      p_stu_id   in number,
      p_class_id in number
   );

  -- Remove a student from a class 
   procedure drop_student_from_class (
      p_stu_id   in number,
      p_class_id in number
   );

   -- View classes for a specific student within a date range 
   procedure student_class_list (
      p_stu_id     in number,
      p_start_date in date,
      p_end_date   in date
   );

   -- Overloaded view all enrollments within a date range 
   procedure student_class_list (
      p_start_date in date,
      p_end_date   in date
   );

end enrollment_pkg;
/


-- Package Body -- 
create or replace package body enrollment_pkg as

    -- Enroll a student
   procedure enroll_student_in_class (
      p_stu_id   in number,
      p_class_id in number
   ) is
      v_count number;
   begin
      select count(*)
        into v_count
        from enrollments
       where stu_id = p_stu_id
         and class_id = p_class_id;

      if v_count > 0 then
         raise_application_error(
            -20001,
            'Student is already enrolled in this class.'
         );
      end if;
      insert into enrollments (
         stu_id,
         class_id,
         enrollment_date,
         status
      ) values ( p_stu_id,
                 p_class_id,
                 sysdate,
                 'Enrolled' );

      dbms_output.put_line('Student enrolled successfully.');
   exception
      when others then
         dbms_output.put_line('Error: ' || sqlerrm);
         raise;
   end enroll_student_in_class;
    
    -- Drop a student
   procedure drop_student_from_class (
      p_stu_id   in number,
      p_class_id in number
   ) is
      v_count number;
   begin
      select count(*)
        into v_count
        from enrollments
       where stu_id = p_stu_id
         and class_id = p_class_id;

      if v_count = 0 then
         raise_application_error(
            -20002,
            'Student is not enrolled in this class.'
         );
      end if;
      delete from enrollments
       where stu_id = p_stu_id
         and class_id = p_class_id;

      dbms_output.put_line('Student dropped successfully.');
   exception
      when others then
         dbms_output.put_line('Error: ' || sqlerrm);
         raise;
   end drop_student_from_class;

    -- Get single student class list
   procedure student_class_list (
      p_stu_id     in number,
      p_start_date in date,
      p_end_date   in date
   ) is

      cursor c_student is
      select class_id,
             enrollment_date,
             status
        from enrollments
       where stu_id = p_stu_id
         and enrollment_date between p_start_date and p_end_date
       order by enrollment_date;

   begin
      dbms_output.put_line('Classes for student ' || p_stu_id);
      for rec in c_student loop
         dbms_output.put_line('CLASS_ID: '
                              || rec.class_id
                              || ' | DATE: '
                              || to_char(
            rec.enrollment_date,
            'YYYY-MM-DD'
         )
                              || ' | STATUS: ' || rec.status);
      end loop;

   exception
      when others then
         dbms_output.put_line('Error: ' || sqlerrm);
         raise;
   end student_class_list;

    -- Get all students class list 
   procedure student_class_list (
      p_start_date in date,
      p_end_date   in date
   ) is

      cursor c_all is
      select stu_id,
             class_id,
             enrollment_date,
             status
        from enrollments
       where enrollment_date between p_start_date and p_end_date
       order by enrollment_date;

   begin
      dbms_output.put_line('All enrollments from '
                           || to_char(
         p_start_date,
         'YYYY-MM-DD'
      )
                           || ' to ' || to_char(
         p_end_date,
         'YYYY-MM-DD'
      ));

      for rec in c_all loop
         dbms_output.put_line('STU_ID: '
                              || rec.stu_id
                              || ' | CLASS_ID: '
                              || rec.class_id
                              || ' | DATE: '
                              || to_char(
            rec.enrollment_date,
            'YYYY-MM-DD'
         )
                              || ' | STATUS: ' || rec.status);
      end loop;

   exception
      when others then
         dbms_output.put_line('Error: ' || sqlerrm);
         raise;
   end student_class_list;


end enrollment_pkg;
/