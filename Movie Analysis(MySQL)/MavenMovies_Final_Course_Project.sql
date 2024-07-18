/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

select 
s.store_id,
concat(sf.first_name,' ',sf.last_name) as 'Manager''s name',
concat(addr.address,' ,',addr.district,'  ,',c.city,'  ,',cou.country) as 'full_address'
 from 
 store s
INNER JOIN
staff sf on s.manager_Staff_id = sf.staff_id
INNER JOIN
address addr on s.address_id=  addr.address_id
INNER JOIN
city c on c.city_id = addr.city_id
INNER JOIN
country cou on cou.country_id = c.country_id;

	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/


select 
distinct
i.store_id,
i.inventory_id,
f.title,
f.rating,
f.rental_rate,
f.replacement_cost
from inventory i
LEFT JOIN film f on i.film_id = f.film_id;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

select
distinct
i.store_id,
count(case when f.rating = 'G' then inventory_id else null end ) as 'G',
count(case when f.rating = 'PG' then inventory_id else null end ) as 'PG',
count(case when f.rating = 'PG-13' then inventory_id else null end ) as 'PG-13',
count(case when f.rating = 'R' then inventory_id else null end ) as 'R',
count(case when f.rating = 'NC-17' then inventory_id else null end ) as 'NC-17'
from inventory i
LEFT JOIN film f on i.film_id = f.film_id
group by 1;


/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

select 
s.store_id,
c.name,
count(distinct i.film_id) as 'number_of_films',
avg(f.replacement_cost) as 'avg_RC',
sum(f.replacement_cost) as 'Total_RC'
from store s
LEFT JOIN
inventory i on s.store_id = i.store_id
LEFT JOIN
film f on i.film_id = f.film_id
LEFT JOIN
film_category fc on fc.film_id = f.film_id
LEFT JOIN
category c on c.category_id = fc.category_id
group by 1,2;


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

select 
concat(c.first_name,' ',c.last_name) as 'full_name',
c.store_id,
c.active,
concat(addr.address,' ,',addr.district,'  ,',city.city,'  ,',cou.country) as 'full_address'
from customer c
LEFT JOIN
address addr on c.address_id=  addr.address_id
INNER JOIN
city on city.city_id = addr.city_id
INNER JOIN
country cou on cou.country_id = city.country_id;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

select 
concat(c.first_name,' ',c.last_name) as 'full_name',
count(distinct r.rental_id) as 'lifetime rentals',
sum(p.amount) as 'total_payment'
from 
customer c
LEFT JOIN
rental r on c.customer_id = r.customer_id
LEFT JOIN
payment p on r.rental_id = p.rental_id
group by 1
order by 3 desc;

    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

select 
'advisor' as 'Type',
concat(first_name,' ',last_name) as 'full_name',
NULL as associated_with
 from advisor
UNION
select 
'investor' as 'Type',
concat(first_name,' ',last_name) as 'full_name',
company_name as associated_with
from investor;



/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

select case when awards = 'Emmy, Oscar, Tony ' then  '3 awards'
     when awards in ('Emmy, Oscar','Emmy, Tony','Oscar, Tony') then '2 awards'
     when awards in ('Emmy','Oscar','Tony') then '1 award'
     else 'other' end as 'number_of_awards',
AVG(case when actor_id is null then 0 else 1 end) as pct_w_one_film
from
actor_award
group by 1

select distinct(awards) from actor_Award


