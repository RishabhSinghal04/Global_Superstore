# Global Superstore

## Table of Contents
- [Introduction](#Introduction)
- [Problem Statement](#Problem-Statement)
- [Project Overview](#Project-Overview)
- [Dataset](#Dataset)
- [Data Cleaning and Preparation](#Data-Cleaning-and-Preparation)
- [Data Model](#Data-Model)
- [Report Overview](#Report-Overview)
- [Results](#Results)
- [Key Features](#Key-Features)
- [Tools & Technologies](#Tools-and-Technologies)
- [File Structure](#File-Structure)
- [Getting Started](#Getting-Started)

## Introduction
An end-to-end analytics solution built on the Global Superstore dataset. Explore data cleaning, a star schema model, key DAX measures and interactive report pages.

![Report Overview](images/report_pages.png "Pages of Report")


## Problem Statement
The Global Superstore analytics team requires an interactive Power BI report that empowers stakeholders to:

- Monitor high-level business health through key metrics and trend analyses  
- Examine product and order level insights via tabular and matrix views, including top performers and shipping efficiency.  
- Visualize global sales distribution by country, market, and time slices with Year & Month slicers.  
- Navigate a hierarchical breakdown of sales from Market → Region → Country → City → Segment using drill-through filters.


## Project Overview

This repository delivers a complete Power BI solution, covering:

1. Data Ingestion & Cleaning  
   - Load the 2016 Global Superstore Excel dataset.  
   - Remove or correct invalid records, standardize geography, flag profit/loss.  

2. Star-Schema Data Modeling  
   - Build fact and dimension tables (Sales, Customer, Product, Date, Order).  

3. DAX Measure Development  
   - Define core KPIs: Total Sales, Profit, Loss, Profit Margin, Average Order Value, Return Rate.  

4. PostgreSQL Analytics & Metrics Materialization  
   - Create a materialized view `global_superstore_orders_metrics` summarizing total records, sales, profit breakdowns, margins, average order value, and profit per order.  
   - Use a PL/pgSQL `DO` block with `RAISE NOTICE` to print a formatted metrics report.  
   - Run queries for region- and year-level profit/sales, segment sales, discount-band analysis, top-selling product, and average ship times by region & ship mode.  

5. Interactive Power BI Report  
   - Page 1: Executive Dashboard with KPI cards, trend lines, segment share, discount impact.  
   - Page 2: Table & Matrix showing top products and average ship times by region/mode.  
   - Page 3: Geographic Map of sales volumes with Year & Month slicers.
   - Page 4: Flow Chart drill-down across Market → Region → Country → City → Segment, enriched with drill-through filters. 


## Dataset

- File: **global_superstore_2016.xlsx**  
- Source: https://powerbidocs.com/wp-content/uploads/2021/01/global_superstore_2016.xlsx  
- Primary sheet: **Orders** (51,290 rows; order, customer, product and shipment details)


## Data Cleaning and Preparation

- Removed **Postal Code** (81% missing).  
- Standardized **Country** name (“Hong Kong” → “China”).  
- Created **Profit_Or_Loss** (Profit / Loss / Neutral) for each line.
- Built `City_State_Mapping` lookup to correct city–state mismatches.  
    - Microsoft Copilot assisted in identifying incorrect city–state combinations. 

![Issues Log](images/issues/issues_log.png "Summary of data quality issues in Orders sheet")


## Data Model

| Table          | Grain                          |
| -------------- | ------------------------------ |
| **Fact_Sales**   | One row per order–product line |
| **Dim_Customer** | One row per Customer ID         |
| **Dim_Product**  | One row per Product ID          |
| **Dim_Date**     | One row per calendar date      |

![Data Model View](images/data_model/Model_View.png "Power BI data model showing tables and relationships")


## Report Overview

### Page 1 – Executive Summary

![Dashboard – Page 1](images/report/executive_summary.png "Page 1: Dashboard showing key metrics and visualizations")

- KPI cards: Total Sales, Total Profit, Profit Margin, Loss Margin, Net Margin, Average Order Value and Profit per Order  
- Sales & Profit by Region
- Year-over-year trend (2012–2015)  
- Segment share breakdown (Consumer, Corporate, Home Office)  
- Discount band impact on Sales vs. Profit  


### Page 2 – Quarterly Insights

 ![Table & Matrix – Page 2](images/report/quarterly_insights.png "Page 2: Table & Matrix report showing top selling products and average ship time")


### Page 3 – Regional Profit and Loss

![Map – Page 3](images/report/regional_profit_and_loss.png "Page 3: Map showing total sales by country and market")


### Page 4 – Sales Breakdown

![Flow Chart – Page 4](images/report/sales_breakdown.png "Page 4: Flow Chart breaking down total sales by market, region, country, city, and segment")

- Total Sales: $12,642,501.91  
- Drill-down from Market → Region → Country → City → Segment  
- Year and Month slicers (Year (2012–2016), Month (January-December))


### Page 5 – Global Sales Overview

![Flow Chart – Page 4](images/report/global_sales_overview.png "Page 4: Flow Chart breaking down total sales by market, region, country, city, and segment")

- World map with circle markers sized by Sales  
- Year and Month slicers (2012–2016, January–December)  
- Market color legend (Africa, Asia Pacific, Europe, LATAM, USCA)  


### Page 6 – Performance Summary

![Flow Chart – Page 4](images/report/performance_summary.png "Page 4: Flow Chart breaking down total sales by market, region, country, city, and segment")

- Top 20 Selling Products 
- Average ship time (days) matrix by Region × Ship Mode 


## Results

- **Year-over-Year Growth:**  
  Total sales increased from **$2,677,438.69** in **2013** to **$3,405,746.45** in **2014**, marking the **highest year-over-year growth** in the **2012–2015** period at **27.20%**.  

- **Regional Performance:**  
  - **Western Europe** recorded the **highest sales** at **$1,731,929.67** and the **highest total profit** at **$314,970.32**, with a **net profit and loss** figure of **$218,433.51**, leading all regions.  
  - By market, **Asia Pacific** achieved the **highest total sales** at **$4,042,658.27**, followed by **Europe** with **$3,287,336.23**.  

- **Customer Segments:**  
  The **Consumer** segment dominated sales with **$6,507,949.42** (**51.48%**), followed by **Corporate** (**30.25%**) and **Home Office** (**18.27%**).  

- **Quarterly Sales Trends:**  
  Sales **consistently peaked** in the **final month** of each quarter across most years.  

- **Discount Band Insights:**  
  - The **0–5% discount band** generated the **highest sales** (**$7,253,806.57**) and the **highest profit and loss figure** (**$1,828,671.85**).  
  - The **20–85% discount band** resulted in a **net loss** of **$814,682.09**.  


## Key Features


## Tools and Technologies
- Power BI Desktop
- Microsoft Excel 2021
- PostgreSQL
- Microsoft Copilot


## File Structure

```
├── data/
│   ├── csv/
│   │   └── cleaned_global_superstore_2016.csv
│   ├── cleaned_global_superstore_2016.xlsx
│   └── global_superstore_2016.xlsx
├── images/
│   ├── data_model/
│   │   └── Model_View.png
│   ├── issues/
│   │   └── issues_log.png
│   ├── report/
│   │   ├── Dashboard.png
│   │   ├── Table_and_Matrix.png
│   │   ├── Map.png
│   │   └── Flow_Chart.png
│   └── report_pages.png
├── report/
│   └── global_superstore_report.pbix
├── sql/
│   └── global_superstore_analysis.sql
│   └── table.sql
└── README.md
```


## Getting Started

1. Clone or download this repository.
2. Place global_superstore_2016.xlsx in the project root.
3. Open global_superstore_report.pbix in Power BI Desktop (v2.78+).
4. In Power BI Desktop, go to Transform data → Data source settings, and point the Excel data source to data/cleaned_global_superstore_2016.xlsx.
5. In the Navigator window, select the Cleaned_Orders and Returns sheets, then click Load.
6. Click Refresh to load and apply all preconfigured Power Query transforms.
7. Explore the report:
    - Navigate dashboard pages
    - Use slicers to filter by region, category, time period, etc.
    - Drill through on any chart to see transaction-level details