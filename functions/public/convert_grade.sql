create or replace function convert_grade (
   p_grade in number
) return varchar2 is
   v_letter_grade varchar2(1);
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
/