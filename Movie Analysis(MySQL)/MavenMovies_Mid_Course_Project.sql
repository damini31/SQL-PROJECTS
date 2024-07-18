use mavenmovies;

/*
1.	We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 

select  
first_name,
last_name,
email,
store_id
from staff;


/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 

select 
store_id,
count(distinct film_id) as 'inventory items'
from inventory
group by store_id;

/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/

select 
store_id,
count(distinct customer_id) as 'active_customers'
from customer
where active = 1
group by store_id;


/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/

select count(distinct email) as 'customer_email'
from customer;

/*
5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of unique film titles 
you have in inventory at each store and then provide a count of the unique categories of films you provide. 
*/

select 
i.store_id,
#i.film_id,
count(distinct f.title) as 'unique_film_titles',
count(distinct c.name) as 'unique_film_categories'
from 
inventory i
LEFT JOIN
film f on i.film_id = f.film_id 
LEFT JOIN
film_category fc on fc.film_id = f.film_id
LEFT JOIN
category c on c.category_id = fc.category_id
group by 1;


/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/

select 
min(replacement_cost) as 'least_Expensive_RC',
max(replacement_cost) as  'most_Expensive_RC',
round(Avg(replacement_cost),2) as 'Avg_RC'
 from film;


/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/

select 
avg(amount) as 'avg_payment_processed',
max(amount) as 'max_payment_processed'
from payment;

/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/

select
c.customer_id,
count(distinct rental_id) as 'rentals'
from customer c
LEFT JOIN
rental r on c.customer_id = r.customer_id
group by 1
order by 2 desc;


