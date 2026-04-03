-- required objects for the project

create sequence assessment_id_seq start with 1 increment by 1;

create sequence class_assessment_id_seq start with 1 increment by 1;

-- test
select assessment_id_seq.nextval
  from dual;
select class_assessment_id_seq.nextval
  from dual;

-- audit table for grade changes
create table grade_change_history (
   stu_id           number,
   class_id         number,
   enrollment_date  date,
   old_grade        varchar2(2),
   new_grade        varchar2(2),
   change_timestamp timestamp default systimestamp
);