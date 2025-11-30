WITH dim_date__genarate AS (
   
  SELECT
    *
  FROM
    UNNEST(GENERATE_DATE_ARRAY('2014-01-01', '2050-01-01', INTERVAL 1 DAY)) AS Date
)
, dim_date__irich AS (
  SELECT
      *
      , FORMAT_DATE('%A', Date) AS day_of_week
      , FORMAT_DATE('%a', Date) AS day_of_week_short
      , DATE_TRUNC(Date, Month) AS year_month
      , FORMAT_DATE('%B', Date) as month_name
      , DATE_TRUNC(Date, Year) AS year
      , EXTRACT(YEAR FROM Date) AS year_number
  FROM dim_date__genarate
)
select
*
, CASE 
    when day_of_week_short In('Mon', 'Tue' , 'Wed' , 'Thu' , 'Fri')  then 'Weekday'
    when day_of_week_short In( 'Sat' , 'Sun' ) then 'Weekend'
  else 'Invalid' end as is_weekday_or_weekend
from dim_date__irich