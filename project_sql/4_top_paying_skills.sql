/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focus on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and
    helps identify the most financially rewarding skills to acquire or improve
*/


SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    avg_salary DESC
LIMIT 25



/*
 Top-Paying Skills – Trends & Observations
1. Big Data & Distributed Computing Dominate
Top Skill: pyspark ($208,172 avg)

Others: databricks, airflow, kubernetes, scala

These tools are core in handling large-scale data pipelines, real-time processing, and data engineering — suggesting that data analysts with these skills are moving closer to data engineering or hybrid roles.

2. Machine Learning & AI Tools Are Highly Valued
datarobot, scikit-learn, jupyter, numpy, pandas

This reflects a growing expectation that data analysts can go beyond dashboards and work with predictive modeling or ML pipelines.

3. Cloud & DevOps Tools Fetch High Salaries
gcp, linux, jenkins, gitlab, bitbucket, atlassian

Analysts with cloud computing and CI/CD skills can contribute to production-level analytics and automated workflows, making them more versatile (and valuable).

4. Programming-Focused Analysts Are In Demand
golang, swift, scala

These languages aren’t traditionally associated with data analysts but appear here, indicating hybrid roles that bridge data analysis with software development.

5. Modern BI & Data Stack Tools Appear
microstrategy, elasticsearch, notion, databricks

These tools show demand for searchable analytics platforms, real-time dashboards, and collaborative tools beyond classic BI (like Tableau).

Strategic Takeaways
Trend	                    --- Implication for Data Analysts
Data + Engineering hybrid   ---	Upskill in pyspark, airflow, databricks
ML/AI skills = high pay     ---	Know scikit-learn, jupyter, pandas
DevOps familiarity matters  ---	Learn gitlab, jenkins, kubernetes
Cloud fluency is a plus	    --- GCP, linux experience is well paid
Flexibility = Value	        --- Multi-disciplinary skills yield higher roles
*/

