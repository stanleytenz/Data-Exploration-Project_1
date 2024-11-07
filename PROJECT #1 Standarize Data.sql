SELECT * FROM layout_staging2;

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y') AS `date`
FROM layout_staging2;

UPDATE layout_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%' ;

UPDATE layout_staging2
SET date = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layout_staging2
MODIFY COLUMN `date` DATE;
