----------------------------------------------------------------------
--------------------------- 1. wave of EET ---------------------------
----------------------------------------------------------------------
select br.identification_number
	,br.company_name
	,br.adress
	,a.adresnibod
from business_register br
join company_nace_mapping cnm
	on cnm.identification_number = br.identification_number
join electronic_registration_of_sales eros
	on eros.nace = cnm.nace_code
left join ruian.adresnimista a
	on a.kod = br.adress_point
where eros.start_date = '2016-12-01' -- First wave of EET
	and br.employee_size = '110' -- 0 employees
	and extract(week from br.dissolution) = extract(week from cast('2016-12-01' as date) - interval '1' day)
	and extract(year from br.dissolution) = extract(year from cast('2016-12-01' as date) - interval '1' day);

----------------------------------------------------------------------
--------------------------- 2. wave of EET ---------------------------
----------------------------------------------------------------------
select br.identification_number
	,br.company_name
	,br.adress
	,a.adresnibod
from business_register br
join company_nace_mapping cnm
	on cnm.identification_number = br.identification_number
join electronic_registration_of_sales eros
	on eros.nace = cnm.nace_code
left join ruian.adresnimista a
	on a.kod = br.adress_point
where eros.start_date = '2016-12-01' -- Second wave of EET
	and br.employee_size = '110' -- 0 employees
	and extract(week from br.dissolution) = extract(week from cast('2017-03-01' as date) - interval '1' day)
	and extract(year from br.dissolution) = extract(year from cast('2017-03-01' as date) - interval '1' day);
