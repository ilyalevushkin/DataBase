-- Использование JSON с базами данных

-- 1) Из таблиц базы данных, созданной в ЛР 1,
-- извлечь данные с помощью функций создания JSON.
select row_to_json(trainer) from trainer;
select to_json(trainer) from trainer;
select json_build_array(row(trainer)) from trainer;

-- 2) Выполниить загрузку и сохранение данных с JSON-документом
-- Сохранение в JSON

select row_to_json(trainer) from trainer;
copy (select row_to_json(trainer) from trainer) to '/bd/e5.json';


select array_to_json(array_agg(row_to_json(training_sportsmen))) from training_sportsmen;

copy (select array_to_json(array_agg(row_to_json(training_sportsmen))) from training_sportsmen)
to '/bd/d5.json';

-- Загрузка из JSON-файла
drop table document_import;
create unlogged table document_import(doc json);

copy document_import from '/bd/d5.json';

select * from document_import;

insert into training_sportsmen (
    training_id, sportsmen_id)
select p.*
from document_import
cross join json_populate_recordset(null::training_sportsmen, doc) as p;

select * from training_sportsmen;

truncate training_sportsmen;

-- 3) Работа с JSON-схемой
-- 	1. Создать JSON-схему для какого-либо документа,
-- 	набрав описание вручную с помощью какого-либо текстового редактора.

-- 	2. Создать JSON-схему из документа генератором.

-- 4) Написать консольное приложение на языке Python, которое выполняет проверку
-- допустимости разработанного в текущей ЛР JSON-документа, используя JSON-схему.
-- Проведите эксперименты с XML-документом и убедитесь в том, что
-- приложение действительно обнаруживает ошибки при проверке допустимости.
