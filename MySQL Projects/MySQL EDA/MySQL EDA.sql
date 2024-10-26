-- Exploratory Data Analysis

select * from layoffs_staging2 where percentage_laid_off = 1;
select  MAX(total_laid_off) from layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Layoffs date range
select min(`date`), max(`date`)
from layoffs_staging2;

-- Layoffs by industry
SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- Layoffs by country
SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- Layoffs by date
SELECT 
    year(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY year(`date`)
ORDER BY 1 DESC;



-- Layoffs by stage
SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;




-- Layoffs by stage
SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;



SELECT 
    SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;



with Rolling_total as (
SELECT 
    SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) as total_off
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC) select `month`, total_off, sum(total_off) OVER(ORDER BY `month`) as rolling_ttl
from Rolling_total;



-- Highest lay-off by company and year
SELECT 
    company, YEAR(`date`) AS ytd, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company , ytd
ORDER BY 3 DESC;



with company_year (company, years, total_laid_off) as (
SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)), company_year_rank as( select *, 
dense_rank() over (partition by years order by total_laid_off desc) as dense_rank_
from company_year where years is not null) select * from company_year_rank where  dense_rank_ <= 5;



