use world_layoffs;


select * from layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Value or Blank values
-- 4. Remove Unneccesary Columns


create table layoff_staging like layoffs;
select * from layoff_staging;

insert layoff_staging select * from layoffs;


-- 1. Remove Duplicates

select *, 
Row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,
stage,country,funds_raised_millions) as Row_num
from layoff_staging;

 with cte_duplicate as
 (
 select *, 
Row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) as Row_num
from layoff_staging
 )
 select * from cte_duplicate where Row_num > 1;
 
 
 CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `Row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



insert into layoff_staging2
select *, 
Row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,
stage,country,funds_raised_millions) as Row_num
from layoff_staging;


select * from layoff_staging2;

select * from layoff_staging2 where Row_num > 1;


delete from layoff_staging2 where Row_num > 1;

 
 
 -- 2. Standardize the Data
 
select company,trim(company) from layoff_staging2;
update layoff_staging2 set company=trim(company);

select distinct industry from layoff_staging2 order by 1;
select * from layoff_staging2 where industry like 'crypto%';
update layoff_staging2 set industry='Crypto' where industry like 'crypto%';




select distinct country from layoff_staging2 order by 1;

select * from layoff_staging2 where country like 'United states.%';

update layoff_staging2 set country='United states' where country like 'United states%';
-- or 
select distinct country,trim(trailing '.' from country) from layoff_staging2 order by 1;

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoff_staging2;

update layoff_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoff_staging2 modify column `date` Date; 
 
select * from layoff_staging2; 
 
 


 
-- 3. Null Value or Blank values
 
 select * from layoff_staging2 where total_laid_off is null
 and percentage_laid_off is null;
 
 select * from layoff_staging2 where
 industry is null
 or industry = '';
 
 select * from layoff_staging2 t1
 join layoff_staging2 t2
 on t1.company=t2.company
 and t1.location=t2.location 
 where (t1.industry = '' or t1.industry is null)
 and t2.industry is not null;
 
 select * from layoff_staging2 where company = 'airbnb';
 
 update layoff_staging2 
 set industry = null
 where industry = '';
 
 update layoff_staging2 t1
 join layoff_staging2 t2
 on t1.company=t2.company
 set t1.industry = t2.industry
 where t1.industry is null and t2.industry is not null;
 
 select * from layoff_staging2;
 



-- 4. Remove Unneccesary Columns


 select * from layoff_staging2 where total_laid_off is null
 and percentage_laid_off is null;



 delete 
 from layoff_staging2 where total_laid_off is null
 and percentage_laid_off is null;
 
-- alter table layoff_staging2 drop column Row_num; 
 
 
 select * from layoff_staging2;
 

