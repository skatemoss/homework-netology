-- ======== ОСНОВНАЯ ЧАСТЬ ==============
-- Спроектируйте базу данных, содержащую три справочника:
--		язык (английский, французский и т. п.);
--		народность (славяне, англосаксы и т. п.);
--		страны (Россия, Германия и т. п.).
-- Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим.
-- Требования к таблицам-справочникам:
-- 		наличие ограничений первичных ключей.
-- 		идентификатору сущности должен присваиваться автоинкрементом;
-- 		наименования сущностей не должны содержать null-значения, не должны допускаться дубликаты в названиях сущностей.
-- Требования к таблицам со связями:
--		наличие ограничений первичных и внешних ключей.
 
-- СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ
create table languages (
language_id serial primary key,
language_name varchar(50) unique not null,
created_on timestamp default (now())
)

-- ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert into languages(language_name)
values ('Японский'),
	('Французский'),
	('Английский'),
	('Русский'),
	('Китайский')

-- СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ
create table nationality (
nationality_id serial primary key,
nationality_name varchar(30) unique not null,
created_on timestamp default (now())
)

-- ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ
insert into nationality(nationality_name)
values ('Японец'),
	('Француз'),
	('Англичанин'),
	('Русский'),
	('Китаец')

-- СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ
create table country(
country_id serial primary key,
country_name varchar(30) unique not null,
created_on timestamp default (now())
)

-- ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ
insert into country(country_name)
values ('Япония'),
	('Франция'),
	('Англия'),
	('Россия'),
	('Китай')

-- СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
create table country_nationality(
nationality_id int not null references nationality(nationality_id),
country_id int not null references country(country_id),
primary key (country_id, nationality_id)
)

-- ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into country_nationality(country_id, nationality_id)
values (1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5)
	
insert into country_nationality(country_id, nationality_id)
values (5, 5)

-- СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
create table languages_nationality(
nationality_id int not null references nationality(nationality_id),
language_id int not null references languages(language_id),
primary key (language_id, nationality_id)
)

-- ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into languages_nationality(language_id, nationality_id)
values (1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5)

-- ======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ========
-- Задание №1 
-- Создайте новую таблицу film_new со следующими полями:
--   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
create table film_new(
film_name varchar(255) not null,
film_year integer check (film_year > 0),
film_rental_rate numeric(4,2) default (0.99),
film_duration integer not null check (film_duration > 0)
)

-- Задание №2 
-- Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--       film_year - array[1994, 1999, 1985, 1994, 1993]
--       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--   	  film_duration - array[142, 189, 116, 142, 195]
insert into film_new (film_name, film_year, film_rental_rate, film_duration)
select unnest(array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindler’s List']),
	unnest(array[1994, 1999, 1985, 1994, 1993]),
	unnest(array[2.99, 0.99, 1.99, 2.99, 3.99]),
	unnest (array[142, 189, 116, 142, 195])

-- Задание №3
-- Обновите стоимость аренды фиvльмов в таблице film_new с учетом информации, 
-- что стоимость аренды всех фильмов поднялась на 1.41
update film_new 
set film_rental_rate = film_rental_rate + 1.41

-- Задание №4
-- Фильм с названием "Back to the Future" был снят с аренды, 
-- удалите строку с этим фильмом из таблицы film_new
delete from film_new 
where film_name = 'Back to the Future'

-- ЗАДАНИЕ №5
-- Добавьте в таблицу film_new запись о любом другом новом фильме
insert into film_new (film_name, film_year, film_rental_rate, film_duration)
values ('No Country for Old Men', 2005, 4.4, 122)