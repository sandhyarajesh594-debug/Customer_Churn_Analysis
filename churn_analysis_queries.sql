-- ============================================================
-- Subscription Service Customer Churn Analysis
-- SQL Queries (MariaDB)
-- Database: churn_analysis | Table: customer_churn
-- ============================================================


-- ------------------------------------------------------------
-- 1. Overall churn rate
-- Business question: What percentage of all customers churned?
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_customers,
    SUM(Churn) AS total_churned,
    ROUND(AVG(Churn) * 100, 2) AS overall_churn_rate_pct
FROM customer_churn;


-- ------------------------------------------------------------
-- 2. Churn rate by subscription type
-- Business question: Does plan tier (Basic/Standard/Premium)
-- affect how likely a customer is to churn?
-- ------------------------------------------------------------
SELECT
    Subscription_Type,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    ROUND(AVG(Churn) * 100, 2) AS churn_rate_pct
FROM customer_churn
GROUP BY Subscription_Type
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 3. Churn rate by contract length
-- Business question: Are customers on shorter contracts
-- (Monthly) more likely to leave than longer ones (Annual)?
-- ------------------------------------------------------------
SELECT
    Contract_Length,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    ROUND(AVG(Churn) * 100, 2) AS churn_rate_pct
FROM customer_churn
GROUP BY Contract_Length
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 4. Average tenure: churned vs. retained customers
-- Business question: Do customers who churn tend to be newer
-- (lower tenure), suggesting an early "honeymoon churn" risk?
-- ------------------------------------------------------------
SELECT
    Churn,
    COUNT(*) AS total_customers,
    ROUND(AVG(Tenure), 2) AS avg_tenure
FROM customer_churn
GROUP BY Churn;


-- ------------------------------------------------------------
-- 5. Churn rate by payment delay bucket
-- Business question: Does churn risk climb steadily with
-- payment delay, or is there a sharp tipping point?
-- Real data range: 0 to 10 days delay.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN Payment_Delay = 0 THEN 'No Delay'
        WHEN Payment_Delay BETWEEN 1 AND 3 THEN 'Low Delay (1-3)'
        WHEN Payment_Delay BETWEEN 4 AND 6 THEN 'Medium Delay (4-6)'
        WHEN Payment_Delay BETWEEN 7 AND 10 THEN 'High Delay (7-10)'
        ELSE 'Unknown'
    END AS delay_group,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY delay_group
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 6. Churn rate by support call volume bucket
-- Business question: Do customers who contact support more
-- often churn more (frustration) or less (engagement)?
-- Real data range: 0 to 30 calls, average ~17.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN Support_Calls = 0 THEN 'No Calls'
        WHEN Support_Calls BETWEEN 1 AND 9 THEN 'Low (1-9)'
        WHEN Support_Calls BETWEEN 10 AND 19 THEN 'Medium (10-19)'
        ELSE 'High (20-30)'
    END AS support_group,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY support_group
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 7. Churn rate by age group
-- Business question: Is any particular age bracket more
-- likely to churn than others?
-- Note: raw Age is a number, so CASE WHEN is required to
-- bucket it into brackets -- grouping by raw Age directly
-- would create one row per individual age, not a real group.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    ROUND(SUM(Churn) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY age_group
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- 8. Average days since last interaction: churned vs. retained
-- Business question: Do customers "go quiet" (longer gap since
-- their last activity) before they churn?
-- ------------------------------------------------------------
SELECT
    Churn,
    COUNT(*) AS total_customers,
    ROUND(AVG(Last_Interaction), 2) AS avg_last_interaction
FROM customer_churn
GROUP BY Churn;


-- ------------------------------------------------------------
-- 9. Top 20% highest-spending customers who churned
-- Business question: Did we lose our most valuable customers,
-- not just low-value ones?
-- Method: rank all customers by spend, take the top 20% as a
-- subquery, then count how many of THOSE churned. A plain
-- WHERE Churn = 1 + LIMIT would answer a different question
-- (top spenders among only churned customers), so the ranking
-- must happen first, before filtering.
-- ------------------------------------------------------------
SELECT COUNT(*) AS churned_high_value_customers
FROM (
    SELECT Customer_ID, Total_Spend, Churn
    FROM customer_churn
    ORDER BY Total_Spend DESC
    LIMIT 12875  -- top 20% of 64,374 total customers
) AS top_20_percent
WHERE Churn = 1;


-- ------------------------------------------------------------
-- 10. Total revenue lost to churn
-- Business question: What is the financial impact of churn,
-- in total lost customer spend?
-- ------------------------------------------------------------
SELECT SUM(Total_Spend) AS revenue_lost_to_churn
FROM customer_churn
WHERE Churn = 1;
