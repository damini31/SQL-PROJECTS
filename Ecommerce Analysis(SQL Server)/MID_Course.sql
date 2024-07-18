 

/* Q : 
Gsearch seems to be the biggest driver of our business. Could you pull monthly trends for gsearch sessions
and orders so that we can showcase the growth there? 
*/

select 
Year(ws.created_at) as 'Year',
Month(ws.created_at) as 'Month',
count(distinct ws.website_session_id) as 'sessions',
count(distinct o.order_id) as 'orders'
from 
website_sessions ws
LEFT JOIN
orders o on ws.website_session_id = o.website_session_id
where ws.utm_source = 'gsearch'
group by Year(ws.created_at),Month(ws.created_at)
order by Year(ws.created_at),Month(ws.created_at)


/*
Next, it would be great to see a similar monthly trend for Gsearch, but this time
splitting out nonbrand and
brand campaigns separately . I am wondering if brand is picking up at all. If so, this is a good story to tell.
*/

select 
Year(ws.created_at) as 'Year',
Month(ws.created_at) as 'Month',
count(distinct case when ws.utm_campaign = 'nonbrand' then ws.website_session_id else null end) as 'nonbrand_Sessions',
count(distinct case when ws.utm_campaign = 'nonbrand' then o.order_id else null end) as 'nonbrand_orders',
count(distinct case when ws.utm_campaign = 'brand' then ws.website_session_id else null  end) as 'brand_Sessions',
count(distinct case when ws.utm_campaign = 'brand' then o.order_id else null  end) as 'brand_orders'
from 
website_sessions ws
LEFT JOIN
orders o on ws.website_session_id = o.website_session_id
where ws.utm_source = 'gsearch'
group by Year(ws.created_at),Month(ws.created_at)
order by Year(ws.created_at),Month(ws.created_at)


/*While we’re on Gsearch, could you dive into nonbrand, and pull
monthly sessions and orders split by device
type? I want to flex our analytical muscles a little and show the board we really know our traffic sources.*/

select 
Year(ws.created_at) as 'Year',
Month(ws.created_at) as 'Month',
count(distinct case when ws.device_type = 'mobile' then ws.website_session_id else null end) as 'mobile_Sessions',
count(distinct case when ws.device_type = 'mobile' then o.order_id else null end) as 'mobile_orders',
count(distinct case when ws.device_type = 'desktop' then ws.website_session_id else null  end) as 'desktop_Sessions',
count(distinct case when ws.device_type = 'desktop' then o.order_id else null  end) as 'desktop_orders'
from 
website_sessions ws
LEFT JOIN
orders o on ws.website_session_id = o.website_session_id
where ws.utm_source = 'gsearch'
group by Year(ws.created_at),Month(ws.created_at)
order by Year(ws.created_at),Month(ws.created_at)

/*I’m worried that one of our more pessimistic board members may be concerned about the large % of traffic from
Gsearch. Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?*/

select distinct(utm_source) from website_sessions

select 
Year(ws.created_at) as 'Year',
Month(ws.created_at) as 'Month',
count(case when utm_source = 'gsearch' then ws.website_session_id else null end) as 'gsearch_sessions',
count(case when utm_source = 'bsearch' then ws.website_session_id else null end) as 'bsearch_sessions',
count(case when utm_source = 'socialbook' then ws.website_session_id else null end) as 'socialbook_sessions',
count(case when utm_source = 'NULL' and http_referer is not null then ws.website_session_id else null end) as 'organic_search_sessions',
count(case when utm_source = 'NULL' and http_referer = 'NULL' then ws.website_session_id else null end) as 'direct_type_sessions'
from 
website_sessions ws
group by Year(ws.created_at),Month(ws.created_at)
order by Year(ws.created_at),Month(ws.created_at)


/*I’d like to tell the story of our website performance improvements over the course of the first 8 months.
Could you pull session to order conversion rates, by month ?*/

select 
Year(ws.created_at) as 'Year',
Month(ws.created_at) as 'Month',
count(distinct ws.website_session_id) as 'sessions',
count(distinct o.order_id) as 'orders',
round(cast(count(distinct o.order_id) as float)/cast(count(distinct ws.website_session_id) as float),3) as sess_to_order_rt
from 
website_sessions ws
LEFT JOIN
orders o on ws.website_session_id = o.website_session_id
where ws.created_at < '11/1/2012'
group by Year(ws.created_at),Month(ws.created_at)
order by Year(ws.created_at),Month(ws.created_at)


/*For the gsearch lander test, please
estimate the revenue that test earned us Hint: Look at the increase in CVR
from the test (Jun 19 Jul 28), and use nonbrand sessions and revenue since then to calculate incremental value)*/


WITH NB_FP as
(select t1.website_session_id,website_pageviews.pageview_url from ---Website_session with first pageview_url
(select 
wp.website_session_id,
min(wp.website_pageview_id) as first_pg
from 
website_pageviews wp
INNER JOIN
website_sessions ws on wp.website_session_id = ws.website_session_id
where ws.utm_campaign = 'nonbrand'
and ws.utm_source = 'gsearch'
and ws.created_at < '7/28/2012'
and wp.website_pageview_id >= (select min(website_pageview_id) from website_pageviews where pageview_url = '/lander-1')
group by wp.website_session_id) as t1
INNER JOIN website_pageviews on website_pageviews.website_pageview_id = t1.first_pg 
where website_pageviews.pageview_url in ('/home','/lander-1')),
sess_o as 
(select NB_FP.*,o.order_id
from NB_FP
LEFT JOIN
orders o on NB_FP.website_session_id = o.website_session_id)
select
sess_o.pageview_url,
count(distinct sess_o.website_Session_id) as 'sessions',
count(distinct sess_o.order_id) as 'orders',
round(cast(count(distinct sess_o.order_id) as float)/cast(count(distinct sess_o.website_Session_id) as float),3) as conv_rate
from sess_o
group by 
sess_o.pageview_url

--0.032 for /home and 0.041 for lander-1
--0.009 additional orders per session increase from /home to /lander-1

select 
max(ws.website_Session_id) as most_recent -- max_session_id to see when did the traffic started to flow to lander-1
from website_sessions ws
LEFT JOIN
website_pageviews wp
on wp.website_session_id = ws.website_session_id
where ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
and wp.pageview_url = '/home'

--number of sessions after traffic got rerouted
select count(ws.website_Session_id)
from website_sessions ws
where ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
and website_session_id > 17145
and created_at < '11/27/2012'

--22,792 sessions 
--0.009 additional orders per session
--22792 * 0.009 = 202 more orders since the 7/29, which is 50 extra orders per month

/*For the landing page test you analyzed previously, it would be great to show full conversion funnel from each
of the two pages to orders . You can use the same time period you analyzed last time (Jun 19 Jul 28).*/

--Conversion_numbers
select 
case when saw_homepage = 1 then 'saw_homepage' 
     when saw_lander_page = 1 then 'saw_lander'
	 else 'incorrect logic' end as 'segment',
count(distinct website_Session_id) as 'sessions',
count(case when saw_product_page = 1 then website_session_id else null end) as 'to_products',
count(case when saw_mrfuzzy_page = 1 then website_session_id else null end) as 'to_mrfuzzy',
count(case when saw_carts_page = 1 then website_session_id else null end) as 'to_carts',
count(case when saw_shipping_page = 1 then website_session_id else null end) as 'to_shipping',
count(case when saw_billing = 1 then website_session_id else null end) as 'to_billing',
count(case when saw_thankyou = 1 then website_session_id else null end) as 'to_saw_thankyou'
from
(select 
website_session_id,
max(homepage) as 'saw_homepage',
max(landerpage) as 'saw_lander_page',
max(products_page) as 'saw_product_page',
max(mrfuzzy_page) as 'saw_mrfuzzy_page',
max(carts_page) as 'saw_carts_page',
max(shipping_page) as 'saw_shipping_page',
max(billing_page) as 'saw_billing',
max(thankyou_page) as 'saw_thankyou'
from
(select 
ws.website_session_id,
wp.pageview_url,
case when wp.pageview_url = '/home' then 1 else 0 end as homepage,
case when wp.pageview_url = '/lander-1' then 1 else 0 end as landerpage,
case when wp.pageview_url = '/products' then 1 else 0 end as products_page,
case when wp.pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when wp.pageview_url = '/cart' then 1 else 0 end as carts_page,
case when wp.pageview_url = '/shipping' then 1 else 0 end as shipping_page,
case when wp.pageview_url = '/billing' then 1 else 0 end as billing_page,
case when wp.pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from 
website_sessions ws
LEFT JOIN
website_pageviews wp on ws.website_session_id = wp.website_session_id
where ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
and ws.created_at < '07/28/2012'
and ws.created_at > '06/19/2012') as session_Detail
group by website_session_id) as page_visit 
group by 
case when saw_homepage = 1 then 'saw_homepage' 
     when saw_lander_page = 1 then 'saw_lander'
	 else 'incorrect logic' end 


---Clickrate analysis


select
segment,
round(cast(to_products as float)/cast(sessions as float),3) as 'products_clk_rate',
round(cast(to_mrfuzzy as float)/cast(to_products as float),3) as 'mrfuzzy_clk_rate',
round(cast(to_carts as float)/cast(to_mrfuzzy as float),3) as 'carts_clk_rate',
round(cast(to_shipping as float)/cast(to_carts as float),3) as 'shipping_clk_rate',
round(cast(to_billing as float)/cast(to_shipping as float),3) as 'billing_clk_rate',
round(cast(to_saw_thankyou as float)/cast(to_billing as float),3) as 'thankyou_clk_rate'
from
(select 
case when saw_homepage = 1 then 'saw_homepage' 
     when saw_lander_page = 1 then 'saw_lander'
	 else 'incorrect logic' end as 'segment',
count(distinct website_Session_id) as 'sessions',
count(case when saw_product_page = 1 then website_session_id else null end) as 'to_products',
count(case when saw_mrfuzzy_page = 1 then website_session_id else null end) as 'to_mrfuzzy',
count(case when saw_carts_page = 1 then website_session_id else null end) as 'to_carts',
count(case when saw_shipping_page = 1 then website_session_id else null end) as 'to_shipping',
count(case when saw_billing = 1 then website_session_id else null end) as 'to_billing',
count(case when saw_thankyou = 1 then website_session_id else null end) as 'to_saw_thankyou'
from
(select 
website_session_id,
max(homepage) as 'saw_homepage',
max(landerpage) as 'saw_lander_page',
max(products_page) as 'saw_product_page',
max(mrfuzzy_page) as 'saw_mrfuzzy_page',
max(carts_page) as 'saw_carts_page',
max(shipping_page) as 'saw_shipping_page',
max(billing_page) as 'saw_billing',
max(thankyou_page) as 'saw_thankyou'
from
(select 
ws.website_session_id,
wp.pageview_url,
case when wp.pageview_url = '/home' then 1 else 0 end as homepage,
case when wp.pageview_url = '/lander-1' then 1 else 0 end as landerpage,
case when wp.pageview_url = '/products' then 1 else 0 end as products_page,
case when wp.pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
case when wp.pageview_url = '/cart' then 1 else 0 end as carts_page,
case when wp.pageview_url = '/shipping' then 1 else 0 end as shipping_page,
case when wp.pageview_url = '/billing' then 1 else 0 end as billing_page,
case when wp.pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from 
website_sessions ws
LEFT JOIN
website_pageviews wp on ws.website_session_id = wp.website_session_id
where ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
and ws.created_at < '07/28/2012'
and ws.created_at > '06/19/2012') as session_Detail
group by website_session_id) as page_visit 
group by 
case when saw_homepage = 1 then 'saw_homepage' 
     when saw_lander_page = 1 then 'saw_lander'
	 else 'incorrect logic' end) as final


/*I’d love for you to
quantify the impact of our billing test , as well. Please analyze the lift generated from the test
(Sep 10 Nov 10), in terms of revenue per billing page session , and then pull the number of billing page sessions
for the past month to understand monthly impact.*/


select
billing_page,
count(distinct website_session_id) as 'sessions',
format(round(cast(sum(price_usd) as float)/ cast(count(distinct website_session_id) as float),3),'C') as 'revenue_per_billing'
from
(select
wp.website_session_id,
wp.pageview_url as 'billing_page',
o.order_id,
o.price_usd
from 
website_pageviews wp
LEFT JOIN
orders o on wp.website_session_id = o.website_session_id
where wp.created_at < '11/10/2012'
and wp.created_at > '09/10/2012'
and wp.pageview_url in  ('/billing','/billing-2')) t1
group by billing_page

----LIFT = $8.51 from the old billing version

select 
count(website_Session_id) as 'billing_sessions'
from website_pageviews
where website_pageviews.pageview_url in ('/billing','/billing-2')
and created_at between '10/27/2012' and '11/27/2012' -- last month

--1194 billing sessions is last month
--LIFT = $8.51 from the old billing version
----Revenue earned by Billing test :  1194 * $8.51 = $10,160 over last month