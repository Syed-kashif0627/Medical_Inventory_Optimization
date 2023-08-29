select * from finaldata;



alter table finaldata modify column Dateofbill date;
update finaldata set Dateofbill=
case
	when Instr(Dateofbill,'-')>0 then str_to_date(Dateofbill,'%d-%m-%Y')
	when Instr(Dateofbill, '/') > 0 then str_to_date(Dateofbill, '%m/%d/%Y')
end;
select Dateofbill from finaldata;
desc finaldata;