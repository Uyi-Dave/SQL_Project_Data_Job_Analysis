/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

COPY company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
*/


-- NOTE: This has been updated from the video to fix issues with encoding


CREATE TEMP TABLE temp_company_dim (LIKE company_dim);

COPY temp_company_dim 
FROM 'C:/temp/company_dim.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

INSERT INTO company_dim
SELECT DISTINCT * FROM temp_company_dim
ON CONFLICT DO NOTHING;


/*CREATE TEMP TABLE temp_job_postings_fact (LIKE job_postings_fact);

COPY job_postings_fact 
FROM 'C:\temp\job_postings_fact.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

INSERT INTO job_postings_fact
SELECT DISTINCT * FROM temp_job_postings_fact
ON CONFLICT (job_postings_fact_pkey) DO NOTHING;
*/

COPY company_dim
FROM 'C:\Users\USER\Documents\SQL\SQL_Project_Data_Job_Analysis\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim 
FROM 'C:/Users/USER/Documents/SQL/SQL_Project_Data_Job_Analysis/csv_files/skills_dim.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact 
FROM 'C:/Users/USER/Documents/SQL/SQL_Project_Data_Job_Analysis/csv_files/job_postings_fact.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim 
FROM 'C:/Users/USER/Documents/SQL/SQL_Project_Data_Job_Analysis/csv_files/skills_job_dim.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');






