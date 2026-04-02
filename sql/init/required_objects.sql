-- required objects for the project

create sequence assessment_id_seq start with 1 increment by 1;

select assessment_id_seq.nextval -- Test for sequence
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

select *
  from assessments;