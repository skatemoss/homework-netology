-- ======== ОСНОВНАЯ ЧАСТЬ ========
-- Задание №1
-- Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
-- 		Пронумеруйте все платежи от 1 до N по дате +
-- 		Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате +
-- 		Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна быть сперва по дате платежа, а затем по сумме платежа от наименьшей к большей
--		Пронумеруйте платежи для каждого покупателя по стоимости платежа от наибольших к меньшим так, чтобы платежи с одинаковым значением имели одинаковое значение номера.
select 
	customer_id,
	payment_id,
	payment_date,
	row_number () over (order by payment_date) "Номер платежа по дате",
	row_number() over (partition by customer_id order by payment_date ) "Номер платежа для покупателей",
	sum(amount) over (partition by customer_id order by payment_date, amount) "Сумма всех платежей покупателя",
	dense_rank() over (partition by customer_id order by amount DESC) "Номер платежа по стоимости платежа"
from payment
order by customer_id, 7

-- Задание №2
-- С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
-- платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.
select 
	customer_id,
	payment_id,
	payment_date,
	amount,
	lag((amount), 1, 0.0) over (partition by customer_id order by payment_date) last_amount
from payment

-- Задание №3
-- С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.
select 
	customer_id,
	payment_id,
	payment_date,
	amount,
	amount - lead((amount), 1) over (partition by customer_id) difference
from payment

-- Задание №4
-- С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.
select customer_id, payment_id, payment_date, last_value amount
from(
	select customer_id, payment_id, payment_date,
		row_number() over (partition by customer_id),
		last_value(amount) over (partition by customer_id order by payment_date desc)
	from payment) p
where row_number = 1

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ========
-- Задание №1
-- 20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
-- дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
-- которые в день проведения акции получили скидку
select customer_id, payment_date, payment_number 
from( 
	select 
		customer_id, 
		payment_date, 
		row_number() over (partition by date(payment_date) order by payment_date) payment_number
	from payment) p
where (payment_number % 100 = 0) and ('2005.08.19' < date(payment_date) and date(payment_date) < '2005.08.21') 