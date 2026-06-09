-- Create the database
CREATE DATABASE GitHubAnalytics;
GO

-- Switch to it
USE GitHubAnalytics;
GO

-- 1. Repositories
CREATE TABLE repositories (
    repo_id      INT PRIMARY KEY,
    repo_name    VARCHAR(100),
    language     VARCHAR(50),
    created_date DATE,
    visibility   VARCHAR(20),
    team         VARCHAR(50)
);

-- 2. Contributors
CREATE TABLE contributors (
    contributor_id INT PRIMARY KEY,
    username       VARCHAR(100),
    full_name      VARCHAR(100),
    role           VARCHAR(50),
    join_date      DATE
);

-- 3. Commits
CREATE TABLE commits (
    commit_id      INT PRIMARY KEY,
    repo_id        INT FOREIGN KEY REFERENCES repositories(repo_id),
    contributor_id INT FOREIGN KEY REFERENCES contributors(contributor_id),
    commit_date    DATETIME,
    lines_added    INT,
    lines_deleted  INT,
    commit_message VARCHAR(255),
    branch         VARCHAR(100)
);

-- 4. Pull Requests
CREATE TABLE pull_requests (
    pr_id           INT PRIMARY KEY,
    repo_id         INT FOREIGN KEY REFERENCES repositories(repo_id),
    contributor_id  INT FOREIGN KEY REFERENCES contributors(contributor_id),
    title           VARCHAR(200),
    status          VARCHAR(20),
    created_date    DATETIME,
    merged_date     DATETIME NULL,
    reviewers_count INT
);

-- 5. Issues
CREATE TABLE issues (
    issue_id       INT PRIMARY KEY,
    repo_id        INT FOREIGN KEY REFERENCES repositories(repo_id),
    contributor_id INT FOREIGN KEY REFERENCES contributors(contributor_id),
    title          VARCHAR(200),
    priority       VARCHAR(20),
    status         VARCHAR(20),
    created_date   DATETIME,
    closed_date    DATETIME NULL,
    label          VARCHAR(50)
);

-- 6. Code Reviews
CREATE TABLE code_reviews (
    review_id    INT PRIMARY KEY,
    pr_id        INT FOREIGN KEY REFERENCES pull_requests(pr_id),
    reviewer_id  INT FOREIGN KEY REFERENCES contributors(contributor_id),
    review_date  DATETIME,
    outcome      VARCHAR(20),
    comments_count INT
);

USE GitHubAnalytics;

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';


--Block 1 — Repositories

INSERT INTO repositories VALUES
(1, 'data-pipeline-etl',   'Python',     '2023-01-15', 'public',  'Data Engineering'),
(2, 'bi-dashboard-suite',  'SQL',        '2023-03-20', 'private', 'Analytics'),
(3, 'api-gateway-service', 'Java',       '2023-06-01', 'private', 'Backend'),
(4, 'ml-model-registry',   'Python',     '2024-01-10', 'public',  'Data Science'),
(5, 'frontend-portal',     'JavaScript', '2023-09-15', 'private', 'Frontend');


--Block 2 — Contributors 

INSERT INTO contributors VALUES
(1,  'bala_d',   'Bala Dasari',  'Lead Analyst', '2023-01-01'),
(2,  'priya_k',  'Priya Kumar',  'Senior Dev',   '2023-01-15'),
(3,  'ravi_m',   'Ravi Mehta',   'Senior Dev',   '2023-02-01'),
(4,  'anita_s',  'Anita Shah',   'QA Engineer',  '2023-03-01'),
(5,  'james_t',  'James Torres', 'Junior Dev',   '2023-06-01'),
(6,  'liu_w',    'Liu Wei',      'Senior Dev',   '2023-04-15'),
(7,  'sara_n',   'Sara Nair',    'Junior Dev',   '2024-01-01'),
(8,  'mike_b',   'Mike Brown',   'QA Engineer',  '2023-07-01'),
(9,  'fatima_z', 'Fatima Zaidi', 'Lead Analyst', '2023-05-01'),
(10, 'carlos_r', 'Carlos Reyes', 'Senior Dev',   '2023-08-01');

--Block 3 — Commits

INSERT INTO commits VALUES
(1,  1, 1,  '2024-01-05 09:15:00', 120, 30, 'Initial ETL pipeline setup',       'main'),
(2,  1, 2,  '2024-01-06 10:30:00', 85,  10, 'Add S3 connector module',          'feature/s3'),
(3,  2, 1,  '2024-01-08 14:00:00', 200, 50, 'Dashboard schema v1',              'main'),
(4,  3, 3,  '2024-01-10 11:00:00', 60,  5,  'API rate limiter fix',             'hotfix'),
(5,  1, 4,  '2024-01-12 09:45:00', 30,  15, 'Unit tests for ETL',               'test'),
(6,  4, 1,  '2024-01-15 16:00:00', 180, 20, 'ML model versioning logic',        'main'),
(7,  2, 9,  '2024-01-18 10:00:00', 95,  0,  'Power BI DAX measures added',      'feature/dax'),
(8,  5, 5,  '2024-01-20 13:30:00', 45,  5,  'Login UI component',               'feature/auth'),
(9,  1, 6,  '2024-01-22 09:00:00', 150, 40, 'Spark job optimization',           'main'),
(10, 3, 3,  '2024-01-25 11:45:00', 70,  10, 'Add JWT auth middleware',          'feature/auth'),
(11, 2, 1,  '2024-02-01 10:00:00', 110, 20, 'KPI report schema update',         'main'),
(12, 4, 7,  '2024-02-05 14:00:00', 55,  5,  'Feature flag implementation',      'feature/flags'),
(13, 1, 2,  '2024-02-08 09:30:00', 90,  25, 'Delta Lake integration',           'main'),
(14, 5, 8,  '2024-02-10 15:00:00', 20,  10, 'QA test scripts for login',        'test'),
(15, 3, 10, '2024-02-12 11:00:00', 130, 30, 'Kafka consumer refactor',          'main'),
(16, 2, 9,  '2024-02-15 10:30:00', 75,  0,  'Add drill-through report page',    'feature/drillthrough'),
(17, 4, 1,  '2024-02-18 14:00:00', 200, 60, 'Model accuracy benchmarking',      'main'),
(18, 1, 6,  '2024-02-20 09:00:00', 165, 45, 'Pipeline monitoring alerts',       'main'),
(19, 5, 5,  '2024-02-22 13:00:00', 40,  5,  'Dashboard layout responsive fix',  'feature/ui'),
(20, 3, 3,  '2024-02-25 10:00:00', 95,  15, 'gRPC endpoint optimization',       'main');


--Block 4 — Pull Requests

INSERT INTO pull_requests VALUES
(1,  1, 2,  'Add S3 connector',        'merged', '2024-01-06 10:00:00', '2024-01-08 15:00:00', 2),
(2,  2, 9,  'DAX measures v1',         'merged', '2024-01-18 09:00:00', '2024-01-20 12:00:00', 1),
(3,  3, 3,  'JWT auth middleware',     'merged', '2024-01-25 11:00:00', '2024-01-28 14:00:00', 3),
(4,  4, 7,  'Feature flags module',    'open',   '2024-02-05 14:00:00', NULL,                  2),
(5,  5, 5,  'Responsive UI fixes',     'merged', '2024-02-22 13:00:00', '2024-02-24 10:00:00', 1),
(6,  1, 6,  'Spark optimization PR',   'merged', '2024-01-22 08:00:00', '2024-01-24 11:00:00', 2),
(7,  2, 1,  'Drill-through page',      'closed', '2024-02-15 10:00:00', NULL,                  1),
(8,  4, 1,  'Benchmark report PR',     'merged', '2024-02-18 14:00:00', '2024-02-20 09:00:00', 2),
(9,  3, 10, 'Kafka consumer refactor', 'open',   '2024-02-25 10:00:00', NULL,                  3),
(10, 1, 2,  'Delta Lake integration',  'merged', '2024-02-08 09:00:00', '2024-02-10 16:00:00', 2);



--Block 5 — Issues 

INSERT INTO issues VALUES
(1,  1, 4, 'ETL fails on null values',      'critical', 'closed',      '2024-01-10 09:00:00', '2024-01-12 14:00:00', 'bug'),
(2,  2, 1, 'Add export to CSV feature',     'medium',   'closed',      '2024-01-15 10:00:00', '2024-01-22 11:00:00', 'feature'),
(3,  3, 8, 'API timeout on large payloads', 'high',     'in_progress', '2024-01-20 14:00:00', NULL,                  'bug'),
(4,  4, 7, 'Model versioning edge case',    'high',     'closed',      '2024-01-25 09:00:00', '2024-02-01 10:00:00', 'bug'),
(5,  5, 5, 'Login button misaligned',       'low',      'closed',      '2024-01-28 11:00:00', '2024-02-05 09:00:00', 'enhancement'),
(6,  1, 2, 'Spark job memory overflow',     'critical', 'closed',      '2024-02-01 08:00:00', '2024-02-03 15:00:00', 'bug'),
(7,  2, 9, 'KPI report wrong totals',       'high',     'closed',      '2024-02-05 10:00:00', '2024-02-08 12:00:00', 'bug'),
(8,  3, 3, 'Rate limiter not resetting',    'medium',   'open',        '2024-02-10 09:00:00', NULL,                  'bug'),
(9,  4, 1, 'Add GPU support for training',  'medium',   'in_progress', '2024-02-12 14:00:00', NULL,                  'feature'),
(10, 5, 8, 'QA test coverage below 70%',    'high',     'open',        '2024-02-20 10:00:00', NULL,                  'enhancement');


--Block 6 — Code Reviews 

INSERT INTO code_reviews VALUES
(1,  1,  1,  '2024-01-07 10:00:00', 'approved',          3),
(2,  1,  4,  '2024-01-07 14:00:00', 'changes_requested', 5),
(3,  2,  1,  '2024-01-19 10:00:00', 'approved',          2),
(4,  3,  9,  '2024-01-26 09:00:00', 'approved',          1),
(5,  3,  1,  '2024-01-27 11:00:00', 'changes_requested', 4),
(6,  3,  4,  '2024-01-27 15:00:00', 'approved',          2),
(7,  5,  9,  '2024-02-23 10:00:00', 'approved',          1),
(8,  6,  1,  '2024-01-23 09:00:00', 'approved',          3),
(9,  6,  4,  '2024-01-23 14:00:00', 'approved',          2),
(10, 8,  9,  '2024-02-19 10:00:00', 'approved',          4),
(11, 10, 1,  '2024-02-09 09:00:00', 'changes_requested', 6),
(12, 10, 3,  '2024-02-09 14:00:00', 'approved',          2);


SELECT 'repositories'  AS tbl, COUNT(*) AS rows FROM repositories  UNION ALL
SELECT 'contributors',          COUNT(*)          FROM contributors  UNION ALL
SELECT 'commits',               COUNT(*)          FROM commits       UNION ALL
SELECT 'pull_requests',         COUNT(*)          FROM pull_requests UNION ALL
SELECT 'issues',                COUNT(*)          FROM issues        UNION ALL
SELECT 'code_reviews',          COUNT(*)          FROM code_reviews;


--Q1. How many commits did each contributor make, and what is their role? 

select * from contributors
SELECT * FROM commits

select c.full_name, 
		c.role, 
		count(cm.commit_id) as Total_Commits 
from commits cm 
join contributors  c on c.contributor_id = cm.contributor_id 
group by c.full_name,c.role
order by Total_Commits Desc


--Which repository has the highest PR merge rate? 	

select * from repositories
select * from pull_requests

select r.repo_name , count(pr.pr_id) as total_prs,
SUM(case when pr.status ='merged' then 1 else 0 end ) as merged_prs, 
ROUND(100 * SUM(case when pr.status ='merged' then 1 else 0 end ) 
	/ count(pr.pr_id),1 ) as Merge_rate_pct
from repositories r 
join pull_requests pr on r.repo_id =pr.repo_id
group by r.repo_name 
order by Merge_rate_pct DESC

--What is the average resolution time for critical bugs vs low priority issues?
select * from issues

select i.priority ,
	count(i.issue_id) as total_issues,
	avg(datediff(day,i.created_date,i.closed_date)) as Avg_resolution 
from issues i
where i.status ='closed'
group by i.priority 
order by 
	case i.priority
		when 'critical' then 1
		when 'high' then 2
		when 'medium' then 3
		when 'low' then 4
	END;


--Which reviewer is the most thorough — highest change requests and comments?

select * from code_reviews
select * from contributors 

select c.full_name as Reviewer,count(cr.review_id) as total_reviewes ,
	SUM(CASE WHEN cr.outcome = 'changes_requested' then 1 else 0 end) as change_requests,
	SUM(cr.comments_count) as total_comments,
	ROUND(
			100.0 * SUM(CASE WHEN cr.outcome = 'changes_requested' then 1 else 0 end) / count(cr.review_id),1 ) as approval_rate_pct
from code_reviews cr 
join contributors c on cr.reviewer_id = c.contributor_id
group by c.full_name
order by total_comments DESC

--Which repository has the most unresolved issues right now? 

SELECT 
    r.repo_name,
    COUNT(i.issue_id) AS open_issues,
    SUM(CASE WHEN i.priority = 'critical' THEN 1 ELSE 0 END) AS critical_open,
    SUM(CASE WHEN i.priority = 'high'     THEN 1 ELSE 0 END) AS high_open,
    SUM(CASE WHEN i.priority = 'medium'   THEN 1 ELSE 0 END) AS medium_open
FROM issues i
JOIN repositories r ON i.repo_id = r.repo_id
WHERE i.status IN ('open', 'in_progress')
GROUP BY r.repo_name
ORDER BY open_issues DESC;

--What is the average time a PR stays open before being merged? 

SELECT 
    r.repo_name,
    ROUND(
        AVG(DATEDIFF(hour, pr.created_date, pr.merged_date)), 1
    ) AS avg_hours_to_merge
FROM pull_requests pr
JOIN repositories r ON pr.repo_id = r.repo_id
WHERE pr.status = 'merged'
GROUP BY r.repo_name
ORDER BY avg_hours_to_merge ASC;


--Who raised the most PRs and how many were merged?

SELECT 
    c.full_name,
    c.role,
    COUNT(pr.pr_id) AS total_prs_raised,
    SUM(CASE WHEN pr.status = 'merged' THEN 1 ELSE 0 END) AS merged,
    SUM(CASE WHEN pr.status = 'closed' THEN 1 ELSE 0 END) AS closed_unmerged,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN pr.status = 'merged' THEN 1 ELSE 0 END)
        / COUNT(pr.pr_id), 1
    ) AS DECIMAL (5,1)) as personal_merge_rate_pct
FROM contributors c
JOIN pull_requests pr ON c.contributor_id = pr.contributor_id
GROUP BY c.full_name, c.role
ORDER BY total_prs_raised DESC;