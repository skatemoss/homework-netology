-- ======== ОСНОВНАЯ ЧАСТЬ ========
-- Задание №1
-- Выведите уникальные названия городов из таблицы городов.
select distinct city 
from city c;

-- Задание №2
-- Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города, 
-- названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.
select distinct city 
from city
where city like 'L%a' and city not like '% %';

-- Задание №3
-- Получите из таблицы платежей за прокат фильмов информацию по платежам, 
-- которые выполнялись в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно 
-- и стоимость которых превышает 1.00. Платежи нужно отсортировать по дате платежа.
select payment_id,
	   date(payment_date),
	   amount 
from payment 
where payment_date between '2005-06-17' and '2005-06-20' and amount > 1.0
order by payment_date;

-- Задание 4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.
select payment_id,
	   payment_date,
	   amount 
from payment 
order by payment_date desc 
limit 10;

-- Задание №5
-- Выведите следующую информацию по покупателям:
-- 		Фамилия и имя (в одной колонке через пробел)
-- 		Электронная почта
-- 		Длину значения поля email
-- 		Дату последнего обновления записи о покупателе (без времени)
-- 		Каждой колонке задайте наименование на русском языке.
select CONCAT(first_name, ' ', last_name) as "Фамилия Имя",
	   email as "Электронная почта",
	   character_length(email) as "Длина Email",
	   date(last_update) as "Дата"
from customer;

-- Задание №6
-- Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE. 
-- Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.
select lower(last_name),
	   lower(first_name),
	   active 
from customer
where active = 1 and (first_name = 'KELLY' or first_name = 'WILLIE');

-- ======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ========
-- Доп. задание №1
-- Выведите информацию о фильмах, у которых рейтинг “R” и стоимость аренды указана от 0.00 до 3.00 включительно,
-- а также фильмы c рейтингом “PG-13” и стоимостью аренды больше или равной 4.00.
select film_id,
	   title,
	   description,
	   rating,
	   rental_rate
from film
where rating = 'R' and  rental_rate between 0.0 and 3.0 or rating = 'PG-13' and rental_rate >= 4.0;

-- Доп. задание №2
-- Получите информацию о трёх фильмах с самым длинным описанием фильма.
select film_id,
	   title,
	   description 
from film 
order by character_length(description) desc
limit 3;

-- Доп. задание №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
-- 		в первой колонке должно быть значение, указанное до @,
-- 		во второй колонке должно быть значение, указанное после @.
select customer_id,
	   email,
	   substring(email for strpos(email, '@') - 1) as "Email before @",
	   substring(email from position('@' in email) + 1) as "Email after @"
from customer;

-- Доп. задание №4
-- Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках:
-- первая буква строки должна быть заглавной, остальные строчными.
select customer_id,
	   email,
	   concat(left(substring(email for strpos(email, '@') - 1),1), lower(substring(email from 2 for strpos(email, '@') - 2))) as  "Email before @",
	   concat(upper(left(substring(email from strpos(email, '@')+1), 1)), lower(substring(email from position('@' in email) + 2))) as  "Email after @"
from customer;