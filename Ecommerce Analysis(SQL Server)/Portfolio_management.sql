use mavenfuzzyfactory;

---Conversion rate analysis on the basis of various utm content 
select 
ws.utm_content,
count(distinct ws.website_session_id) as 'sessions',
count(distinct o.order_id) as 'orders',
round(cast(count(distinct o.order_id) as float)/cast(count(distinct ws.website_session_id) as float),4) as 'sess_to_ord_convrt_rate'
from website_sessions ws
LEFT JOIN orders o  on ws.website_session_id = o.website_session_id
where ws.created_at between ' 1/1/2014' and '2/1/2014'
group by ws.utm_content
order by sessions desc

/*With gsearch doing well and the site performing better,
we
launched a second paid search channel, bsearch , around
August 22.
Can you pull
weekly trended session volume since then and
compare to gsearch nonbrand so I can get a sense for how
important this will be for the business? 
(Asked on 29th November)*/


select
convert(date,min(ws.created_at)) as 'start_of_week',
count(case when utm_source = 'gsearch' then website_session_id else null end) as 'gsearch_sessions',
count(case when utm_source = 'bsearch' then website_session_id else null end) as 'bsearch_sessions'
from website_sessions ws
where ws.created_at between '08/22/2012' and '11/29/2012'
and utm_source in ('gsearch','bsearch') and utm_campaign = 'nonbrand'
group by datepart(week,ws.created_at)
order by convert(date,min(ws.created_at))

--Observation : Bsearch is getting approximately 1/3rd of gsearch sessions

----------------------------------------------------------------------------------------------------------------------------

/*I’d like to learn more about the
bsearch nonbrand campaign.
Could you please pull the percentage of traffic coming on
Mobile , and compare that to gsearch
Feel free to dig around and share anything else you find
interesting. Aggregate data since August 22nd is great, no
need to show trending at this point.*/


select
utm_source,
count(distinct website_session_id) as 'sessions',
count(case when device_type = 'mobile' then website_session_id else null end) as 'mobile_sessions',
round(cast(count(case when device_type = 'mobile' then website_session_id else null end) as float)/cast(count(distinct website_session_id) as float),4) as 'mobile_pct'
from website_sessions ws
where ws.created_at between '08/22/2012' and '11/30/2012'
and utm_source in ('gsearch','bsearch') and utm_campaign = 'nonbrand'
group by utm_source

--Observation : These channels seems to be very different from a device standpoint.

----------------------------------------------------------------------------------------------------------------------------
/*I’m wondering if bsearch nonbrand should have the same bids as gsearch. Could you pull nonbrand conversion rates
from session to order for gsearch and bsearch, and slice the data by device type .Please analyze data from
August 22 to September 18 ; 
we ran a special pre holiday campaign for gsearch starting on
September 19th , so the data after that isn’t fair*/


select
ws.device_type,
ws.utm_source,
count(distinct ws.website_session_id) as 'sessions',
count(distinct o.order_id)  as 'orders',
round(cast(count(distinct o.order_id) as float)/cast(count(distinct ws.website_session_id) as float),4)
as 'convr_rate'
from website_sessions ws
LEFT JOIN orders o on ws.website_session_id = o.website_session_id
where ws.created_at > '08/22/2012' 
and ws.created_at < '09/19/2012'
and ws.utm_campaign = 'nonbrand'
group by ws.device_type,ws.utm_source


--Observation : bsearch seems to be underperforming.

/*Based on your last analysis, we bid down bsearch nonbrand on December 2nd
Can you pull weekly session volume for gsearch and bsearch nonbrand, broken down by device, since November 4th
If you can include a comparison metric to show bsearch as a percent of gsearch for each device, that would be great too.
Request received on December 22, 2012*/



select
convert(date,min(created_at)) as 'week_start',
count(case when device_type = 'desktop' and utm_source = 'gsearch' then ws.website_session_id else null end )as 'g_dtop_sessions',
count(case when device_type = 'desktop' and utm_source = 'bsearch' then ws.website_session_id else null end )as 'b_dtop_sessions',
round(cast(count(case when device_type = 'desktop' and utm_source = 'bsearch' then ws.website_session_id else null end) as float)/cast(count(case when device_type = 'desktop' and utm_source = 'gsearch' then ws.website_session_id else null end ) as float),4) as 'b_pct_of_g_dtop',
count(case when device_type = 'mobile' and utm_source = 'gsearch' then ws.website_session_id else null end )as 'g_mob_sessions',
count(case when device_type = 'mobile' and utm_source = 'bsearch' then ws.website_session_id else null end )as 'b_mob_sessions',
round(cast(count(case when device_type = 'mobile' and utm_source = 'bsearch' then ws.website_session_id else null end ) as float)/cast(count(case when device_type = 'mobile' and utm_source = 'gsearch' then ws.website_session_id else null end ) as float),4) as 'b_pct_of_g_mob'
from website_sessions ws
where ws.created_at > '11/04/2012' 
and ws.created_at < '12/22/2012'
and ws.utm_campaign = 'nonbrand'
group by datepart(week,ws.created_at)
order by week_start

----Observation : the traffic for both bsearch & gsearch dropped after bidding down

-----------------------------------------------------------------------------------------------------------------------------

 /*A potential investor is asking if we’re building any
momentum with our brand or if we’ll need to keep relying
on paid traffic.
Could you
pull organic search, direct type in, and paid
brand search sessions by month , and show those sessions
as a % of paid search nonbrand*/

select
year(ws.created_At),
month(ws.created_At),
count(case when utm_campaign = 'nonbrand' then ws.website_session_id else null end) as 'nonbrand',
count(case when utm_campaign = 'brand' then ws.website_session_id else null end) as 'brand',
round(cast(count(case when utm_campaign = 'brand' then ws.website_session_id else null end) as float)/
cast(count(case when utm_campaign = 'nonbrand' then ws.website_session_id else null end) as float),4) as 'brand_pct_of_nonbrand',
count(case when utm_source = 'NULL' and http_referer = 'NULL' then ws.website_session_id else null end) as 'direct',
round(cast(count(case when utm_source = 'NULL' and http_referer = 'NULL' then ws.website_session_id else null end) as float)/
cast(count(case when utm_campaign = 'nonbrand' then ws.website_session_id else null end) as float),4) as 'direct_pct_of_nonbrand',
count(case when utm_source = 'NULL' and http_referer in ('https://www.gsearch.com','https://www.bsearch.com') then ws.website_session_id else null end) as 'organic',
round(cast(count(case when utm_source = 'NULL' and http_referer in ('https://www.gsearch.com','https://www.bsearch.com') then ws.website_session_id else null end) as float)/
cast(count(case when utm_campaign = 'nonbrand' then ws.website_session_id else null end) as float),4) as 'organic_pct_of_nonbrand'
from website_sessions ws
where Year(ws.created_at) = 2012
group by 
year(ws.created_At),
month(ws.created_At)
order by 
year(ws.created_At),
month(ws.created_At)

----Observation : Brand, Direct & Organic are growing as a part of our paid traffic