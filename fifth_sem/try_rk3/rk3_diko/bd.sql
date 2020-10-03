create table organization
(
	Id SERIAL PRIMARY KEY,
	Name char(100) NOT NULL,
	Address char(100) NOT NULL,
	Phone Char(100) NOT NULL
);

create table employee
(
	Id SERIAL PRIMARY KEY,
	FIO char(100) NOT NULL,
	date date NOT NULL,
	otdel char(100) NOT NULL,
	organization_id INTEGER,
    FOREIGN KEY (organization_id) REFERENCES organization (Id)
);

INSERT INTO organization (Id, Name, Address, Phone) VALUES (1, 'Московский Филиал (ГО)', 'Герцена, 5', '4567823');
INSERT INTO organization (Id, Name, Address, Phone) VALUES (2, 'Новисибирский доп. офис', 'Пролетарская, 8', '4567823');
INSERT INTO organization (Id, Name, Address, Phone) VALUES (3, 'Саратовский доп. офис', 'Шухова, 44', '4525611');
INSERT INTO organization (Id, Name, Address, Phone) VALUES (4, 'Томский филиал', 'Герцена, 7', '9874674');
INSERT INTO organization (Id, Name, Address, Phone) VALUES (5, 'Саратовский доп. офис 2', 'Герцена, 7', '9874574');

INSERT INTO employee (Id, FIO, date, otdel, organization_id) VALUES (1, 'Иванов Иван Иванович', 'Sep-25-1990', 'ИТ', 1);
INSERT INTO employee (Id, FIO, date, otdel, organization_id) VALUES (2, 'Иванов Иван Иванович', 'Nov-12-1987', 'Бухгалтерия', 3);

--1)для каждой улицы вывести количество расположенных на ней филиаллов
CREATE OR REPLACE FUNCTION get_amount_organizations(char street) RETURNS INT AS $$
DECLARE
	result INT;
BEGIN
	result := 0;
	FOR i IN select name from organization where address = street LOOP
		result := result + 1;
	END LOOP;
	RETURN result;
END
$$ LANGUAGE 'plpgsql';

select Address, count(Name)
from organization
group by address;

2)найти все филиалы в которых все
CREATE OR REPLACE FUNCTION get_organizations() RETURNS table (char name, id integer) AS $$
DECLARE
	result INT;
BEGIN
	return QUERY
	select o.name, count(e.id) as count_emp
from organization as o JOIN (
	select * from employee as e
	where (extract(year from date (current_date)) - extract(year from date(e.date))) = 26
) as e ON o.id = e.organization_id
group by o.name
having count_emp > 5 and count_emp < 16;
END
$$ LANGUAGE 'plpgsql';


--3)Вывести всех сотрудников, в номере телефона филиала которых нет цифры 7

CREATE OR REPLACE FUNCTION get_organizations() RETURNS table (char fio, char phone) AS $$
DECLARE
	result INT;
	flag INT
BEGIN
	for i in select e.FIO as fio, o.phone as phone form employee as e join organization as o on e.organization_id = o.id LOOP
		flag := 0;
		for (j in i.phone) LOOP
			IF j = '7' then
				flag := 1;
			END IF;
		END LOOP;
		if (flag = 0) then
			return next i
		end if;
	END LOOP;
	return;
select e.FIO, o.name
from employee as e join organization as o on o.id = e.organization_id
where e.phone 

END
$$ LANGUAGE 'plpgsql';
