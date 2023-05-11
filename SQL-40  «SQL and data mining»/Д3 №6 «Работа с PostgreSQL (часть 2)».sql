-- ======== ОСНОВНАЯ ЧАСТЬ ========
-- Задание №1
-- Напишите SQL-запрос, который выводит всю информацию о фильмах 
-- со специальным атрибутом "Behind the Scenes".
explain analyze 
select film_id, title, special_features 
from film
where array ['Behind the Scenes'] && special_features

-- Задание №2
-- Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
-- используя другие функции или операторы языка SQL для поиска значения в массиве.
explain analyze 
select film_id, title, special_features 
from film 
where special_features::text like '%Behind the Scenes%'

explain analyze 
select film_id, title, special_features
from film
where 'Behind the Scenes' = any (special_features)

-- Задание №3
-- Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
-- со специальным атрибутом "Behind the Scenes.
-- Обязательное условие для выполнения задания: используйте запрос из задания 1, 
-- помещенный в CTE. CTE необходимо использовать для решения задания.
explain analyze 
with cte as (
	select film_id, title, special_features 
	from film
	where array ['Behind the Scenes'] && special_features
)
select r.customer_id, count(cte.film_id) film_count
from rental r
join inventory i on r.inventory_id = i.inventory_id
join cte on cte.film_id = i.film_id
group by r.customer_id
order by r.customer_id 

-- Задание №4
-- Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".
-- Обязательное условие для выполнения задания: используйте запрос из задания 1,
-- помещенный в подзапрос, который необходимо использовать для решения задания.
explain analyze 
select customer_id, count(f.film_id) film_count
from (
	select film_id, title, special_features 
	from film
	where array ['Behind the Scenes'] && special_features
) f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by customer_id
order by customer_id 

-- Задание №5
-- Создайте материализованное представление с запросом из предыдущего задания
-- и напишите запрос для обновления материализованного представления
create materialized view view1 as
	select customer_id, count(f.film_id) film_count
	from (
		select film_id, title, special_features 
		from film
		where array ['Behind the Scenes'] && special_features
	) f
	join inventory i on f.film_id = i.film_id
	join rental r on i.inventory_id = r.inventory_id
	group by customer_id
	order by customer_id

refresh materialized view view1
	
explain analyze
select * 
from view1

-- Задание №6
-- С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:

-- 		1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, поиск значения в массиве происходит быстрее
-- 		2. какой вариант вычислений работает быстрее: с использованием CTE или с использованием подзапроса
1.	Вариант с && - (cost=0.00..67.50 rows=538 width=78) (actual time=0.013..0.479 rows=538 loops=1) - самый быстрый
	Вариант с text и like - (cost=0.00..72.50 rows=1 width=78) (actual time=0.014..0.793 rows=538 loops=1)
	Вариант с any - (cost=0.00..77.50 rows=538 width=78) (actual time=0.013..0.441 rows=538 loops=1)

2.	Вариант c CTE и вариант с подзапросом +- одинаковые.
	Получается, что в основном разница только в том, что CTE можно использовать рекурсивно, а подзапрос нельзя. 
	
	Вариант с CTE - (cost=673.97..675.47 rows=599 width=10) (actual time=10.835..10.862 rows=599 loops=1)
	Вариант с подзапросом - (cost=673.98..675.48 rows=599 width=10) (actual time=10.842..10.869 rows=599 loops=1)
	Вариант с материализированным представлением - (cost=0.00..9.99 rows=599 width=10) (actual time=0.010..0.054 rows=599 loops=1)

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============
-- ЗАДАНИЕ №1
-- Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 		1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 		2. количество фильмов взятых в аренду в этот день
-- 		3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 		4. сумму продажи в этот день
with cte1 as (
	select distinct on (s.store_id) s.store_id, rental_date::date, count(rental_id)
	from rental r
	join staff s on r.staff_id = s.staff_id 
	group by 1, 2
	order by 1, 3 desc
),
cte2 as (
	select distinct on (s.store_id) s.store_id, payment_date::date, sum(amount) 
	from payment p
	join staff s on p.staff_id = s.staff_id 
	group by 1, 2
	order by 1, 3
)
select cte1.store_id as "Store ID", 
	rental_date as "The day that rented the most movies",
	count as "Number of films rented on that day",
	payment_date as "The day on which movies were sold for the least amount of money",
	sum as "The amount of sales on that day"
from cte1
full join cte2 on cte1.store_id = cte2.store_id;