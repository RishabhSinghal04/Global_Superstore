drop table if exists global_superstore_orders;
create table global_superstore_orders (
	"Row ID" varchar(10),
	"Order ID" text,
	"Order Date" date,
	"Ship Date" date,
	"Ship Mode" varchar(50),
	"Customer ID" text,
	"Customer Name" text,
	"Segment" varchar(50),
	"City" varchar(50),
	"Cleaned_State" varchar(50),
	"Country" varchar(50),
	"Cleaned_Country" varchar(50),
	"Region" varchar(50),
	"Market" varchar(50),
	"Product ID" text,
	"Category" varchar(50),
	"Sub-Category" varchar(50),
	"Product Name" text,
	"Sales" numeric,
	"Quantity" smallint,
	"Discount" numeric,
	"Profit" numeric,
	"Shipping Cost" numeric,
	"Order Priority" varchar(50),
	"Profit_Or_Loss" varchar(50)
);

COPY global_superstore_orders 
FROM 'D:\Projects\Global_Superstore\data\csv\cleaned_global_superstore_2016.csv' 
WITH (FORMAT csv, HEADER true);

select * from global_superstore_orders;