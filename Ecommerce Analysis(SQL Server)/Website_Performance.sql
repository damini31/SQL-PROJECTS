USE mavenfuzzyfactory;

Select distinct(pageview_url) from website_pageviews
Select  top 100 * from website_pageviews
order by website_session_id,website_pageview_id


--Q: most viewed website pages, ranked by session volume, before 9 June 2012.

select 
pageview_url,
count(Distinct website_session_id) as 'sessions'
from website_pageviews wp
where created_at < '6/9/2012'
group by pageview_url
order by sessions desc

--Observation : the homepage, the products page, and the Mr. Fuzzy page get the bulk of the traffic .

----------------------------------------------------------------------------------------------------------------------------------
--Q : pull all entry pages(where the user lands the first time and rank them on entry volume

with t1 as
(Select 
website_session_id,
Min(website_pageview_id) as 'first_pageview'
from 
website_pageviews
where 
created_at < '6/12/2012'
group by website_session_id)
select 
wp.pageview_url,
count(t1.first_pageview) as 'sessions_hitting_page'
from
t1
LEFT JOIN
website_pageviews wp on t1.first_pageview = wp.website_pageview_id
group by wp.pageview_url

--Observation :Maximum traffic comes in through the homepage.

-----------------------------------------------------------------------------------------------------------------------------------
--Q- LANDING PAGE ANALYSIS---

with 
first_pageviews as   ---First pageview I  and total pageviews per website session ID
(select 
website_session_id,
min(website_pageview_id) as 'first_pageview',
count(website_pageview_id) as 'total_pageviews'
from
website_pageviews
where created_at between '1/1/2014' and '2/1/2014'
group by website_session_id), 
f_url as --- ---First pageview URL, total pageviews and Bounced sessions analysis per website session ID 
(select 
fp.website_session_id,
wp.pageview_url as 'first_landing_page',
fp.total_pageviews,
case when fp.total_pageviews = 1 then 'Bounce' else 'Non-Bounce' end as 'Session_type'
from 
first_pageviews fp
LEFT JOIN
website_pageviews wp on fp.first_pageview = wp.website_pageview_id),
Bounced_data as --- Bounced Sessions and total sessions analysis per pageview url
(select 
first_landing_page,
count(distinct website_Session_id) as 'sessions',
sum(case when session_type = 'Bounce' then 1 else 0 end) as 'Bounce_Sessions'
--count(distinct website_Session_id)/sum(case when session_type = 'Bounce' then 1 else 0 end)
from f_url
group by first_landing_page)
Select 
first_landing_page,
sessions,
Bounce_Sessions,
Round(cast(Bounce_Sessions as float)/cast(sessions as float),3) as 'Bounce_Rate'
from Bounced_data 
where Bounce_Sessions > 0 
order by Bounce_Rate


-----------------------------------------------------------------------------------------------------------------------------------
/*Q- all of our traffic is landing on the homepage, Can you pull bounce rates for traffic landing on the
homepage, where created at < 14 June
*/



with first_pageviews as ---First pageview I  and total pageviews per website session ID
(select 
website_session_id,
min(website_pageview_id) 'first_pageview',
count(distinct website_pageview_id) 'total_pageviews'
from
website_pageviews
where created_at < '6/14/2012'
group by website_session_id),
f_url as --- ---First pageview URL, total pageviews and Bounced sessions analysis per website session ID 
(select 
fp.website_session_id,
wp.pageview_url as 'first_landing_page',
fp.total_pageviews,
case when fp.total_pageviews = 1 then 'Bounce' else 'Non-Bounce' end as 'Session_type'
from 
first_pageviews fp
LEFT JOIN
website_pageviews wp on fp.first_pageview = wp.website_pageview_id),
Bounced_data as --- Bounced Sessions and total sessions analysis per pageview url
(select 
first_landing_page,
count(distinct website_Session_id) as 'sessions',
sum(case when session_type = 'Bounce' then 1 else 0 end) as 'Bounce_Sessions'
--count(distinct website_Session_id)/sum(case when session_type = 'Bounce' then 1 else 0 end)
from f_url
group by first_landing_page)
Select 
sessions,
Bounce_Sessions,
Round(cast(Bounce_Sessions as float)/cast(sessions as float),3) as 'Bounce_Rate'
from Bounced_data 
where Bounce_Sessions > 0 and first_landing_page = '/home'
order by Bounce_Rate

--Observation : Bounce rate seems very high , especially for paid search, which should be high quality traffic.

/*Q : Based on your bounce rate analysis, we ran a new custom
landing page ( (/lander 1 ) in a 50/50 test against the
homepage ((/home for our gsearch nonbrand traffic.
Can you
pull bounce rates for the two groups so we can
evaluate the new page? Make sure to just look at the time
period where /lander 1 was getting traffic , so that it is a fair
comparison.*/


with first_pageviews as ---First pageview I  and total pageviews per website session ID
(select 
wp.website_session_id,
min(wp.website_pageview_id) 'first_pageview',
count(distinct wp.website_pageview_id) as 'total_pageviews'
from
website_pageviews wp
INNER JOIN
website_sessions ws on wp.website_session_id = ws.website_session_id
                          and ws.utm_source = 'gsearch' 
						  and ws.utm_campaign = 'nonbrand'
						  and wp.website_pageview_id > 23504 --min pageview ID
						  and ws.created_at <'7/28/2012'
group by wp.website_session_id),
f_url as --- ---First pageview URL, total pageviews and Bounced sessions analysis per website session ID 
(select 
fp.website_session_id,
wp.pageview_url as 'first_landing_page',
fp.total_pageviews,
case when fp.total_pageviews = 1 then 'Bounce' else 'Non-Bounce' end as 'Session_type'
from 
first_pageviews fp
LEFT JOIN
website_pageviews wp on fp.first_pageview = wp.website_pageview_id),
Bounced_data as --- Bounced Sessions and total sessions analysis per pageview url
(select 
first_landing_page,
count(distinct website_Session_id) as 'sessions',
sum(case when session_type = 'Bounce' then 1 else 0 end) as 'Bounce_Sessions'
--count(distinct website_Session_id)/sum(case when session_type = 'Bounce' then 1 else 0 end)
from f_url
group by first_landing_page)
Select 
first_landing_page,
sessions,
Bounce_Sessions,
Round(cast(Bounce_Sessions as float)/cast(sessions as float),3) as 'Bounce_Rate'
from Bounced_data 
where Bounce_Sessions > 0 and first_landing_page in ('/home','/lander-1')
order by Bounce_Rate

----Observation : /lander-1 has lower bounce rates as compared to /home

----------------------------------------------------------------------------------------------------------------------------------
drop table #first_pageview_data

--created #first_pageview_data temp table
with t1 as
(select
 wp.website_session_id,
 min(wp.website_pageview_id) as 'first_pageview_ID',
 count(wp.website_pageview_id) as 'total_pageviews'
 from website_pageviews wp
 LEFT JOIN
 website_sessions ws on wp.website_session_id = ws.website_session_id
 where wp.created_at >= '6/1/2012'
       and wp.created_at < '8/31/2012'
	   and ws.utm_source = 'gsearch'
	   and ws.utm_campaign = 'nonbrand'
 group by wp.website_session_id)
 select 
 t1.website_session_id,
 wp1.pageview_url,
 wp1.created_at,
 t1.total_pageviews,
 case when t1.total_pageviews = 1 then 'Bounce' else 'Non-Bounce' end as 'Session_Type'
 into #first_pageview_data
 from 
 t1
 INNER JOIN
 website_pageviews wp1 on t1.first_pageview_ID = wp1.website_pageview_id

 
select
cast(MIN(created_at) as date) as 'start_of_week',
round(cast(sum(case when Session_Type = 'Bounce' then 1 else 0 end) as float)/cast(count(distinct website_session_id) as float),3) as 'Bounce_rate',
sum(case when pageview_url = '/home' then 1 else 0 end) as 'home_sessions',
sum(case when pageview_url = '/lander-1' then 1 else 0 end) as 'lander_sessions'
from #first_pageview_data
group by datepart(ww,created_at)
order by start_of_week

/*Observation : Looks like both pages were getting traffic for a while, and then we fully switched over to the custom lander , as.And it looks like our overall bounce rate has come down over time */

----------------------------------------------------------------------------------------------------------------------------

/*Q - I’d like to understand where we lose our gsearch visitors between the new /lander 1 page and placing an order. Can
you build us a full conversion funnel, analyzing how many
customers make it to each step .USe  data since August 5th to Sep 5th*/


----conversion funnel-----
select
count(distinct website_Session_id) as sessions,
count(case when products_page = 1 then website_session_id else null end) as to_products,
count(case when mrfuzzy_page = 1 then website_session_id else null end) as to_mrfuzzypage,
count(case when cart_page = 1 then website_session_id else null end) as to_cart,
count(case when shipping_page = 1 then website_session_id else null end) as to_shipping,
count(case when billing_page = 1 then website_session_id else null end) as to_billing,
count(case when thankyou_page = 1 then website_session_id else null end) as to_thankyou
from
(select 
website_sessions.website_session_id,
case when pageview_url = '/products' then 1 else 0 end as products_page,
case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when pageview_url = '/cart' then 1 else 0 end as cart_page,
case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
case when pageview_url = '/billing' then 1 else 0 end as billing_page,
case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from 
website_pageviews
LEFT JOIN
website_sessions on website_sessions.website_session_id = website_pageviews.website_session_id
where 
website_sessions.created_at between '8/5/2012' and '9/5/2012'
and website_sessions.utm_source = 'gsearch'
and website_sessions.utm_campaign = 'nonbrand') as session_Details

----Clickrates-----
with t1
as
(select
count(distinct website_Session_id) as sessions,
count(case when products_page = 1 then website_session_id else null end) as to_products,
count(case when mrfuzzy_page = 1 then website_session_id else null end) as to_mrfuzzypage,
count(case when cart_page = 1 then website_session_id else null end) as to_cart,
count(case when shipping_page = 1 then website_session_id else null end) as to_shipping,
count(case when billing_page = 1 then website_session_id else null end) as to_billing,
count(case when thankyou_page = 1 then website_session_id else null end) as to_thankyou
from
(select 
website_sessions.website_session_id,
case when pageview_url = '/products' then 1 else 0 end as products_page,
case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when pageview_url = '/cart' then 1 else 0 end as cart_page,
case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
case when pageview_url = '/billing' then 1 else 0 end as billing_page,
case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from 
website_pageviews
LEFT JOIN
website_sessions on website_sessions.website_session_id = website_pageviews.website_session_id
where 
website_sessions.created_at between '8/5/2012' and '9/5/2012'
and website_sessions.utm_source = 'gsearch'
and website_sessions.utm_campaign = 'nonbrand') as session_Details)
select
Round(cast(t1.to_products as float)/cast(t1.sessions as float),3) as lander1_clk_rate,
Round(cast(t1.to_mrfuzzypage as float)/cast(t1.to_products as float),3) as products_clk_rate,
Round(cast(t1.to_cart as float)/cast(t1.to_mrfuzzypage  as float),3) as mrfuzzy_clk_rate,
Round(cast(t1.to_shipping as float)/cast(t1.to_cart as float),3) as cart_clk_rate,
Round(cast(t1.to_billing as float)/cast(t1.to_shipping  as float),3) as shipping_clk_rate,
Round(cast(t1.to_thankyou as float)/cast(t1.to_billing  as float),3) as billing_clk_rate
from t1



/*Q:We tested an updated billing page based on your funnel analysis. Can you take a look and see whether /billing 2 is
doing any better than the original /billing page? We’re wondering what % of sessions on those pages end up placing an order .FYI we ran this test for all traffic, not just for our search visitors */


with t1 as
(select
wp.website_session_id,
wp.pageview_url,
o.order_id
from 
website_pageviews wp
LEFT JOIN
orders o on wp.website_session_id = o.website_session_id
where 
wp.website_pageview_id >= (select min(website_pageview_id) from website_pageviews where pageview_url = '/billing-2')
and wp.created_at < '11/10/2012'
and wp.pageview_url in ('/billing','/billing-2'))
select 
t1.pageview_url as 'billing_version_seen',
count(t1.website_session_id) as 'sessions',
sum(case when t1.order_id is not null then 1 else 0 end) as 'orders',
round(cast(sum(case when t1.order_id is not null then 1 else 0 end) as float)/cast(count(t1.website_session_id) as float),4) as 'billing_to_order_rt'
from t1
group by t1.pageview_url
order by billing_to_order_rt

--Observation: New Version of billing page is doing much better job in converting customers
