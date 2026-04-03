-- package specification
create or replace package assessment_pkg as
   procedure create_assignment (
      p_desc in varchar2
   );

   procedure enter_student_grade (
      p_numeric_grade in class_assessments.numeric_grade%type,
      p_class_id      in class_assessments.class_id%type,
      p_stu_id        in class_assessments.stu_id%type,
      p_assessment_id in class_assessments.assessment_id%type
   );

   function convert_grade (
      p_grade in number
   ) return varchar2;

end assessment_pkg;
/

create or replace package body assessment_pkg as

   procedure create_assignment (
      p_desc in varchar2
   ) is
   begin
      insert into assessments (
         assessment_id,
         description
      ) values ( assessment_id_seq.nextval,
                 p_desc );

      dbms_output.put_line('Assignment created successfully.');
   end;

   procedure enter_student_grade (
      p_numeric_grade in class_assessments.numeric_grade%type,
      p_class_id      in class_assessments.class_id%type,
      p_stu_id        in class_assessments.stu_id%type,
      p_assessment_id in class_assessments.assessment_id%type
   ) is
      v_dummy number;
   begin
      select 1
        into v_dummy
        from students
       where stu_id = p_stu_id;
      select 1
        into v_dummy
        from classes
       where class_id = p_class_id;
      select 1
        into v_dummy
        from assessments
       where assessment_id = p_assessment_id;

      insert into class_assessments (
         class_assessment_id,
         date_turned_in,
         numeric_grade,
         class_id,
         stu_id,
         assessment_id
      ) values ( class_assessment_id_seq.nextval,
                 sysdate,
                 p_numeric_grade,
                 p_class_id,
                 p_stu_id,
                 p_assessment_id );

   exception
      when no_data_found then
         raise_application_error(
            -20001,
            'Student, class, or assessment does not exist'
         );
   end;

   function convert_grade (
      p_grade in number
   ) return varchar2 is
   begin
      if p_grade >= 90 then
         return 'A';
      elsif p_grade >= 80 then
         return 'B';
      elsif p_grade >= 70 then
         return 'C';
      elsif p_grade >= 60 then
         return 'D';
      else
         return 'F';
      end if;
   end;

end assessment_pkg;
/