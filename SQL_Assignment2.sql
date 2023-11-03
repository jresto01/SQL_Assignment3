--1. List all customers who live in Texas (use JOINs)
--Inner join
select first_name, last_name, district
from customer
inner join address
on customer.address_id = address.address_id
where address.district = 'Texas';

--Left join
select first_name, last_name, district
from customer
left join address
on customer.address_id = address.address_id
where address.district = 'Texas';

--Right join
select first_name, last_name, district
from customer
right join address
on customer.address_id = address.address_id
where address.district = 'Texas';

--Full join
select first_name, last_name, district
from customer
full join address
on customer.address_id = address.address_id
where address.district = 'Texas';

--2. Get all payments above $6.99 with the Customer's Full Name
--Inner join
select first_name, last_name, amount
from customer
inner join payment 
on customer.customer_id = payment.customer_id 
where amount > 6.99;

--Left join
select first_name, last_name, amount
from customer
left join payment 
on customer.customer_id = payment.customer_id 
where amount > 6.99;

--Right join
select first_name, last_name, amount
from customer
right join payment 
on customer.customer_id = payment.customer_id 
where amount > 6.99;

--Full join
select first_name, last_name, amount
from customer
full join payment 
on customer.customer_id = payment.customer_id 
where amount > 6.99;

--3. Show all customers names who have made payments over $175(use subqueries)
select first_name, last_name
from customer
where customer_id in (
	select customer_id
	from payment
	where amount > 175);
--OR
select first_name, last_name, amount
from(
	select customer.first_name, customer.last_name, amount
	from customer, payment 
	where customer.customer_id = payment.customer_id 
) as subquery
where amount > 175;

--Using join
select distinct on (first_name, last_name) first_name, last_name, amount
from customer
join payment 
on customer.customer_id = payment.customer_id 
where amount > 175;
--OR
select first_name, last_name, amount
from customer
join payment 
on customer.customer_id = payment.customer_id 
where amount > 175;

--4. List all customers that live in Nepal (use the city table)
--Using join
select first_name, last_name, country from customer 
full join address on customer.address_id = address.address_id 
full join city on address.city_id = city.city_id
full join country on city.country_id = country.country_id
where country.country = 'Nepal';
--Using subquieries
select first_name, last_name, country
from(
	select customer.first_name, customer.last_name, country.country
	from customer, address, city, country
	where customer.address_id = address.address_id 
	and address.city_id = city.city_id 
	and city.country_id = country.country_id 
) as subquery
where subquery.country = 'Nepal';
--Using join and subquery
select first_name, last_name, country
from( 
	select first_name, last_name, country
	from customer
	full join address on customer.address_id = address.address_id
	full join city on address.city_id = city.city_id
	full join country on city.country_id = country.country_id
) as subquery
where subquery.country = 'Nepal';

--5. Which staff member had the most transactions?
--Using join 
select first_name, last_name, count(payment_id)
from staff
full join payment on payment.staff_id = staff.staff_id
group by staff.staff_id
order by count(payment_id) desc;
--Using subquiery 
select first_name, last_name, transactions
from( 
	select first_name, last_name, count(payment_id) as transactions
	from payment, staff
	where payment.staff_id = staff.staff_id 
	group by staff.staff_id 
) as subquery
order by transactions desc;
--Using both 
select first_name, last_name, transactions
from(
	select first_name, last_name, count(payment_id) as transactions
	from staff
	full join payment on payment.staff_id = staff.staff_id
	group by staff.staff_id 
) as subquery
order by transactions desc;

--6.How many movies of each rating are there?
select rating, rating_count
from (
	select rating, count(rating) as rating_count
	from film
	group by rating
) as subquery;
--If the question is how many movies of each rating have been rented.
select rating, movies_rented
from(
	select rating, count(rating) as movies_rented
	from payment
	full join rental on payment.rental_id = rental.rental_id 
	full join inventory on rental.inventory_id = inventory.inventory_id 
	full join film on inventory.film_id = film.film_id
	group by rating
) as subquery
order by movies_rented desc;

--7. Show all customers who have made a single payment above $6.99 (Use Subqueries)
select first_name, last_name, amount
from(
	select customer.first_name, customer.last_name, amount
	from customer, payment 
	where customer.customer_id = payment.customer_id 
) as subquery
where amount > 6.99;
--OR
select customer_id, first_name, last_name
from customer
where customer_id in(
	select customer_id
	from payment
	where amount > 6.99
	group by customer_id
);
--OR
select customer_id, first_name, last_name, num_of_payments
from(
	select customer.customer_id, customer.first_name, customer.last_name, 
	count(amount) as num_of_payments
	from customer, payment 
	where customer.customer_id = payment.customer_id and amount > 6.99
	group by customer.customer_id 
) as subquery;

--8. How many free rentals did our stores give away?
--This works for other amounts but there is no ammount = 0.00 in the payment table
select store_id, free_rentals
from(
	select staff.store_id, count(payment.rental_id) as free_rentals
	from staff
	full join rental on staff.staff_id = rental.staff_id 
	full join payment on rental.rental_id = payment.rental_id 
	where payment.amount = 0.00
	group by staff.store_id
) as subquery;
--Here an example using an amount in the payment table for verification
select store_id, free_rentals
from(
	select staff.store_id, count(payment.rental_id) as free_rentals
	from staff
	full join rental on staff.staff_id = rental.staff_id 
	full join payment on rental.rental_id = payment.rental_id 
	where payment.amount = 179.99
	group by staff.store_id
) as subquery;














