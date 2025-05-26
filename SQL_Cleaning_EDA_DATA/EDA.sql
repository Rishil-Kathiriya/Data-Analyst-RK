-- EDA = Exploratory Data Analysis

use world_layoffs;

select * from layoff_staging2;

-- 1 percentage_laid_off = 100%
select max(total_laid_off),max(percentage_laid_off) from layoff_staging2;

select * from layoff_staging2 where percentage_laid_off = 1 order by total_laid_off desc;

select company,sum(total_laid_off) as total_laid_off from layoff_staging2 
group by company order by total_laid_off desc;
select industry,sum(total_laid_off) from layoff_staging2 group by industry order by 2 desc;
select country,sum(total_laid_off) from layoff_staging2 group by country order by 2 desc;


select `date`,sum(total_laid_off) from layoff_staging2 group by `date` order by 1 desc;
select year(`date`) Year_laid_off,sum(total_laid_off) from layoff_staging2 group by year(`date`) order by 1 desc;

select month(`date`) `Month`,sum(total_laid_off)
from layoff_staging2 group by `Month` order by `Month`;

select substring(`date`,1,4) `Year` , sum(total_laid_off)
from layoff_staging2 group by `Year` order by `Year`;

select substring(`date`,1,7) `month_year`,sum(total_laid_off) total_laid_off
from layoff_staging2
group by `month_year` 
having `month_year` is not null
order by 1;


-- Rolling Total
with Rolling_Total as
(
select substring(`date`,1,7) month_year,sum(total_laid_off) total_laid_off
from layoff_staging2
group by month_year 
having month_year is not null 
)
select month_year,sum(total_laid_off) ,sum(total_laid_off)
over(order by month_year) as Rolling_Total_
from Rolling_Total group by month_year;



-- Company and laid-off in each year 
select company,year(`date`),sum(total_laid_off) 
from layoff_staging2
group by company,year(`date`)
order by 3 desc; 

-- Ranking Highest Laid_off per Year by Company
with Rank_company(Company,Years,Total_laid_off) as
(
select company,year(`date`),sum(total_laid_off) 
from layoff_staging2
group by company,year(`date`)
)
select * ,dense_rank() over(partition by Years order by Total_laid_off desc)
from Rank_company;


with Rank_company2(Company,Years,Total_laid_off) as
(
select company,year(`date`),sum(total_laid_off) 
from layoff_staging2
where Total_laid_off and year(`date`) is not null
group by company,year(`date`)
)
select * ,dense_rank() over(partition by Years order by Total_laid_off desc) as Ranking
from Rank_company2;#order by Ranking;


with Rank_company2(Company,Years,Total_laid_off) as
(
select company,year(`date`),sum(total_laid_off) 
from layoff_staging2
where Total_laid_off and year(`date`) is not null
group by company,year(`date`)
),
Company_Rank_Year as
(
select * ,dense_rank() over(partition by Years order by Total_laid_off desc) as Ranking
from Rank_company2
)
select * from Company_Rank_Year where Ranking <= 5;




