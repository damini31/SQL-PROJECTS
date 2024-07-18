use mavenfuzzyfactory;

/*TASK : 2012 was a great year for us. As we continue to grow, we
should take a look at 2012’s monthly and weekly volume
patterns , to see if we can find any seasonal trends we
should plan for in 2013.
If you can pull session volume and order volume , that
would be excellent.*/


--Monthly volume
select
Year(ws.created_At) Year,
month(ws.created_At) Month,
count(distinct ws.website_session_id) as 'sessions',
count(distinct o.order_id) as 'orders'
from
website_sessions ws
LEFT JOIN
orders o
on ws.website_session_id = o.website_session_id
where ws.created_at < '1/1/2013'
group by 
Year(ws.created_At),
month(ws.created_At)
order by 
Year(ws.created_At),
month(ws.created_At)

--Weekly volume
select
convert(date,min(ws.created_at)) week_start,
count(distinct ws.website_session_id) as 'sessions',
count(distinct o.order_id) as 'orders'
from
website_sessions ws
LEFT JOIN
orders o
on ws.website_session_id = o.website_session_id
where ws.created_at < '1/1/2013'
group by 
datepart(ww,ws.created_at)
order by week_start

--Observation :Significant volume increase can be seen during 3rd and 4th week of November(as per the data - black friday and cyber monday), so we should be all set in 2013 for this period in terms of customer support and inventory management


-----------------------------------------------------------------------------------------------------------------------

/* TASK : We’re considering adding live chat support to the website
to improve our customer experience. Could you analyze
the average website session volume, by hour of day and
by day week so that we can staff appropriately?
Let’s avoid the holiday time period and use a date range of
Sep 15 Nov 15, 2013*/

select
hr,
Round(AVG(case when wkday = 2 then sessions else null end),1) as 'mon' ,
Round(AVG(case when wkday = 3 then sessions else null end),1) as 'tue' ,
Round(AVG(case when wkday = 4 then sessions else null end),1) as 'wed' ,
Round(AVG(case when wkday = 5 then sessions else null end),1) as 'thu' ,
Round(AVG(case when wkday = 6 then sessions else null end),1) as 'fri' , 
Round(AVG(case when wkday = 7 then sessions else null end),1) as 'sat' ,
Round(AVG(case when wkday = 1 then sessions else null end),1) as 'sun'
from
(select 
convert(date,created_at) as created,
datepart(dw,created_at) as wkday,
datepart(hh,created_at) as hr,
cast(count(distinct website_sessions.website_Session_id) as float) as sessions
from website_sessions
where created_at between '09/15/2012' and '11/15/2012'
group by 
convert(date,created_at) ,
datepart(dw,created_at) ,
datepart(hh,created_at)) daily_data
group by hr
order by hr

