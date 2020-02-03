----------------------------------------------------------------------
--------------------------- 1. wave of EET ---------------------------
----------------------------------------------------------------------
select extract(year from i::date) as year
	,extract(week from i::date) as week
	,null as dissolutions
	,null as establishments
into temp table eet1
from generate_series('2015-01-01','2019-12-31', '1 week'::interval) i;

-- update dissolutions
update eet1
set dissolutions = d.diss
from (	
	select extract(year from br.dissolution) as year
		,extract(week from br.dissolution) as week
		,count(*) as diss
	from business_register br
	join company_nace_mapping cnm
		on cnm.identification_number = br.identification_number
	join electronic_registration_of_sales eros
		on eros.nace = cnm.nace_code
	where eros.start_date = '2016-12-01' -- First wave of EET
		and br.employee_size = '110' -- 0 employees
		and br.dissolution is not null
	group by extract(year from br.dissolution)
		,extract(week from br.dissolution)
	) d
where eet1.year = d.year and eet1.week = d.week;

-- update establishment
update eet1
set establishments = e.est
from (	
	select extract(year from br.establishment) as year
		,extract(week from br.establishment) as week
		,count(*) as est
	from business_register br
	join company_nace_mapping cnm
		on cnm.identification_number = br.identification_number
	join electronic_registration_of_sales eros
		on eros.nace = cnm.nace_code
	where eros.start_date = '2016-12-01' -- First wave of EET
		and br.employee_size = '110' -- 0 employees
	group by extract(year from br.establishment)
		,extract(week from br.establishment)
	) e
where eet1.year = e.year and eet1.week = e.week;

select * from eet1
order by year, week;

drop table eet1;

----------------------------------------------------------------------
--------------------------- 2. wave of EET ---------------------------
----------------------------------------------------------------------
select extract(year from i::date) as year
	,extract(week from i::date) as week
	,null as dissolutions
	,null as establishments
into temp table eet2
from generate_series('2015-01-01','2019-12-31', '1 week'::interval) i;

-- update dissolutions
update eet2
set dissolutions = d.diss
from (	
	select extract(year from br.dissolution) as year
		,extract(week from br.dissolution) as week
		,count(*) as diss
	from business_register br
	join company_nace_mapping cnm
		on cnm.identification_number = br.identification_number
	join electronic_registration_of_sales eros
		on eros.nace = cnm.nace_code
	where eros.start_date = '2017-03-01' -- Second wave of EET
		and br.employee_size = '110' -- 0 employees
		and br.dissolution is not null
	group by extract(year from br.dissolution)
		,extract(week from br.dissolution)
	) d
where eet2.year = d.year and eet2.week = d.week;

-- update establishment
update eet2
set establishments = e.est
from (	
	select extract(year from br.establishment) as year
		,extract(week from br.establishment) as week
		,count(*) as est
	from business_register br
	join company_nace_mapping cnm
		on cnm.identification_number = br.identification_number
	join electronic_registration_of_sales eros
		on eros.nace = cnm.nace_code
	where eros.start_date = '2017-03-01' -- Second wave of EET
		and br.employee_size = '110' -- 0 employees
	group by extract(year from br.establishment)
		,extract(week from br.establishment)
	) e
where eet2.year = e.year and eet2.week = e.week;

select * from eet2
order by year, week;

drop table eet2;
