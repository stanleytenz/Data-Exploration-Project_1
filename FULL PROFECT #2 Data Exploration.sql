-- Data Exploration

SELECT * FROM cleaned_layoff;


-- MAX Lay off group by company
SELECT company, MAX(total_laid_off) 
FROM cleaned_layoff
GROUP BY company
ORDER BY 2 DESC
;

-- Total Lay off group by company
SELECT company, SUM(total_laid_off)
FROM cleaned_layoff
GROUP BY company
ORDER BY 2 DESC
;

-- MAX Lay off group by company each month
SELECT company, SUBSTRING(`date`, 1,7) as `MONTH`, MAX(total_laid_off)
FROM cleaned_layoff
GROUP BY company, `MONTH`
ORDER BY 3 DESC
;

-- total Lay off group by company each month
SELECT company, SUBSTRING(`date`, 1,7) as `MONTH`, SUM(total_laid_off)
FROM cleaned_layoff
GROUP BY company, `MONTH`
ORDER BY 3 DESC
;

-- max lay off group by company each year
SELECT company, YEAR(`date`) AS `YEAR`, MAX(total_laid_off)
FROM cleaned_layoff
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, `YEAR`
ORDER BY 2 ASC
;

-- Total layy off each year
SELECT YEAR(`date`) AS `YEAR`, SUM(total_laid_off)
FROM cleaned_layoff
WHERE YEAR(`date`) IS NOT NULL
GROUP BY `YEAR`
ORDER BY 1 ASC
;

-- Total lay off each month
SELECT SUBSTRING(`date`, 1,7) AS `month`, SUM(total_laid_off)
FROM cleaned_layoff
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
;


-- rolling total per month
WITH rolling_total AS 
(
SELECT SUBSTRING(`date`, 1,7) AS `month`, SUM(total_laid_off) as total_off
FROM cleaned_layoff
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `month`
)
SELECT *,
SUM(total_off) OVER (ORDER BY `month`) AS Rolling_total
FROM rolling_total;

-- rolling total per year
WITH rolling_total AS 
(
SELECT YEAR(`date`) AS `years`, SUM(total_laid_off) as total_off
FROM cleaned_layoff
WHERE YEAR(`date`) IS NOT NULL
GROUP BY `years`
)
SELECT *,
SUM(total_off) OVER (ORDER BY `years`) AS Rolling_total
FROM rolling_total;

-- ranking each month
WITH CTE_1 (company, months, total_laid_off) AS 
(	
SELECT company, SUBSTRING(`date`, 1,7) AS `month`, SUM(total_laid_off) AS number_of_laid_off
FROM cleaned_layoff
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY company,SUBSTRING(`date`, 1,7)
), CTE_ranking AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY months ORDER BY total_laid_off DESC) AS ranking
FROM CTE_1
)
SELECT * FROM CTE_ranking
WHERE ranking <= 5
;

-- ranking each year
WITH CTE_2 (company, years, total_laid_off) AS 
(	
SELECT company, YEAR(`date`) as years, SUM(total_laid_off) AS number_of_laid_off
FROM cleaned_layoff
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company,YEAR(`date`)
), CTE_ranking2 AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM CTE_2
)
SELECT * FROM CTE_ranking2
WHERE ranking <= 5
;