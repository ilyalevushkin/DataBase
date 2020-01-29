--1. Образуем пары спортсменов с одинаковым разрядом и возрастом 18 лет.
SELECT DISTINCT C1.Full_name, C2.Full_name, C1.sport_razryad, C1.age
FROM Sportsmen AS C1 JOIN Sportsmen AS C2 ON C2.sport_razryad = C1.sport_razryad
WHERE C2.Id <> C1.Id AND C1.age = 18
;

--2. Получить список всех тренировок 1 января 2010 года
SELECT DISTINCT Id, Date_time
FROM Training
WHERE Date_time BETWEEN '2010-01-01 00:00:00' AND '2010-01-01 23:59:59';

--3. Получить ФИО всех спортсменов с отчеством 'Johnson'
SELECT DISTINCT Full_name
FROM sportsmen
WHERE Full_name LIKE '%Johnson%';

--4. Получить список всех тренеров, обучающих спортсменов с отчеством 'Johnson'
SELECT DISTINCT *
FROM trainer AS t
WHERE t.Id IN
(
 SELECT t.Id
 FROM trainer AS t
	JOIN training ON t.Id = training.Trainer_id
	JOIN training_sportsmen AS ts ON ts.Training_id = training.Id
	JOIN sportsmen ON sportsmen.Id = ts.Sportsmen_id
 WHERE sportsmen.Full_name LIKE '%Johnson%'
)
ORDER BY t.Id
;

--5. Получить список всех тренеров, не имеющих никаких тренировок
SELECT Id, Full_name
FROM trainer
WHERE EXISTS
(
SELECT tr.Id
 FROM trainer AS tr
	LEFT OUTER JOIN training ON training.Trainer_id = trainer.Id
 WHERE training.Trainer_id IS NULL
);

--6. Получить список всех спортсменов, разряд которых больше разряда всех тренеров с именем 'Anthony Johnson'
SELECT *
FROM sportsmen s
WHERE s.sport_razryad < ALL
(
SELECT t.sport_razryad
 FROM trainer t
 WHERE Full_name  = 'Anthony Johnson'
);

--7. Средний возраст спортсменов
SELECT AVG(s.age) AS Sportsmen_avg
FROM sportsmen s
;
--8. Список тренеров, старших 50 лет, и вывести информацию о среднем возрасте тренеров
SELECT Full_name, Age,
	(
		SELECT AVG(Age)
		FROM trainer
	) AS Avg_age
FROM trainer
WHERE Age > 50
;
--9. Выводит ФИО, а также время тренировок, тренеров, а также 
-- определяет, на сколько дней различатся время тренировок от 15 мая 2010 года
SELECT t.Full_name, training.Date_time,
	CASE EXTRACT(day FROM training.Date_time)
		WHEN EXTRACT(day FROM TIMESTAMP '2010-05-15 00:00:00') THEN 'Today'
		WHEN EXTRACT(day FROM TIMESTAMP '2010-05-15 00:00:00') - 1 THEN 'Yesterday'
		ELSE CAST(DATE_PART('day', training.Date_time::timestamp - '2010-05-15 00:00:00'::timestamp) AS varchar(5)) || ' days diff'
	END AS When
FROM trainer AS t
JOIN training ON training.Trainer_id = t.Id
WHERE EXTRACT(year FROM training.Date_time) = 2010
;
--10. Список тренеров с информарцией о их возрасте.
SELECT Full_name, Age,
CASE 
WHEN Age < 25 THEN 'Youthful'
WHEN Age < 40 THEN 'Ok'
WHEN Age < 60 THEN 'Old'
ELSE 'Very Old'
END AS Price
FROM trainer
;
--11. Временная таблица из 10 примера
create temp table add_information_about_trainer_age
as
SELECT Full_name, Age,
CASE 
WHEN Age < 25 THEN 'Youthful'
WHEN Age < 40 THEN 'Ok'
WHEN Age < 60 THEN 'Old'
ELSE 'Very Old'
END AS Price
FROM trainer
;
--12. Выводит список тренировок сджойненой с 8 примером
SELECT *
FROM training JOIN
(SELECT ID, Full_name, Age,
	(
		SELECT AVG(Age)
		FROM trainer
	) AS Avg_age
FROM trainer
WHERE Age > 50) AS ag ON ag.id = training.trainer_id
;
--13. Вывести список тренировок спортсменов, у которых рязряд выше третьего взрослого и возраст равен минимальному возрасту тех тренеров, 
-- у которых опыт работы равен количеству спортплощадок с площадью большей количества спортивных элементов сложностью равной E
SELECT training.Id, training.Date_time, s.age
FROM training
JOIN training_sportsmen AS ts ON training.Id = ts.Training_id
JOIN sportsmen AS s ON s.Id = ts.Sportsmen_id
WHERE s.sport_razryad < 'Third-Class Sportsman' AND s.age = (
	SELECT MIN(tr.age)
	FROM trainer AS tr
	WHERE tr.experience = (
		SELECT COUNT(sport_place.Id)
		FROM sport_place
		WHERE sport_place.area > (
			SELECT COUNT(se.level) * 1000
			FROM sport_elem AS se
			WHERE se.level = 'E'
		)
	)
)
--14. Для каждого спортсмена мальчика получить его возраст, средний возраст,
-- минимальную возраст и ФИО
SELECT S.Id,
 S.Age,
AVG(S.Age) AS AvgAge,
MIN(S.Age) AS MinAge,
 S.Full_name
FROM Sportsmen AS S
WHERE S.sex = 'Men'
GROUP BY S.Id, S.Age, S.Full_name

--15. Вывести список всех разрядов, которые имеют спортсмены со средним возрастом большим общего среднего возраста
SELECT S.sport_razryad,
AVG(S.Age) AS AvgAge,
MIN(S.Age) AS MinAge
FROM Sportsmen AS S
GROUP BY S.sport_razryad
HAVING AVG(Age) >
	(
	SELECT AVG(Age)
	FROM Sportsmen
	)
;
--16. Добавление Гитлера в качестве тренера.
INSERT INTO trainer (Id, full_name, sport_razryad, experience, age, phone_number, sex)
VALUES (1001, 'Adolph Hitler', 'Master of Sport', 10, 33, 82282282282, 'Men');
--17. Добавление тренеров из базы спортсменов.
INSERT INTO trainer (Id, full_name, sport_razryad, experience, age, phone_number, sex)
SELECT s.Id, s.full_name, s.sport_razryad, 6, s.age, s.phone_number, s.sex
FROM Sportsmen AS s
WHERE s.Id > 1001 AND s.Id < 2000 AND s.age >= 18 AND Sport_razryad <= 'First-Class Sportsman'
--18. Увеличить опыт работы тренеров всем мужчинам на 2
UPDATE trainer
SET experience = experience + 2
WHERE sex = 'Men'
--19. Опыт работы тренеров мужчин равно среднему значению лет всех спортсменов с фамилией Johnson
UPDATE trainer
SET experience = (
	SELECT AVG(Age)
	FROM sportsmen
	WHERE Full_name LIKE '%Johnson%'
)
WHERE sex = 'Men'
--20. Удаляем всех тренеров с Id большим 1000
DELETE FROM trainer
WHERE Id > 1000
--21. Удаляем всех тренеров с Id большим 1000 и возрастом, который имеют спортсмены
DELETE FROM trainer
WHERE Id > 1000 AND age IN (
	SELECT DISTINCT age
	FROM sportsmen
)
;
--22. Выводит информацию о количестве молодых, старых, очень старых и не старых преподавателей
WITH AGEINFO (Name, Age_inf)
AS
(
	SELECT Full_name,
	CASE 
	WHEN Age < 25 THEN 'Youthful'
	WHEN Age < 40 THEN 'Ok'
	WHEN Age < 60 THEN 'Old'
	ELSE 'Very Old'
	END AS Price
	FROM trainer
)
SELECT Age_inf, COUNT(Age_inf)
FROM AGEINFO
GROUP BY Age_inf
;
--23. Рекурсия от текущего возраста до 18 лет (пример 22)
WITH RECURSIVE AGEINFO (Age, Age_inf, Level)
AS
(
	SELECT Age,
	CASE 
	WHEN Age < 25 THEN 'Youthful'
	WHEN Age < 40 THEN 'Ok'
	WHEN Age < 60 THEN 'Old'
	ELSE 'Very Old'
	END AS Price,
	0 AS Level
	FROM trainer
	UNION ALL
	
	SELECT (Age - 1),
	CASE
	WHEN Age < 25 THEN 'Youthful'
	WHEN Age < 40 THEN 'Ok'
	WHEN Age < 60 THEN 'Old'
	ELSE 'Very Old'
	END AS Price,
	Level + 1
	FROM AGEINFO
	WHERE Age > 19
)
SELECT Age_inf, COUNT(Age_inf)
FROM AGEINFO
GROUP BY Age_inf
;
--24. Вывести среднее значение возраста тренеров разбитых по группам разряда и пола.
SELECT tr.Full_name, tr.sport_razryad, tr.experience, tr.age,
AVG(tr.age) OVER(PARTITION BY tr.sport_razryad) AS AvgAge,
MIN(tr.age) OVER(PARTITION BY tr.sport_razryad) AS MinAge,
MAX(tr.age) OVER(PARTITION BY tr.sport_razryad) AS MaxAge,
AVG(tr.age) OVER(PARTITION BY tr.sex) AS AvgAge
FROM trainer as tr
;
--25. Пронумеровал строки с помощью функции row_number()
SELECT ROW_NUMBER() OVER(ORDER BY sport_razryad), sport_razryad, sex
FROM (SELECT sport_razryad, sex
FROM sportsmen) as f