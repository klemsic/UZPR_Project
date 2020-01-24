
cd /media/tomas/Data1/Dokumenty/CVUT/ing/3_semestr/UZPR/Project/Data

## Electronic registration of sales
cat EETNaceStarts | psql -d pgis_uzpr -h geo102.fsv.cvut.cz -U uzpr20_g -c "SET datestyle = 'ISO,DMY'; COPY uzpr20_g.electronic_registration_of_sales (nace, start_date) from stdin delimiter ';' csv header"

## Employee size class
cat KategoriePoctuZamestnancu | psql -d pgis_uzpr -h geo102.fsv.cvut.cz -U uzpr20_g -c "COPY uzpr20_g.employee_size_class (code, description) from stdin delimiter ';' csv header"

## NACE
cat Nace | psql -d pgis_uzpr -h geo102.fsv.cvut.cz -U uzpr20_g -c "COPY uzpr20_g.nace (level, code, description) from stdin delimiter ';' csv header"

## Business Register
head RES | psql -d pgis_uzpr -h geo102.fsv.cvut.cz -U uzpr20_g -c "SET datestyle = 'ISO,DMY'; COPY uzpr20_g.business_register (id, identification_number, company_name, legal_form, establishment, dissolution, adress, basic_territorial_unit, employee_size, institutional_sector) from stdin delimiter ';' csv header"

## Company Nace Mapping
cat RESNaceMapping | psql -d pgis_uzpr -h geo102.fsv.cvut.cz -U uzpr20_g -c "COPY uzpr20_g.company_nace_mapping (identification_number, nace_code) from stdin delimiter ';' csv header"
