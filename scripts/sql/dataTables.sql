------------------ Create tables and bulk insert data ------------------
------------------------------------------------------------------------
------------------------------------------------------------------------

------------------- Electronic registration of sales -------------------
------------------------------------------------------------------------
create table uzpr20_g.electronic_registration_of_sales (
	nace varchar(10) primary key,
	start_date date,
	end_date date
);

------------------------- Employee size class --------------------------
------------------------------------------------------------------------
create table uzpr20_g.employee_size (
	code char(3) primary key,
	description varchar(50) not null
);

-------------------------------- NACE ----------------------------------
------------------------------------------------------------------------
create table uzpr20_g.nace (
	level int not null,
	code varchar(10) primary key,
	description varchar(200) not null
);

-------------------------- Business register ---------------------------
------------------------------------------------------------------------
create table uzpr20_g.business_register (
	id int unique,
	identification_number char(8) primary key,
	company_name varchar(500) not null,
	legal_form char(3),
	establishment date,
	dissolution date,
	adress varchar(200),
	basic_territorial_unit int,
	employee_size char(3),
	institutional_sector char(5)
);

------------------------- Company Nace Mapping -------------------------
------------------------------------------------------------------------
create table uzpr20_g.company_nace_mapping (
	identification_number char(8),
	nace_code varchar(10),
	primary key(identification_number, nace_code)
);





