USE test_db;
SELECT * FROM laptopdata;

SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'test_db'
AND TABLE_NAME = 'laptopdata';

DELETE FROM laptopdata
WHERE 
	Company is null and TypeName is null and INches is null and ScreenResolution is null and Cpu is null and 
    Ram is null and Memory is null and Gpu is null and OpSys is null and Weight is null and Price is null;


ALTER TABLE laptopdata MODIFY COLUMN Inches DECIMAL(3,1);

UPDATE laptopdata
SET Weight = (SELECT REPLACE(Weight, 'kg', ''));

UPDATE laptopdata
SET Price = (SELECT CEIL(Price));
ALTER TABLE laptopdata MODIFY Price INTEGER;

UPDATE laptopdata
SET OpSys = (
SELECT 
CASE 
	WHEN OpSys LIKE '%macos%' THEN 'mac'
    WHEN OpSys LIKE '%windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys LIKE 'No OS' THEN 'N/A'
    ELSE 'other'
END AS category);


ALTER TABLE laptopdata
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

UPDATE laptopdata
SET gpu_brand = (SELECT SUBSTRING_INDEX(Gpu, ' ',1));

UPDATE laptopdata
SET gpu_name = (SELECT REPLACE(Gpu, gpu_brand, ''));

ALTER TABLE laptopdata DROP COLUMN Gpu;

ALTER TABLE laptopdata
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed VARCHAR(255) AFTER cpu_name;

UPDATE laptopdata
SET cpu_brand = (SELECT SUBSTRING_INDEX(Cpu, ' ', 1));

UPDATE laptopdata
SET cpu_speed = (SELECT SUBSTRING_INDEX(Cpu, ' ', -1));

UPDATE laptopdata
SET cpu_speed = (SELECT CAST(REPLACE(cpu_speed, 'GHz', '') AS DECIMAL(10,1)));

ALTER TABLE laptopdata MODIFY COLUMN Ram INTEGER;

ALTER TABLE laptopdata
ADD COLUMN screen_width INTEGER AFTER ScreenResolution,
ADD COLUMN screen_height INTEGER AFTER screen_width;

UPDATE laptopdata
SET screen_width = (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x', 1)),
screen_height = (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1),'x', -1));

ALTER TABLE laptopdata
ADD COLUMN touchscreen INTEGER AFTER screen_height;

UPDATE laptopdata
SET touchscreen = (SELECT CASE WHEN ScreenResolution LIKE '%touch%' THEN 1 ELSE 0 END);

ALTER TABLE laptopdata DROP COLUMN ScreenResolution;

SELECT DISTINCT Memory FROM laptopdata;

ALTER TABLE laptopdata
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

UPDATE laptopdata
SET memory_type = (SELECT CASE 
    WHEN Memory LIKE '%+%' THEN 'Hybrid'
	WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    ELSE null
END );

UPDATE laptopdata
SET primary_storage = (SELECT REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+', 1),'[0-9]+')),
secondary_storage = (SELECT CASE WHEN memory_type = 'Hybrid' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+', -1),'[0-9]+') ELSE 0 END);

UPDATE laptopdata
SET primary_storage = (SELECT CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END),
secondary_storage = (SELECT CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END);

ALTER TABLE laptopdata DROP COLUMN Memory;

UPDATE laptopdata
SET secondaRy_storage = (SELECT CASE WHEN memory_type = 'Hybrid' THEN secondary_storage ELSE 0 END);


ALTER TABLE laptopdata 
DROP COLUMN gpu_name;


USE test_db;
SELECT * FROM laptopdata;


