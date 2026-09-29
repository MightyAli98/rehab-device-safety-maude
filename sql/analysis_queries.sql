-- Rehab device safety (FDA MAUDE 2016–2026): key analysis queries
-- Database: data/clean (tables: reports, patient_problems, device_problems, narratives)

-- 1. Severity profile per device group
SELECT device_group,
       COUNT(*)                                          AS reports,
       ROUND(100.0 * SUM(serious_outcome) / COUNT(*), 1) AS serious_pct,
       ROUND(100.0 * SUM(severe_outcome)  / COUNT(*), 1) AS severe_pct,
       ROUND(100.0 * SUM(home_or_lay_use) / COUNT(*), 1) AS home_or_lay_use_pct
FROM reports
GROUP BY device_group
ORDER BY severe_pct DESC;

-- 2. Top 5 real patient harms per device group, as % of the group's reports
WITH counts AS (
    SELECT device_group, patient_problem,
           COUNT(DISTINCT MDR_REPORT_KEY) AS n
    FROM patient_problems
    WHERE patient_problem NOT LIKE 'No Clinical Signs%'
      AND patient_problem NOT LIKE 'No Known Impact%'
      AND patient_problem NOT LIKE 'No Consequences%'
      AND patient_problem NOT LIKE 'No Patient Involvement%'
      AND patient_problem NOT LIKE 'No Information%'
      AND patient_problem NOT LIKE 'Insufficient Information%'
    GROUP BY device_group, patient_problem
),
ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY device_group ORDER BY n DESC) AS rank
    FROM counts
),
totals AS (
    SELECT device_group, COUNT(*) AS total FROM reports GROUP BY device_group
)
SELECT r.device_group, r.rank, r.patient_problem, r.n AS reports,
       ROUND(100.0 * r.n / t.total, 1) AS pct_of_device_reports
FROM ranked r
JOIN totals t ON r.device_group = t.device_group
WHERE r.rank <= 5
ORDER BY r.device_group, r.rank;

-- 3. Report concentration by manufacturer within each device group
SELECT device_group, manufacturer,
       COUNT(*) AS reports,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY device_group), 1) AS share_pct
FROM reports
GROUP BY device_group, manufacturer
ORDER BY device_group, reports DESC;
