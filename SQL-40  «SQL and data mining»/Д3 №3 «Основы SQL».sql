-- ======== ОСНОВНАЯ ЧАСТЬ ========
-- Задание №1
-- Выведите для каждого покупателя его адрес проживания, 
-- город и страну проживания.
select concat(c.last_name, ' ', c.first_name) "Customer name", a.address, c2.city, c3.country 
from customer c
join address a on c.address_id = a.address_id
join city c2 on c2.city_id = a.city_id
join country c3 on c3.country_id = c2.country_id 

-- Задание №2
-- С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
select s.store_id "ID магазина", count(c.store_id) "Количество покупателей"
from store s
join customer c on c.store_id = s.store_id
group by s.store_id, c.store_id 

-- Доработайте запрос и выведите только те магазины, 
-- у которых количество покупателей больше 300-от.
-- Для решения используйте фильтрацию по сгруппированным строкам 
-- с использованием функции агрегации.
select s.store_id "ID магазина", count(c.store_id) "Количество покупателей"
from store s
join customer c on c.store_id = s.store_id
group by s.store_id, c.store_id
having count(c.store_id) > 300

-- Доработайте запрос, добавив в него информацию о городе магазина, 
-- а также фамилию и имя продавца, который работает в этом магазине.
select 
	s.store_id "ID магазина", count(c.store_id) "Количество покупателей", 
	c2.city "Город", 
	concat(s2.last_name, ' ', s2.first_name) "Имя сотрудника"   
from store s
join customer c on c.store_id = s.store_id
join address a on s.address_id = a.address_id
join city c2 on c2.city_id = a.city_id
join staff s2 on s2.store_id = s.store_id 
group by s.store_id, c.store_id, c2.city, a.address_id, concat(s2.last_name, ' ', s2.first_name) 
having count(c.store_id) > 300

-- Задание №3
-- Выведите ТОП-5 покупателей, 
-- которые взяли в аренду за всё время наибольшее количество фильмов
select 
	concat(c.last_name, ' ', c.first_name) "Фамилия и имя покупателя",
	count(r.customer_id) "Количество фильмов"
from customer c 
join rental r on r.customer_id = c.customer_id 
group by concat(c.last_name, ' ', c.first_name), r.customer_id
order by 2 desc
limit 5

-- Задание №4
-- Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма
select 
	concat(c.last_name, ' ', c.first_name) "Фамилия и имя покупателя",
	count(r.customer_id) "Количество фильмов",
	round(sum(p.amount), 0)  "Общая стоимость платежей",
	min(p.amount) "Минимальная стоимость платежа",
	max(p.amount) "Максимальная стоимость платежа"
from customer c 
join rental r on r.customer_id = c.customer_id 
join payment p on p.rental_id = r.rental_id
group by concat(c.last_name, ' ', c.first_name)
order by 1

-- Задание №5
-- Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
-- чтобы в результате не было пар с одинаковыми названиями городов. 
-- Для решения необходимо использовать декартово произведение.
select c1.city "Город 1", c2.city "Город 2" 
from city c1, city c2
where c1.city < c2.city 
order by 1

-- Задание №6
-- Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
-- и дате возврата фильма (поле return_date), 
-- вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
select
	r.customer_id "ID",
	round(avg(date(return_date) - date(rental_date)), 2) "Среднее количество дней на возврат"
from rental r
group by customer_id 
order by 1

-- ======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ========
-- Задание №1
-- Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.
select
	f.title "Название фильма",
	f.rating "Рейтинг",
	c."name" "Жанр",
	f.release_year "Год выпуска",
	l."name" "Язык",
	count(i.inventory_id) "Количество аренд",
	sum(p.amount) "Общая стоимость аренды"
from film f 
join film_category fc on fc.film_id = f.film_id 
join category c on fc.category_id = c.category_id 
join "language" l on l.language_id = f.language_id 
join inventory i  on i.film_id  = f.film_id 
join rental r on r.inventory_id = i.inventory_id
join payment p on p.rental_id = r.rental_id
group by f.title, f.rating, c."name", f.release_year, l."name"

-- Задание №2
-- Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.
select
	f.title "Название фильма",
	f.rating "Рейтинг",
	c."name" "Жанр",
	f.release_year "Год выпуска",
	l."name" "Язык",
	count(r.inventory_id) "Количество аренд",
	sum(p.amount) "Общая стоимость аренды"
from film f 
join film_category fc on fc.film_id = f.film_id 
join category c on fc.category_id = c.category_id 
join "language" l on l.language_id = f.language_id 
left join inventory i  on i.film_id  = f.film_id 
left join rental r on r.inventory_id = i.inventory_id
left join payment p on p.rental_id = r.rental_id
group by f.title, f.rating, c."name", f.release_year, l."name"
having count(r.inventory_id) = 0