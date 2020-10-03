CREATE TYPE DEPARTMENT AS ENUM (
    'IT',
    'Bookkeeping'
);

CREATE TYPE WEEK_DAY AS ENUM (
    'Monday',
    'Tuesday',
	'Wednesday',
	'Thursday',
	'Friday',
	'Saturday',
	'Sunday'
);

CREATE TYPE COMING_LEAVING AS ENUM (
    '1',
    '2'
);

CREATE TABLE employee
(
    Id SERIAL PRIMARY KEY,
    Full_name CHAR(100) NOT NULL,
    Born_date Date CHECK(Born_date > '1900-01-01') NOT NULL,
	Department DEPARTMENT NOT NULL
);

DROP TABLE if EXISTS coming_leaving_employee;

CREATE TABLE coming_leaving_employee
(
	Employee_id INTEGER NOT NULL,
    FOREIGN KEY (Employee_id) REFERENCES employee (Id),
	Sysdate Date CHECK(Sysdate > '2018-01-01') NOT NULL,
	Week_day WEEK_DAY NOT NULL,
	Systime Time NOT NULL,
	Coming_leaving COMING_LEAVING NOT NULL
);

INSERT INTO employee (Id, Full_name, Born_date, Department)
VALUES (1, 'Иванов Иван Иванович', '1990-09-25', 'IT');

INSERT INTO employee (Id, Full_name, Born_date, Department)
VALUES (3, 'Сергеев Сергей Сергеевич', '1988-12-01', 'IT');

INSERT INTO employee (Id, Full_name, Born_date, Department)
VALUES (2, 'Петров Петр Петрович', '1987-11-12', 'Bookkeeping');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2018-12-14', 'Saturday', '09:00', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (3, '2018-12-14', 'Saturday', '09:00', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2018-12-14', 'Saturday', '09:20', '2');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2018-12-14', 'Saturday', '09:25', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (2, '2018-12-14', 'Saturday', '09:05', '1');





INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2018-12-13', 'Friday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (3, '2018-12-13', 'Friday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2018-12-12', 'Thursday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2018-12-11', 'Wednesday', '09:20', '1');




INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-21', 'Wednesday', '09:20', '1');



INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-21', 'Wednesday', '09:20', '2');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (3, '2019-12-21', 'Wednesday', '09:20', '2');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-21', 'Wednesday', '09:25', '2');


SELECT * from employee;
SELECT * from coming_leaving_employee;

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-20', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-19', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-18', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-17', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-16', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-15', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-14', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-13', 'Wednesday', '09:20', '1');

INSERT INTO coming_leaving_employee (Employee_id, Sysdate, Week_day, Systime, Coming_leaving)
VALUES (1, '2019-12-12', 'Wednesday', '09:20', '1');



select * from employee;
select * from coming_leaving_employee;


DROP FUNCTION IF EXISTS get_employees_late;


CREATE TYPE average_state AS (
  accum numeric,
  qty numeric
);

DROP aggregate employee_avg(Time, Date);

create aggregate employee_avg(Time, Date)
(
    sfunc = get_employees_late_age,
    stype = average_state,
    initcond = '(0,0)',
	finalfunc = average_final
);


CREATE OR REPLACE FUNCTION average_final(
  state average_state
) RETURNS numeric AS $$
BEGIN
  RETURN CASE WHEN state.qty > 0 THEN
    trim(trailing '0' from (state.accum/state.qty)::text)::numeric
  END;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS get_employees_late_age;

CREATE OR REPLACE FUNCTION get_employees_late_age(state average_state,
  tm Time, born_date date) RETURNS average_state AS $$
DECLARE
    age numeric;
	today date;
BEGIN
	today := '2019-12-21';
	age = (today - born_date) / 365;
	IF tm > '9:00' THEN
		RETURN ROW(state.accum + age, state.qty + 1)::average_state;
	END IF;
	RETURN ROW(state.accum, state.qty)::average_state;
END
$$ LANGUAGE 'plpgsql';


SELECT employee_avg(tab.tm, tab.born_date)
FROM (
	SELECT MIN(cl.systime) AS tm, e.Born_date AS born_date
	FROM coming_leaving_employee AS cl JOIN employee AS e ON e.Id = cl.Employee_id 
	WHERE cl.Sysdate = '2018-12-13' AND e.department = 'IT' AND cl.coming_leaving = '1'
	GROUP BY e.ID
	 ) AS tab



SELECT * from current_date;


SELECT tab.dep FROM (
	SELECT e.ID AS id, COUNT(cl.systime) AS amount, e.department AS dep
	FROM coming_leaving_employee AS cl JOIN employee AS e ON e.Id = cl.Employee_id 
	WHERE cl.Sysdate <= current_date AND cl.Sysdate > current_date - 10 AND cl.coming_leaving = '1' AND cl.systime > '9:00'
	GROUP BY e.ID) AS tab
WHERE tab.amount = 10

Select tab.name FROM (
	SELECT e.ID AS id, e.Full_name as name, COUNT(cl.systime) AS amount
	FROM coming_leaving_employee AS cl JOIN employee AS e ON e.Id = cl.Employee_id 
	WHERE cl.Sysdate = current_date AND cl.coming_leaving = '2' AND cl.systime > '9:00' AND cl.systime < '18:00'
	GROUP BY e.ID
	) AS tab
	WHERE tab.amount = (
		SELECT MAX(tab.amount) as mx FROM (
	SELECT e.ID AS id, e.Full_name as name, COUNT(cl.systime) AS amount
	FROM coming_leaving_employee AS cl JOIN employee AS e ON e.Id = cl.Employee_id 
	WHERE cl.Sysdate = current_date AND cl.coming_leaving = '2' AND cl.systime > '9:00' AND cl.systime < '18:00'
	GROUP BY e.ID
	) AS tab
	)
	


SELECT tab.dep FROM (
	SELECT e.ID AS id, e.department AS dep
	FROM coming_leaving_employee AS cl JOIN employee AS e ON e.Id = cl.Employee_id 
	WHERE cl.coming_leaving = '1' AND cl.systime > '9:00'
	GROUP BY e.ID) AS tab RIGHT OUTER JOIN employee AS e ON e.ID = tab.id


SELECT * FROM employee;
select * from coming_leaving_employee;