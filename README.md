# Subscription Service Customer Churn Analysis

## Project Overview
This project analyzes customer churn for a subscription-based service, using behavioral and account data (tenure, support interactions, payment history, usage patterns, contract terms) to identify the factors most strongly associated with customer attrition. The goal was to move beyond simply reporting *how many* customers churned, and instead identify *why* — and what the business could do about it.

**Dataset:** 64,374 customer records, including demographics, subscription details, support activity, and churn status (churned vs. retained).
**Source:** Public Kaggle dataset (customer churn / subscription behavior).

## Tools Used
- **SQL (MariaDB)** — data cleaning, exploratory analysis, hypothesis testing (aggregate functions, GROUP BY/HAVING, JOINs, CASE WHEN bucketing, subqueries)
- **Excel** — dashboard visualization, pivot tables, KPI cards, charts

## Headline Numbers
| Metric | Value |
|---|---|
| Total Customers | 64,374 |
| Total Churned | 30,493 |
| Overall Churn Rate | **47.37%** |
| Revenue Lost to Churn | **₹1,58,36,117** |

Nearly 1 in 2 customers in this dataset churned — a rate most subscription businesses would consider a serious, urgent problem worth investigating at the root-cause level.

## Key Findings

### 1. Support Calls Are the Strongest Churn Predictor
Customers making 20–30 support calls churned at **75.26%**, compared to just **10.11%** for those with fewer than 10 calls — a **7x difference**.

This suggests that customers experiencing repeated, unresolved issues eventually disengage rather than staying with the service. It's a strong enough pattern to treat support call volume as an early-warning signal, not just routine service activity — though it's worth noting this is a correlation, not a confirmed cause; the data doesn't tell us directly *why* the calls went unresolved.

**Recommendation:** Flag customers crossing 10+ support calls for priority escalation and root-cause resolution, rather than standard queue handling.

### 2. Payment Delay Has a Tipping Point, Not a Gradual Effect
Churn stays roughly flat around **24%** for payment delays of 0–3 days, but more than doubles to **55–61%** once delays reach 4+ days.

This is a threshold effect rather than a steady climb — it suggests there's a specific point where a customer shifts from "temporarily late" to "actively disengaging," rather than a slow erosion of loyalty. Because the risk jumps so sharply and so early, timing matters more than the delay amount itself.

**Recommendation:** Trigger automated outreach (reminder, call, or grace-period offer) right at day 4 of payment delay — before the customer crosses into high-risk territory. Waiting until day 7–10 means acting after most of the damage is done.

### 3. Contract Length Has Only a Mild Effect
Churn rate ranges narrowly from **44.04%** (Quarterly) to **51.61%** (Monthly), with Annual sitting in between at **46.21%**.

This is a real but modest difference — Monthly contracts do churn somewhat more than Quarterly or Annual, which makes intuitive sense (less commitment = easier to leave), but it's nowhere near as strong a signal as payment delay or support calls.

**Recommendation:** Contract length alone isn't a major lever for reducing churn; resources are better spent addressing support quality and payment friction first.

### 4. Subscription Type Shows No Meaningful Difference
Churn rate across Basic (48.28%), Standard (47.33%), and Premium (46.50%) plans varies by less than 2 percentage points.

This is a valid, honest finding on its own — not every variable needs to show a dramatic story. It tells the business that subscription tier alone is not a strong driver of churn in this dataset; the real drivers lie elsewhere (support experience, payment behavior).

## Business Recommendations
1. **Set a day-4 payment-delay trigger** for proactive customer outreach, since churn risk jumps sharply at that threshold.
2. **Flag customers at 10+ support calls** for priority escalation rather than standard queue handling.
3. **Don't prioritize subscription-tier or contract-length changes** as churn-reduction levers — the data shows these have little to no effect compared to support and payment behavior.
4. **Quantify the cost of inaction:** churn is currently costing an estimated ₹1,58,36,117 in lost revenue — addressing the top two drivers above represents the clearest path to reducing this loss.

## Dashboard




## SQL Queries
All queries used in this analysis are available in [`churn_analysis_queries.sql`](./churn_analysis_queries.sql), with comments explaining the business question each one answers.

## Methodology Note
Two findings — subscription type and contract length — showed flat or only mild variation. This was treated as a genuine result rather than a charting issue: these are unordered categories (no inherent "more" or "less" between them), unlike payment delay and support calls, which are ordered numeric buckets where a rising trend is meaningful. Distinguishing a real flat result from a weak analysis is itself part of the finding.
