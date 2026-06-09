create database customer_churn;

use customer_churn;

select * 
from customers
limit 5;

-- Q1. What is the overall churn rate?

select 
round(sum(case when Churn = 'Yes' then 1 else 0 end) * 100/count(*),2) as churn_rate
from customers;

-- Q2. Which contract type has the most churn?

select 
Contract , count(*) as total_customers , 
sum(case when Churn = 'Yes' then  1 else 0 end)  as churned_customers
from customers
group by Contract;

-- Q5. What is the churn rate by contract type?

select 
Contract ,
round(sum(case when Churn = 'Yes' then  1 else 0 end) * 100/count(*),2)  as churned_customers
from customers
group by Contract;

-- Q4. Create tenure groups and analyze churn

select 
case when tenure <= 12 then '0-12'
when tenure <=24 then '13-24' 
when tenure <= 48 then '25-48'
else '48+' end as tenure_groups , 
count(*) as customers , 
sum(case when churn = 'Yes' then 1 or 0 end) as churned_customers
from customers
group by tenure_groups;

-- Q5. How much monthly revenue is lost due to churn?

select 
round(sum(MonthlyCharges),2) as monthly_lost
from customers
where Churn = 'Yes';

-- Q6. Revenue loss by contract type

select 
Contract , 
round(sum(MonthlyCharges),2) as revenue_lost
from customers
where Churn = 'Yes'
group by Contract
order by revenue_lost desc;

-- Q7. Which payment method has the highest churn rate?

select 
PaymentMethod , 
round(sum(case when Churn = 'Yes' then 1 else 0 end) * 100 / count(*),2) as churn_rate
from customers
group by PaymentMethod;

-- Q8. Find high-risk customers

select *
from customers
where Churn = 'Yes'
and Contract = 'Month-to-month'
and MonthlyCharges > (
select avg(MonthlyCharges)
from customers);
