
--   MEDICAL INVENTORY OPTIMIZATION --
--         Data Preprocessing       --
desc projectfinaldata;
select * from projectfinaldata limit 10;

-- deleting duplicate rows
create table backup_table as 
select distinct * from projectfinaldata;
select * from backup_table;
truncate table projectfinaldata;
insert into projectfinaldata select * from backup_table;
drop table backup_table;
select * from projectfinaldata;

select distinct Dept from projectfinaldata;
select count(distinct Specialisation) from projectfinaldata;

select round(sum(Final_cost),2) from projectfinaldata where Final_Sales=0;

-- To check the duplicate values in particular col
Select Patient_ID, COUNT(Patient_ID)
from projectfinaldata
group  by Patient_ID
having COUNT(Patient_ID) > 1 order by count(Patient_ID) desc;

select count(*) from projectfinaldata where Patient_ID=12018098798;
select DrugName from projectfinaldata where Final_Sales=0;

select count(*) from projectfinaldata where DrugName='' and SubCat='' and SubCat1='';
select count(*) from projectfinaldata where DrugName='' and SubCat='' and SubCat1='';

select * from projectfinaldata where  Formulation='';
select count(*) from projectfinaldata;

select sum(Final_Sales) as tot_sales,Dept from projectfinaldata group by Dept order by tot_sales desc;

select * from projectfinaldata where Typeofsales='Return' order by ReturnQuantity desc;

select count(*) as cnt,Subcat 
from (select Subcat from projectfinaldata where Typeofsales='Return') as sub_table 
group by SubCat order by cnt desc;

select distinct Formulation from projectfinaldata;
select avg(Final_sales)as avgs,Dept from projectfinaldata group by Dept order by avgs; 

-- setting the dateofbill column to datetime datatype instead of text
alter table projectfinaldata modify column Dateofbill date;
update projectfinaldata set Dateofbill=
case
	when Instr(Dateofbill,'-')>0 then str_to_date(Dateofbill,'%d-%m-%Y')
	when Instr(Dateofbill, '/') > 0 then str_to_date(Dateofbill, '%m/%d/%Y')
end;
select Dateofbill from projectfinaldata;

-- Univariate analysis
-- Mean, Median, Min, Max, and Standard Deviation of Quantity
select 
  avg(quantity) as mean_quantity,
  min(quantity) as min_quantity,
  max(quantity) as max_quantity,
  stddev(quantity) as std_quantity
from projectfinaldata;

-- Count occurrences of each type of sale
select typeofsales, count(*) as sale_count
from projectfinaldata
group by typeofsales;

-- Average Final Sales for each Specialisation
select specialisation, avg(final_sales) as avg_sales
from projectfinaldata
group by specialisation order by avg_sales desc;


-- Multivariate Analysis
-- correlation between quantity and Final_sales
select 
  (SUM((Q - mean_quantity) * (F - mean_final_sales)) / (SQRT(SUM((Q - mean_quantity) * (Q - mean_quantity))) * SQRT(SUM((F - mean_final_sales) * (F - mean_final_sales))))) AS correlation_coefficient
from (
  select 
    Quantity as Q,
    Final_Sales as F,
    (select avg(Quantity) from projectfinaldata) as mean_quantity,
    (select avg(Final_Sales) from projectfinaldata) as mean_final_sales
  from projectfinaldata
) as sub_query;

-- Pivot table to show Total Sales and Total Return Quantity by Specialisation
select specialisation,
       sum(final_sales) as total_sales,
       sum(returnquantity) as total_return_quantity
from projectfinaldata
group by specialisation order by total_return_quantity desc,total_sales;

-- Skewness and kurtosis
select
  (SUM(POW(Quantity - mean_quantity, 3)) / (COUNT(Quantity) * POW(STDDEV(Quantity), 3))) as skewness,
  (SUM(POW(Quantity - mean_quantity, 4)) / (COUNT(Quantity) * POW(STDDEV(Quantity), 4))) as kurtosis
from projectfinaldata,
  (select avg(Quantity) as mean_quantity from projectfinaldata) as subquery;


select * from projectfinaldata limit 10;

select 
  Dateofbill as purchase_date,
  sum(Quantity) as quantity_brought,
  sum(ReturnQuantity) as quantity_returned,
  COUNT(distinct case when Quantity>0 then Patient_ID end) as patients_bought,
  COUNT(distinct case when ReturnQuantity > 0 then Patient_ID end) as patients_returned
from projectfinaldata
group by Dateofbill order by quantity_returned desc;

select * from projectfinaldata limit 500;

alter table data rename to projectfinaldata;

