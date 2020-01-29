--Вывести количество тренеров мужчин(женщин)
CREATE OR REPLACE FUNCTION get_amount_sex(choice SEX) RETURNS INT AS $$
DECLARE
    trainer_sex SEX;
	result INT;
BEGIN
	result := 0;
	FOR trainer_sex IN SELECT Sex FROM trainer LOOP
		if choice = trainer_sex THEN
			result := result + 1;
		END IF;
	END LOOP;
	RETURN result;
END
$$ LANGUAGE 'plpgsql';


SELECT * FROM get_amount_sex('Men');
SELECT * FROM get_amount_sex('Women');

--Вывести всех тренеров мужчин(женщин)
CREATE OR REPLACE FUNCTION get_table(choice SEX) RETURNS TABLE 
(id integer, Full_name CHAR(100), sport_razryad sport_razr, experience integer, age integer, phone_number bigint, sex sex) AS $$
BEGIN
	return QUERY 
	SELECT * FROM trainer
	WHERE trainer.sex = choice
	;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM get_table('Men');

--Вывести всех спортсменов, у которых возраст равен среднему возрасту тренеров мужчин(женщин) делить на 2
CREATE OR REPLACE FUNCTION get_sportsmens(choice SEX) RETURNS SETOF sportsmen AS $$
DECLARE sr_age integer;
		summ integer;
		count integer;
		i_age integer;
		men sportsmen%rowtype;
BEGIN
	count := 0;
	summ := 0;
	FOR i_age IN 
	SELECT Age FROM trainer
	WHERE choice = Sex
	LOOP
		summ := summ + i_age;
		count := count + 1;
	END LOOP;
	sr_age := summ / count / 2;
	
	FOR men IN
	SELECT * FROM sportsmen
	WHERE sportsmen.age = sr_age
	LOOP
		return NEXT men;
	END LOOP;
	return;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM get_sportsmens('Men');
SELECT * FROM get_sportsmens('Women');



-- Считает площадь всех этажей всех спортивных площадок
CREATE OR REPLACE FUNCTION full_stages_area(amount INTEGER) RETURNS INTEGER AS $$
DECLARE
		area INTEGER;
		stage_amount INTEGER;
BEGIN
	IF amount - 1 < COUNT(*) FROM sport_place THEN
		area := SUM(sport_place.area) FROM sport_place WHERE sport_place.Id = amount;
		stage_amount := SUM(sport_place.stage_amount) FROM sport_place WHERE sport_place.Id = amount;
		return area * stage_amount + full_stages_area(amount + 1);
	ELSE
		return 0;
	END IF;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM full_stages_area(1);

--Вторая часть

--Добавляет выбранного спортсмена в тренера
CREATE OR REPLACE PROCEDURE test(person INTEGER)
LANGUAGE plpgsql    
AS $$
DECLARE i_id INTEGER;
BEGIN
	i_id := COUNT(*) FROM trainer;
	i_id := i_id + 1;
    INSERT INTO trainer SELECT i_id, Full_name, Sport_razryad, 6, Age, Phone_number, Sex
		FROM sportsmen
		WHERE Id = person;
END;
$$;

CALL test(5);

--Добавляет 10 спортсменов, начиная с person, в тренеры выбранного пола
CREATE OR REPLACE PROCEDURE rekurs_test(person SEX, amount INTEGER)
LANGUAGE plpgsql    
AS $$
DECLARE i_id INTEGER;
		add_people INTEGER;
BEGIN
	i_id := COUNT(*) FROM trainer;
	i_id := i_id + 1;
	IF amount + 10 > COUNT(*) FROM sportsmen THEN
		add_people := COUNT(*) FROM sportsmen;
	ELSE
		add_people := 10 + amount;
	END IF;
	IF amount < add_people THEN
		INSERT INTO trainer SELECT i_id, Full_name, Sport_razryad, 6, Age, Phone_number, Sex
		FROM sportsmen
		WHERE Id = amount AND person = Sex AND Sport_razryad <= 'First-Class Sportsman' AND Age >= 18;
		CALL rekurs_test(person, amount + 1);
	END IF;
END;
$$;

CALL rekurs_test('Women', 1);



--Распечатывает запрос
create or replace procedure print_my_select()
language plpgsql as $$
declare
	cur cursor
	for SELECT Full_name, Age,
	CASE 
	WHEN Age < 25 THEN 'Youthful'
	WHEN Age < 40 THEN 'Ok'
	WHEN Age < 60 THEN 'Old'
	ELSE 'Very Old'
	END AS Price
	FROM trainer
	;
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice '(Full_name = %) {Age = %}',
		row.Full_name, row.Age;
	end loop;
	close cur;
end;
$$

CALL print_my_select();


--Распечатывает информацию о таблицах: название и их физический размер
create or replace procedure table_size_list()
language plpgsql as $$
declare
	cur cursor
	for select
	table_name, size
	from (
		select table_name,
		pg_relation_size(cast(table_name as varchar)) as size 
		from information_schema.tables
		where table_schema not in ('information_schema','pg_catalog')
		order by size desc
	) as tmp;
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice '{ table : % } { size : % }',
		row.table_name, row.size;
	end loop;
	close cur;
end;
$$;

CALL table_size_list();

--Распечатывает строку, добавленную в тренера
create or replace function insert_trainer_info()
returns trigger as $$
begin
	raise notice 'New row was added in trainer:';
	raise notice '(id %, Full_name %, sport_razryad %, experience %, age %, phone_number %, sex %)',
	new.id, new.Full_name, new.sport_razryad, new.experience, new.age, new.phone_number, new.sex;
	return new;
end;
$$ language plpgsql;

create trigger insert_trainer_info
after insert on trainer for each row
execute procedure insert_trainer_info();

drop trigger if exists insert_trainer_info on trainer;


--Добавляем в sport_place данные даже если площадь < 0
create or replace function add_place()
returns trigger as $$
	begin
		if new.area < 0 then
			raise notice 'Area less then 0!';
			raise notice 'sport_place:% with 1 area was added', new.Name;
			insert into sport_place values (new.id, new.address, 1, new.stage_amount, new.name);
		else
			insert into sport_place values (new.id, new.address, new.area, new.stage_amount, new.name);
		end if;
		return new;
	end;
$$ language plpgsql;


create trigger add_place
instead of insert on table_for_instead_of for each row
execute procedure add_place();

CREATE VIEW table_for_instead_of AS
SELECT * FROM sport_place;


drop trigger if exists add_place on table_for_instead_of;


INSERT INTO table_for_instead_of VALUES (11, 'WHEREAS', -3, 5, 'SUPER ARENA');
INSERT INTO table_for_instead_of VALUES (12, 'WHEREAS', 5, 5, 'SUPER ARENA');


