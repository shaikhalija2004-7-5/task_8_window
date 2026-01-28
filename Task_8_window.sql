create database superstores_sales;
use superstores_sales;

select * from retail_sales_dataset;


-- qunatity purchae by gender wise or product wise
select
    Gender,sum(quantity) as Total
from retail_sales_dataset
group by gender;

-- Product Category wise total
select
    `Product Category`,sum(`Total Amount`) as Total
from retail_sales_dataset
group by `Product Category`;

-- ranking customer with theor price amount
select *,
row_number() over(partition by `product category` order by Date ) as Ranks
from retail_sales_dataset;

-- running sales
select * ,
sum(Quantity)
	over (order by date rows between unbounded preceding and current row) as runing_total
from retail_sales_dataset
order by `Transaction ID`;


---------- Month over Month Growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(Date, '%Y-%m') AS month,
        SUM(`Total Amount`) AS monthly_total
    FROM retail_sales_dataset
    GROUP BY DATE_FORMAT(Date, '%Y-%m')
)
SELECT
    month,
    monthly_total,
    LAG(monthly_total) OVER (ORDER BY month) AS prev_month_total,
    monthly_total 
      - LAG(monthly_total) OVER (ORDER BY month) AS mom_growth,
    ROUND(
        (monthly_total - LAG(monthly_total) OVER (ORDER BY month))
        / LAG(monthly_total) OVER (ORDER BY month) * 100, 2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY month;




-- top 3 products per category

with top_3 as (
select *,
dense_rank() over (partition by `product category` order by quantity desc) as Tops
from retail_sales_dataset)
select * from top_3 where tops<=3;