select * from global_superstore_orders;

create materialized view global_superstore_orders_metrics as
select 
	count(*) as total_records,
	sum("Sales") as total_sales,
	sum("Profit") as overall_profit,
	sum(case when "Profit_Or_Loss" = 'Profit' then "Profit" else 0 end) as profit_only,
	sum(case when "Profit_Or_Loss" = 'Loss' then "Profit" else 0 end) as loss_only,
	ROUND(SUM(CASE WHEN "Profit_Or_Loss" = 'Profit' THEN "Profit" ELSE 0 END) / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin,
  	ROUND(SUM(CASE WHEN "Profit_Or_Loss" = 'Loss' THEN "Profit" ELSE 0 END) / NULLIF(SUM("Sales"), 0) * 100, 2) AS loss_margin,
  	ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100, 2) AS net_margin,
  	SUM("Sales") / NULLIF(COUNT(DISTINCT "Order ID"), 0) AS average_order_value,
  	SUM("Profit") / NULLIF(COUNT(DISTINCT "Order ID"), 0) AS profit_per_order,
  	COUNT(DISTINCT "Order ID") AS total_distinct_orders
FROM global_superstore_orders;

select * from global_superstore_orders_metrics;

DO $$
DECLARE
  rec global_superstore_orders_metrics%ROWTYPE;
BEGIN
  SELECT * INTO rec
  FROM global_superstore_orders_metrics;

  RAISE NOTICE E'
📊 Metrics Report:
Total Records        : %
Total Sales          : %
Overall Profit       : %
Profit Only          : %
Loss Only            : %
Profit Margin        : %
Loss Margin          : %
Net Margin           : %
Average Order Value  : %
Profit per Order     : %',
    rec.total_records,
    rec.total_sales,
    rec.overall_profit,
    rec.profit_only,
    rec.loss_only,
    rec.profit_margin::text || '%',
    rec.loss_margin::text|| '%',
    rec.net_margin::text || '%',
    rec.average_order_value,
    rec.profit_per_order;

END
$$;

-- Total profit and total sales by region
select "Region",
sum(case when "Profit_Or_Loss" = 'Profit' then "Profit" else 0 end) as total_profit,
sum("Sales") as total_sales
from global_superstore_orders
group by "Region"
order by total_profit desc;

-- Total profit and total sales by year
select extract(year from "Order Date") as "Year",
sum(case when "Profit_Or_Loss" = 'Profit' then "Profit" else 0 end) as total_profit,
sum("Sales") as total_sales
from global_superstore_orders
group by "Year"
order by total_profit desc;

-- Total sales by segment
select "Segment",
sum("Sales") as total_sales
from global_superstore_orders
group by "Segment";
	
-- Total sales and total profit by discount band
select 
case 
	when "Discount" <= 0.05 then '0-5%'
	when "Discount" <= 0.10 then '5-10%'
	when "Discount" <= 0.15 then '10-15%'
	when "Discount" <= 0.20 then '15-20%'
	else '20-' || round((select max("Discount") from global_superstore_orders) * 100, 0) || '%'
	end as discount_band,
	sum("Sales") as total_sales,
	sum("Profit") as total_profit
	from global_superstore_orders
	group by discount_band
	order by total_profit desc;

-- Top selling product
select "Product Name", sum("Sales") as total_sales
from global_superstore_orders
group by "Product Name"
order by total_sales desc
limit 1;

-- Average time for each ship mode by region
select "Region",
	coalesce(round(avg(case when "Ship Mode" = 'First Class' then "Ship Date" - "Order Date" end), 2), 0) as first_class_avg,
	coalesce(round(avg(case when "Ship Mode" = 'Same Day Class' then "Ship Date" - "Order Date" end), 2), 0) as same_day_avg,
	coalesce(round(avg(case when "Ship Mode" = 'Second Class' then "Ship Date" - "Order Date" end), 2), 0) as second_class_avg,
	coalesce(round(avg(case when "Ship Mode" = 'Standard Class' then "Ship Date" - "Order Date" end), 2), 0) as standard_class_avg
from global_superstore_orders
group by "Region"
order by "Region";