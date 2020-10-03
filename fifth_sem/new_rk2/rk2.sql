--Левушкин Илья ИУ7-52Б Рубежный контроль 2. Вариант 4

create table employee
(
	Id SERIAL PRIMARY KEY,
	FIO CHAR(100) NOT NULL,
	Year INTEGER NOT NULL,
	Experience INTEGER NOT NULL,
	Phone_number BIGINT NOT NULL
);

create table security
(
	Id SERIAL PRIMARY KEY,
	Name CHAR(100) NOT NULL,
	Address CHAR(100) NOT NULL,
	employee_id INTEGER,
	FOREIGN KEY (employee_id) REFERENCES employee (Id)
);

create table duty
(
	Id SERIAL PRIMARY KEY,
	Date DATE NOT NULL,
	Time TIME NOT NULL
);

create table duty_employee
(
	Duty_id INTEGER,
    Employee_id INTEGER,
    FOREIGN KEY (Employee_id) REFERENCES employee (Id),
    FOREIGN KEY (Duty_id) REFERENCES duty (Id)
);


INSERT INTO employee (Id, FIO, Year, Experience, Phone_number) VALUES (1, 'Anton', 1977, 10, 89859771492);
INSERT INTO employee (Id, FIO, Year, Experience, Phone_number) VALUES (2, 'Dima', 1978, 11, 89859971492);
INSERT INTO employee (Id, FIO, Year, Experience, Phone_number) VALUES (3, 'Vasya', 1979, 12, 89859774492);


INSERT INTO security (Id, Name, Address, employee_id) VALUES (1, 'Post_1', 'Uliza number 1', 1);
INSERT INTO security (Id, Name, Address, employee_id) VALUES (2, 'Post_2', 'Uliza number 2', 1);
INSERT INTO security (Id, Name, Address, employee_id) VALUES (3, 'Post_3', 'Uliza number 3', 2);
INSERT INTO security (Id, Name, Address, employee_id) VALUES (4, 'Post_4', 'Uliza number 4', 3);
INSERT INTO security (Id, Name, Address, employee_id) VALUES (5, 'Post_5', 'Uliza number 5', 3);
INSERT INTO security (Id, Name, Address, employee_id) VALUES (6, 'Post_6', 'Uliza number 6', 3);


INSERT INTO duty (Id, Date, Time) VALUES (1, 'Jan-12-2018', '07:00');
INSERT INTO duty (Id, Date, Time) VALUES (2, 'Jan-11-2018', '12:00');
INSERT INTO duty (Id, Date, Time) VALUES (3, 'Jan-10-2018', '16:00');
INSERT INTO duty (Id, Date, Time) VALUES (4, 'Jan-09-2018', '19:00');
INSERT INTO duty (Id, Date, Time) VALUES (5, 'Jan-08-2018', '20:00');

INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (1, 1);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (1, 2);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (1, 3);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (2, 1);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (3, 2);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (3, 3);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (4, 2);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (5, 1);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (5, 2);
INSERT INTO duty_employee (Duty_id, Employee_id) VALUES (5, 3);



--1) Инструкция SELECT, использующая поисковое выражение CASE
--Разбивает сотрудников на молодых старых и обычных
SELECT FIO, CASE
WHEN Year < 1978 THEN 'Old'
WHEN Year = 1978 THEN 'Ok'
ELSE 'Young'
END AS Oldness
FROM employee;

--2) Инструкция UPDATE со скалярным подзапросом в предложении SET
-- Увеличивает опыт работы сотрудников на столько, сколько всего существует сотрудников
UPDATE employee
SET experience = experience + (
	SELECT COUNT(*) FROM employee
);

select * from employee;

--3) Инструкция SELECT, консолидирующую данные с помощью предложения GROUP BY и предложения HAVING
--Вывести имя сотрудников и дату их дежурства, у которых средний опыт работы у всех сотрудников, работающих
--в этот же день больше среднего опыта работы всех сотрудников в целом
SELECT DISTINCT e.FIO, d.date
FROM employee AS e JOIN duty_employee AS de ON e.Id = de.Employee_id
				   JOIN duty AS d ON d.Id = de.Duty_id
GROUP BY e.FIO, d.date
HAVING AVG(e.Experience) >
	(
	SELECT AVG(Experience)
	FROM employee
	)
;


--Создать хранимую процедуру с выходным параметром, которая уничтожает все SQL DDL триггеры (триггеры типа 'TR')
--в текущей базе данных. Выходной параметр возвращает количество уничтоженных триггеров.
--Созданную хранимую процедуру протестировать.
CREATE OR REPLACE FUNCTION strip_all_triggers() RETURNS INT AS $$ DECLARE
    triggNameRecord RECORD;
    triggTableRecord RECORD;
	count INT;
BEGIN
    FOR triggNameRecord IN select distinct(trigger_name) from information_schema.triggers where trigger_schema = 'public' LOOP
        FOR triggTableRecord IN SELECT distinct(event_object_table) from information_schema.triggers where trigger_name = triggNameRecord.trigger_name LOOP
            EXECUTE 'DROP TRIGGER ' || triggNameRecord.trigger_name || ' ON ' || triggTableRecord.event_object_table || ';';
			count := count + 1;
        END LOOP;
    END LOOP;

    RETURN count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

select strip_all_triggers();