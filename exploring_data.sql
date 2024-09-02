-- exploratory data analysis

select * from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;
-- look for companies where their percentage laid off was  was equal to one
select *
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;
-- look company and sum of total laid off then group by compagny then order by thesum of the total laid off
select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by sum(total_laid_off) Desc;

-- date range
select min(date),max(date)
from layoffs_staging2;
-- check at industries that heat the most laid off
select industry,sum(total_laid_off)
from layoffs_staging2
group by industry
order by sum(total_laid_off) Desc;

-- check countries with total of laid off according to date s
select country,sum(total_laid_off),date
from layoffs_staging2
group by country,date
order by date Desc;

-- let group the sum of total laid off by grouping for eacg year
select year(date),sum(total_laid_off)
from layoffs_staging2
group by year(date)
order by sum(total_laid_off) Desc;

-- show the stage of the company
select stage,sum(total_laid_off)
from layoffs_staging2
group by stage
order by sum(total_laid_off) Desc;
-- giving the outputs of companies and their average percentage laid off
select company,avg(percentage_laid_off)
from layoffs_staging2
group by company
order by sum(percentage_laid_off) Desc;
-- rolling total of laid off based on months
select substring(date,1,7) as month,sum(total_laid_off)
from layoffs_staging2
where substring(date,1,7) is not null
group by month
order by month;
-- rolling sum of this 
with t1 as(
select substring(date,1,7) as month,sum(total_laid_off) as laid_off
from layoffs_staging2
where substring(date,1,7) is not null
group by month
order by month
)
select month,sum(laid_off) over (order by month) as rollinga_total, total_laid_off;

-- mutiple that made many laid off
select company,year(`date`) as years ,sum(total_laid_off)
from layoffs_staging2
group by company,years
order by 3 desc;

-- rank the year the laid off most employee like making the highest rank number 1
with t1 as 
(select company,year(`date`) as years ,sum(total_laid_off) as sum_laid_off
from layoffs_staging2
group by company,years
),
company_rank as(
select * ,dense_rank() over(partition by  years order by sum_laid_off desc ) as ranking
from t1
where years is not null)
select *
from company_rank
where ranking<=5
order by ranking desc

-- 
