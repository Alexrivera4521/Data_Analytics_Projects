-- Data Cleaning
select * from layoffs;

-- Create a staging table

CREATE TABLE layoffs_staging
Like layoffs;

-- Insert all elements from layoffs table into new staging table

insert layoffs_staging
select * from layoffs;

-- Check records in new staging table

select * from layoffs_staging  where company = 'Casper';


-- STEP 1: Remove Duplicates

-- Check for duplicate rows:

with duplicate_cte as(
SELECT 
    *,
    row_number() over(
    partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM
    layoffs_staging
) select * from duplicate_cte where row_num > 1 ;


-- Delete duplicates from layoffs_stagin table

-- 1. Create new temp table with a row_num column

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2 where row_num > 1 ;

insert into layoffs_staging2
SELECT 
    *,
    row_number() over(
    partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM
    layoffs_staging ;

-- Delete row_num > 1 values from layoffs_staging2 table


delete
FROM
    layoffs_staging2
WHERE
    row_num > 1;


-- STEP 2: Standardize the Data

-- Remove leading and trailing spaces from  company column

select company, length(company), trim(company), length(trim(company)) from layoffs_staging2  ;

update layoffs_staging2
set company = trim(company) ;


-- Standardize Industry column
select distinct(industry) from layoffs_staging2 order by 1 ;
select * from layoffs_staging2 where industry like '%Crypto%';

Update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';



-- Standardize country column
select distinct(country), trim(trailing '.' from country) from layoffs_staging2 order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';


-- Format Date column
SELECT 
    *
FROM
    layoffs_staging2;
    
update layoffs_staging2
set
`date` = STR_TO_DATE(`date`, '%m/%d/%Y') ;

-- Alter staging table to change Date column from text to date format

alter table layoffs_staging2
modify column `date` DATE;



-- STEP 3: Null or Blank Values

SELECT * FROM layoffs_staging2 WHERE total_laid_off is null and percentage_laid_off is null;
SELECT * FROM layoffs_staging2 WHERE industry is null or industry = '';
select * from layoffs_staging2 where company like 'Bally%';

-- Update records where industry is NULL

-- 1. Find the records to update
select * from layoffs_staging2 t1
join layoffs_staging2 t2 on t1.company = t2.company and t1.location = t2.location
where (t1.industry is null or t1.industry = '')  and t2.industry is not null;


-- 2. Write the update statement and execute it

update layoffs_staging2
set industry = NULL where industry = '';

update layoffs_staging2 t1
join layoffs_staging2 t2 on t1.company = t2.company and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null  and t2.industry is not null; 


-- STEP 4: Remove unnecessary rows and columns

select * from layoffs_staging2 ;
SELECT * FROM layoffs_staging2 WHERE total_laid_off is null and percentage_laid_off is null;

-- Delete irrelevant data
delete from layoffs_staging2 WHERE total_laid_off is null and percentage_laid_off is null;

-- Drop row_num column
alter table layoffs_staging2 drop column row_num;