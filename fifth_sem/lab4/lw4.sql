create extension plpythonu;

-- 1) Определяемая пользователем скалярная функция
-- Название специальности по id
drop function if exists specialty_name;

create or replace function specialty_name(id_ integer)
returns varchar as $$
specialty = plpy.execute('select * from specialty')
for row in specialty:
    if row['id'] == id_:
        return row['name']
return None
$$ language plpythonu;

select * from specialty;
select * from specialty_name(1);
select * from specialty_name(13);
select * from specialty_name(2000);

-- Количество студентов с определенным аттестатом
drop function if exists mark_count;

select count(distinct mark)
from enrollee as e
where e.mark = 3;

create or replace function mark_count(mark_type integer)
returns integer as $$
cnt = 0
for row in plpy.execute('select mark from enrollee'):
    if row['mark'] == mark_type:
        cnt += 1
return cnt
$$ language plpythonu;

select mark_count(3);
select * from mark_count(3);
select * from mark_count(4);
select * from mark_count(5);

-- 2) Пользовательская агрегатная функция
-- Максимум по столбцу
create or replace function cmp_iter(max_ integer, nxt integer)
returns integer as $$
m = max_
if m < nxt:
    m = nxt
return m
$$ language plpythonu;

return max_
$$ language plpythonu;

create aggregate my_max(integer)
(
    sfunc = cmp_iter,
    stype = integer,
    initcond = '-1'
);

select my_max(subject_1)
from enrollee as e
where mark = 3 and extra_point = 1;

select max(subject_1)
from enrollee as e
where mark = 3 and extra_point = 1;

select *
from enrollee;

select my_max(quality_mark)
from university
where demand_mark < 60 and research_mark < 60;

select max(quality_mark)
from university
where demand_mark < 60 and research_mark < 60;

select *
from university;

-- 3) Определяемая пользователем табличная функция
-- Абитуриенты с определенной оценкой в аттестате
drop function if exists get_enrollee_with_mark;

create or replace function get_enrollee_with_mark(mark_type integer)
returns table(id bigint, first_name varchar, last_name varchar, mark integer) as $$
enr = plpy.execute('select * from enrollee')
res = list()
for e in enr:
    if e['mark'] == mark_type:
	res.append((e['id'], e['first_name'], e['last_name'], e['mark']))
return res
$$ language plpythonu;

select * from enrollee;
select * from get_enrollee_with_mark(3);

-- 4) Хранимая процедура
-- Поднять рейтинг качества тем университетам,
-- у которых этот рейтинг меньше num
drop procedure if exists add_quality;

create or replace procedure add_quality(num integer)
language plpythonu as $$
plan = plpy.prepare('update university \
set quality_mark = quality_mark + 20 \
where quality_mark < $1', ['integer'])

rv = plpy.execute(plan, [str(num)], 1)
$$;

call add_quality(250);
select * from university order by id;
select * from university where id = 2;

-- 5) Триггер
-- Триггер AFTER устанавливает автоинкремент id таблицы document
-- в 1 при сбросе данных
create or replace function trunc_ext()
returns trigger as $$
plpy.execute('alter sequence document_id_seq restart with 1')
plpy.notice('Truncate document and now id will start with 1')
return TD['new']
$$ language plpythonu;

drop trigger if exists trunc_all on document;

create trigger trunc_all
after truncate on document for each statement
execute procedure trunc_ext();

truncate document;

copy document (
	enrollee_id, specialty_id, university_id, form, base, date)
from program
'tail -n+2 /home/alex/db/document.csv'
-- 'powershell Get-Content -Tail 1000 C:/sem5/database/lw1/document.csv'
delimiter ';' csv;

-- 6) Определяемый пользователем тип данных
-- Информация о документе по id: id документа и абитуриента,
-- имя и фамилия абитуриента, дата документа
drop type if exists doc_info;
create type doc_info as
(
    d_id bigint,
    e_id bigint,
    first_name varchar,
    last_name varchar,
    date date
);

create or replace function doc_ext(id_ integer)
returns doc_info as $$
doc = plpy.execute('select * from document')
enr = plpy.execute('select * from enrollee')

for d in doc:
    if d['id'] == id_:
        for e in enr:
            if e['id'] == d['enrollee_id']:
                return (d['id'], e['id'], e['first_name'], e['last_name'], d['date'])
return None			
$$ language plpythonu;

select * from enrollee;
select * from document;
select * from doc_ext(1);
select * from doc_ext(7);
select * from doc_ext(7345);
