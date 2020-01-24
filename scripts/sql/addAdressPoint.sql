
-- Create tmp table with adres points and names.
select a.kod as adress_point
	,o.kod as municipality_code
	,o.nazev as municipality
	,co.kod as municipality_part_code
	,co.nazev as municipality_part
	,u.kod as street_code
	,u.nazev as street
	,a.cislodomovni as house_number
	,a.cisloorientacni as orientation_number
	,a.cisloorientacnipismeno as orientation_character
into temp tmp_adress
from ruian.adresnimista a
join ruian.stavebniobjekty so
	on so.kod = a.stavebniobjektkod
join ruian.castiobci co
	on co.kod = so.castobcekod
join ruian.obce o
	on o.kod = co.obeckod
left join ruian.ulice u
	on u.kod = a.ulicekod;
	
-- Clear adress in business register.
update uzpr20_g.business_register br
set adress_point = null;

-- Add adres with format %,%,%,[street] [house_number]/% and basic territorial unit match.
-- Update 1 391 552 rows. => 39.5%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
	from uzpr20_g.business_register br
	join tmp_adress a
		on br.basic_territorial_unit = a.municipality_code
			or br.basic_territorial_unit = a.municipality_part_code
	where concat(a.street, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 4),'/',1))
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;


-- Add adres with format %,%,%,[street] [house_number]/% and without basic territorial unit match, with municipality match.
-- Update 380 975 rows. => 12.0%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
		,br.adress
		,a.municipality
		,a.municipality_part
		,a.street
		,a.house_number
	from uzpr20_g.business_register br
	join tmp_adress a
		on trim(split_part(br.adress, ',', 1)) = a.municipality
	where concat(a.street, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 4),'/',1))
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;
	
	
-- Add adres with format %,%,%,[street] [house_number]/% and without basic territorial unit match, with municipality part match.
-- Update 125 rows. => 0.0%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
		,br.adress
		,a.municipality
		,a.municipality_part
		,a.street
		,a.house_number
	from uzpr20_g.business_register br
	join tmp_adress a
		on trim(split_part(br.adress, ',', 1)) = a.municipality_part
	where concat(a.street, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 4),'/',1))
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;

-- Add adres with format %,%,%,[street] [house_number]/% and basic territorial unit match.
-- Update 4 777 rows. => 0.2%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
	from uzpr20_g.business_register br
	join tmp_adress a
		on br.basic_territorial_unit = a.municipality_code
			or br.basic_territorial_unit = a.municipality_part_code
	where concat(a.street, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 2),'/',1))
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;
	
	
-- Add adres with format %,%,%,[street] [house_number]/% and without basic territorial unit match, with municipality like 'Praha%'.
-- Update 678523 rows. => 21.3%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
		,br.adress
		,a.municipality
		,a.municipality_part
		,a.street
		,a.house_number
	from uzpr20_g.business_register br
	join tmp_adress a
		on a.municipality_code = 554782 -- Praha
	where concat(a.street, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 4),'/',1))
		and trim(split_part(br.adress, ',', 1)) like 'Praha%'
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;


-- Add adres with format %,%,%,[street] [house_number]/% and basic territorial unit match.
-- Update 647 681 rows. => 20.3%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
	from uzpr20_g.business_register br
	join tmp_adress a
		on br.basic_territorial_unit = a.municipality_code
			or br.basic_territorial_unit = a.municipality_part_code
	where concat(a.municipality_part, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 4),'/',1))
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;


-- Add adres with format %,%,%,[street] [house_number]/% and without basic territorial unit match, with municipality part match.
-- Update 29 rows. => 0.0%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
		,br.adress
		,a.municipality
		,a.municipality_part
		,a.street
		,a.house_number
	from uzpr20_g.business_register br
	join tmp_adress a
		on trim(split_part(br.adress, ',', 1)) = a.municipality_part
	where concat(a.street, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 2),'/',1))
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;


-- Add adres with format %,%,%,[street] [house_number]/% and without basic territorial unit match, with municipality like 'Praha%'.
-- Update 678523 rows. => 21.3%
update uzpr20_g.business_register br
set adress_point = adr.adress_point
from (
	select br.identification_number
		,a.adress_point
		,br.adress
		,a.municipality
		,a.municipality_part
		,a.street
		,a.house_number
	from uzpr20_g.business_register br
	join tmp_adress a
		on a.municipality_code = 554782 -- Praha
	where concat(a.street, ' ', a.house_number) = trim(split_part(split_part(br.adress, ',', 2,'/',1))
		and trim(split_part(br.adress, ',', 1)) like 'Praha%'
	) adr
where br.identification_number = adr.identification_number
	and br.adress_point is null;




select br.identification_number
	,trim(split_part(split_part(br.adress, ',', 4),'/',1)) as street_number
into 
from uzpr20_g.business_register br
limit 100;





select br.identification_number
	,br.adress
	,a.municipality
	,a.municipality_part
	,a.street
	,a.house_number
from uzpr20_g.business_register br
join tmp_adress a
	on br.basic_territorial_unit = a.municipality_code
		or br.basic_territorial_unit = a.municipality_part_code
limit 100;





select * from tmp_adress adr where adr.municipaliti_code = 555771 limit 10;


