USE mavenfuzzyfactory;

Select top 100 * from website_sessions
Select top 100 * from website_pageviews

----Sessions by UTM Content Analysis----

Select 
utm_content,
count(distinct website_session_id) as '#website_sessions'
from website_sessions
--where website_session_id between 1000 and 2000
group by utm_content
order by 1 desc

----Sessions by UTM Content & orders Analysis----
Select 
utm_content,
count(distinct website_sessions.website_session_id) as '#website_sessions',
count(distinct orders.order_id) as '#total_orders',
cast((count(distinct orders.order_id) * 100) /count(distinct website_sessions.website_session_id) as float) AS session_to_order_conv_rate
from website_sessions
LEFT JOIN orders 
on orders.website_session_id = website_sessions.website_session_id
group by utm_content
order by 1 desc



/*
Q1 - where the bulk of our website sessions are coming
from, through yesterday?
I’d like to see a breakdown by
UTM source , campaign
and referring domain if possible.
Consider data upto - April 12,2012*/


select
utm_source,
utm_campaign,
http_referer,
count(*) as 'sessions'
from
website_sessions
where created_at < '4/12/2012'
group by 
utm_source,
utm_campaign,
http_referer
order by 4 desc

--Observation : Dig deeper into 'gsearch nonbrand' campaign traffic to explore potential optimization opportunities

--------------------------------------------------------------------------------------------------------------------------

/*Sounds like gsearch nonbrand is our major traffic source, but
we need to understand if those sessions are driving sales.
Q2 - Could you please calculate the conversion rate (CVR) from session to order ? Based on what we're paying for clicks,
we’ll need a CVR of at least 4% to make the numbers work.
If we're much lower, we’ll need to reduce bids. If we’re higher, we can increase bids to drive more volume.*/

select * from orders
select * from website_sessions

select 
count(distinct website_sessions.website_session_id) as 'sessions',
count(distinct orders.order_id) as 'orders',
cast( cast((count(distinct orders.order_id)) as float)/cast(count(distinct website_sessions.website_session_id) as float) as numeric(10,5)) as 'session_to_order_conv_rate'
from website_sessions
LEFT JOIN orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '4/12/2012'
and website_sessions.utm_source = 'gsearch' 
and website_sessions.utm_campaign = 'nonbrand'


--Observation : The conversion rate is lower than the set threshold, so, as decided,we need to dial down our search bids a bit.This proves that we're over-spending based on current conversion rate

-----------------------------------------------------------------------------------------------------------------------------------
/*Based on your conversion rate analysis, we
bid down
gsearch nonbrand on 2012 04 15.
Can you pull
gsearch nonbrand trended session volume, by
week , to see if the bid changes have caused volume to drop
at all?*/

select 
Min(cast(ws.created_at as date)) as week_start,
count(distinct ws.website_session_id)
from 
website_sessions ws
where ws.created_at < '5/10/2012'
and ws.utm_source = 'gsearch' 
and ws.utm_campaign = 'nonbrand'
group by datepart(ww,created_at) -- grouping by week
order by Min(cast(ws.created_at as date)) --- ordering by minimum date

--Observation : gsearch nonbrand is sensitive to bid changes.

-----------------------------------------------------------------------------------------------------------------------------

select 
device_type,
count(distinct ws.website_session_id) as 'sessions',
count(distinct orders.order_id) as 'orders',
cast(cast(count(distinct orders.order_id) as float) /cast(count(distinct ws.website_session_id) as float) as numeric(10,5))
AS session_to_order_conv_rate
from website_sessions ws
LEFT JOIN orders 
on orders.website_session_id = ws.website_session_id
where ws.created_at < '5/11/2012'
and ws.utm_source = 'gsearch' 
and ws.utm_campaign = 'nonbrand'	
group by ws.device_type

--Observation : We should increase bids on Desktop.

------------------------------------------------------------------------------------------------------------------------------
/*After your device
level analysis of conversion rates, we
realized desktop was doing well, so we bid our gsearch
nonbrand desktop campaigns up on 2012 05 19.
Could you pull
weekly trends for both desktop and mobile
so we can see the impact on volume?
You can use 2012
04 15 until the bid change as a baseline.*/

select 
Min(cast(ws.created_at as date)) as week_start,
count(case when ws.device_type = 'desktop' then ws.website_session_id else null end) as 'dtop_sessions',
count(case when ws.device_type = 'mobile' then ws.website_session_id else null end) as 'mob_sessions'
from 
website_sessions ws
where ws.created_at between  '4/15/2012' and '6/9/2012'
and ws.utm_source = 'gsearch' 
and ws.utm_campaign = 'nonbrand'
group by datepart(ww,created_at) -- grouping by week
order by Min(cast(ws.created_at as date))

--Observation : Desktop sessions has increased due to bid changes made.