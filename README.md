# 📌 Introduction
This project explores job postings to identify top-paying Data Analyst roles, the most in-demand skills, and the optimal combination of skills based on salary and demand. The primary goal is to guide data professionals in targeting the right skills and roles for career advancement—whether seeking a new opportunity or a promotion.

[project_sql folder](/project_sql/)


# 🧠 Background
With the ever-growing demand for data professionals, knowing what skills to prioritize can be challenging. This project is designed to answer key career-defining questions using structured job market data. Using SQL, I extracted insights from job postings to understand:

- What are the top-paying jobs for Data Analysts?

- What skills are required for these top-paying jobs?

- What are the most in-demand skills for Data Analysts?

- What skills fetch the highest average salaries?

- What are the most optimal skills—those both in high demand and highly paid?

The Data for this project hails from [Luke Barousse's SQL course](https://lukebarousse.com/sql). 

This project not only serves as an analytical exercise but also as a strategic roadmap for personal career development.


# 🛠️ Tools I used
- **SQL:** Primary tool for data exploration and analysis

- **PostgreSQL:** Database system used to execute and test queries

- **Microsoft Excel:** Used for data visualization, to support insights from SQL queries.

- **Git & GitHub:** Version control and project hosting

# 📊 The Analysis
This section outlines the step-by-step SQL analysis I conducted to answer the project’s core questions:

### 1. Top-Paying Data Analyst Jobs
I queried job postings to:

Filter roles with “Data Analyst” in the title

Order by salary to identify the top-paying positions

Extract job details (company, location, job title, salary)

```sql

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

```


![Average Salary Distribution](assets/Average%20Salary%20Distribution.png)

*Bar graph visualizing the salary for the top 10 salaries for data analysts: I generated this graph using Microsoft Excel*

This chart highlights salary trends across data analyst roles:

- Top-paying role: Data Analyst (likely skewed by a high outlier or aggregated range).

- Leadership roles like Director of Analytics and Associate Director – Data Insights also command high salaries.

- Hybrid/Remote roles appear multiple times, reflecting market demand for flexible work setups in high-paying positions.


### 2. Skills Required by Top-Paying Roles
Using a join between job postings and skill listings:

I found which skills appear most frequently among the highest-paying jobs

Grouped and counted skills to identify recurring requirements

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

![Top Paying Roles](assets/Top%2010%20Common%20Skills%20for%20Data%20Analysts%202023.png)

*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts. I used Microsoft Excel to generate this graph from my SQL query*

This chart shows the most frequently listed technical skills:

- Top 3: SQL, Python, and Tableau dominate as must-haves.

- Others like R, Snowflake, Excel, and Pandas remain valuable in data manipulation and analysis.

- Bitbucket, Azure, and Atlassian indicate the growing importance of version control, cloud, and collaboration tools.



### 3. Most In-Demand Skills
I performed a frequency count of all skills across the full dataset:

Identified the top 10 most listed skills in job postings

Gave a sense of what employers are commonly looking for

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 7291         |
| Excel     | 4611         |
| Python    | 4330         |
| Tableau   | 3745         |
| Power BI  | 2609         |

💡 Key Takeaways
- SQL is non-negotiable — it appears in almost twice as many postings as Python, reinforcing its foundational role.

- Excel holds its ground — it's still widely used, especially in non-tech or legacy systems.

- Python complements SQL — offering more flexibility for automation and advanced analytics.

- BI Tools are critical — Tableau and Power BI are both important, with the choice often depending on the company ecosystem.

### 4. Highest Average Salary by Skill
By grouping salary data by skill:

I calculated the average salary associated with each skill

This revealed which technical skills are linked to premium pay

```sql
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
```
| Rank | Skill           | Average Salary (USD) |
|------|------------------|----------------------|
| 1    | pyspark          | $208,172             |
| 2    | bitbucket        | $189,155             |
| 3    | couchbase        | $160,515             |
| 4    | watson           | $160,515             |
| 5    | datarobot        | $155,486             |
| 6    | gitlab           | $154,500             |
| 7    | swift            | $153,750             |
| 8    | jupyter          | $152,777             |
| 9    | pandas           | $151,821             |
| 10   | elasticsearch    | $145,000             |
| 11   | golang           | $145,000             |
| 12   | numpy            | $143,513             |
| 13   | databricks       | $141,907             |
| 14   | linux            | $136,508             |
| 15   | kubernetes       | $132,500             |
| 16   | atlassian        | $131,162             |
| 17   | twilio           | $127,000             |
| 18   | airflow          | $126,103             |
| 19   | scikit-learn     | $125,781             |
| 20   | jenkins          | $125,436             |
| 21   | notion           | $125,000             |
| 22   | scala            | $124,903             |
| 23   | postgresql       | $123,879             |
| 24   | gcp              | $122,500             |
| 25   | microstrategy    | $121,619             |

Here’s a breakdown of the key takeaways:

- Pyspark is the top-paying skill, averaging over $208k.

- Big data & ML tools (e.g., PySpark, Datarobot, Jupyter, Pandas) dominate the top spots.

- Version control tools like Bitbucket and GitLab command high salaries.

- BI & cloud skills (e.g., Databricks, MicroStrategy, GCP) remain valuable.

- Core Python data libraries (e.g., Numpy, Scikit-learn) still yield high returns.

### 5. Optimal Skills
To find the best return-on-investment skills:

I combined the top 10 most in-demand skills and the top 10 highest-paid skills using a CTE and INTERSECT

The result is a list of "optimal skills" that are both popular and lucrative.


```sql
WITH skills_demand AS (
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
     salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY 
    skills_dim.skill_id
), average_salary AS (
SELECT 
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY 
    skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25
```

| Skill        | Demand Count | Average Salary ($) |
|--------------|--------------|--------------------|
| Go           | 27           | 115,320            |
| Confluence   | 11           | 114,210            |
| Hadoop       | 22           | 113,193            |
| Snowflake    | 37           | 112,948            |
| Azure        | 34           | 111,225            |
| BigQuery     | 13           | 109,654            |
| AWS          | 32           | 108,317            |
| Java         | 17           | 106,906            |
| SSIS         | 12           | 106,683            |
| Jira         | 20           | 104,918            |
| Oracle       | 37           | 104,534            |
| Looker       | 49           | 103,795            |
| NoSQL        | 13           | 101,414            |
| Python       | 236          | 101,397            |
| R            | 148          | 100,499            |
| Redshift     | 16           | 99,936             |
| Qlik         | 13           | 99,631             |
| Tableau      | 230          | 99,288             |
| SSRS         | 14           | 99,171             |
| Spark        | 13           | 99,077             |
| C++          | 11           | 98,958             |
| SAS          | 63           | 98,902             |
| SQL Server   | 35           | 97,786             |
| JavaScript   | 20           | 97,587             |

🔑 Key Takeaways (Demand Count > 10)

- Top in Demand:

Python (236), Tableau (230), and R (148) lead the market.

- Highest Paying (Among Skills with >10 Demand):

Go ($115K), Confluence ($114K), Hadoop ($113K).

- Balanced Skills (Good Pay & Demand):

Python, R, Snowflake, Azure, AWS offer both solid salaries and strong demand.

- Valuable BI & DB Tools:

Looker, Power BI, Qlik, and SQL Server show consistent value in analytics roles.

- Programming Stays Relevant:

Python, R, Java, and Go remain top technical assets.

# 📚 What I learned
🔍 Querying with Purpose
I learned to write efficient SQL queries tailored to solve real-world problems, such as salary ranking, skill frequency analysis, and data aggregation.

💡 Insight Generation
Key insights from my analysis:

- Top-paying Data Analyst jobs are remote-friendly and often demand advanced technical and cloud-based skills.

- SQL and Python are consistently in demand, appearing in most high-paying roles.

- Skills like pyspark, databricks, and airflow command top-tier salaries, signaling the value of hybrid data analyst-engineer roles.

- Optimal skills are those that rank high both in demand and salary—offering both job security and financial advantage.

🧩 Combining Subqueries and CTEs
I practiced using Common Table Expressions (CTEs) and JOINs to build layered logic, such as filtering top jobs and then mapping associated skills.

# 📈 Conclusions
## 📊Insights

**SQL remains king** – Its dominance across job listings confirms it as a foundational skill for data analysts.

**Python is versatile and well-compensated** – Widely demanded and among the best-paying, especially when paired with libraries like Pandas, NumPy, and Scikit-learn.

**BI tools are essential** – Tableau, Power BI, and Looker are in high demand and appear consistently across top-paying roles.

**Cloud, Big Data & ML tools boost earning potential** – Skills like PySpark, Databricks, GCP, and Datarobot are tied to higher salaries.

**Version control & collaboration tools matter** – Bitbucket, GitLab, Confluence, and Atlassian tools are increasingly valued in team-based data environments.

**Hybrid roles are becoming the norm** – Many high-paying jobs offer hybrid or remote flexibility, reflecting shifting workforce expectations.
This project reinforces how data analysis can be a career navigation tool. By studying job market trends through SQL:


## Closing Thoughts
In conclusion, this project has not only strengthened my practical querying skills but also revealed which technical skills carry the most leverage in both salary negotiations and job opportunities. The final query—merging demand and salary insights—serves as a strategic compass for deciding what to learn next. Whether you're stepping into the job market or positioning for a promotion, understanding what the market truly values can provide a decisive edge.