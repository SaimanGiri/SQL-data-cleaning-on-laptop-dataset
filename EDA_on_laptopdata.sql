USE test_db;
SELECT * FROM laptopdata;


-- head
SELECT * FROM laptopdata 
ORDER BY `index`
LIMIT 5;


-- tail
SELECT * FROM 
(SELECT * FROM laptopdata
ORDER BY `index` DESC
LIMIT 5) t
ORDER BY `index`;


-- sample
SELECT * FROM laptopdata
ORDER BY rand() LIMIT 5;


-- numerical column analysis 

SELECT buckets, REPEAT(']',ROUND(COUNT(*)/40)) AS relative_frequency FROM (SELECT Price,CASE
	WHEN Price BETWEEN 0 AND 25000 THEN '0-25K'
    WHEN Price BETWEEN 25001 AND 50000 THEN '25K-50K'
    WHEN Price BETWEEN 50001 AND 75000 THEN '50K-75K'
    WHEN Price BETWEEN 75001 AND 100000 THEN '75K-100K'
    ELSE 'greater than 100K' END AS buckets
FROM laptopdata) t 
GROUP BY 1
ORDER BY 1;
