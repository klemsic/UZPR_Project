select br.dissolution
	,count(*)
from business_register br
join company_nace_mapping cnm
	on cnm.identification_number = br.identification_number
join electronic_registration_of_sales eros
	on eros.nace = cnm.nace_code
--where eros.start_date = '2016-12-01' -- First wave of EET
where eros.start_date = '2017-03-01' -- Second wave of EET
	and br.employee_size = '110' -- without employees
--	and br.employee_size = '120' -- 1 - 5 employees
	and br.dissolution is not null
group by dissolution
order by dissolution;
