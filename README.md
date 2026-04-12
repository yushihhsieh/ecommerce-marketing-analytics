## Project Background
An e-commerce company has been running marketing campaigns across multiple channels. The business aims to understand which channels drive the most revenue, how marketing efficiency varies across channels and how to optimize budget allocation to maximize return on ad spend (ROAS).

This project applied an **end-to-end analytics engineering** workflow using:
- **Google BigQuery** for data storage
- **dbt** for data transformation
- **Looker Studio** for data visualization

Insights and recommendations are provided on the following key areas:
- **Exploratory Analysis:** Summary statistics of revenue, spend and transactions. Temporal trends (monthly, weekly, seasonal patterns). 
- **Channel Performance:** ROAS calculation using 7-day, 14-day, and 30-day attribution windows. Top and bottom performing channels based on total revenue contribution and marketing efficiency. Performance breakdown by time and promotional periods
- **Budget Optimization:** Spending patterns and variability. Efficiency curve using spend deciles to detect diminishing returns. Budget reallocation strategy based on channel efficiency and expected revenue uplift. 

The SQL queries used to inspect and clean the data for this analysis can be found here [link](https://github.com/yushihhsieh/ecommerce-marketing-analytics/tree/c0268da970caec0f671c15b513b5152d8f0232d7/models/staging).

Targeted SQL queries regarding various business questions can be found here [link](https://github.com/yushihhsieh/ecommerce-marketing-analytics/tree/c0268da970caec0f671c15b513b5152d8f0232d7/models/marts).

An interactive dashboard used to report and explore sales trends can be found here [link](https://lookerstudio.google.com/s/hyPDRon2-Fg).

## Data Structure & Initial Checks
The company's main database structure as seen below consists of three tables: marketing_spend, revenue, external_table, with a total row count of 730 records. 

The project uses three core datasets: 
- **marketing_spend** → daily spend by channel
- **revenue** → daily revenue and transactions
- **external_factors** → contextual features

Prior to beginning the analysis, a variety of checks were conducted for missing/null value validation, date continuity checks and outlier detection. The SQL queries used to inspect and perform quality checks can be found [not_null_and_unique](https://github.com/yushihhsieh/ecommerce-marketing-analytics/blob/c0268da970caec0f671c15b513b5152d8f0232d7/models/staging/_src_marketing.yml), [date_gap](https://github.com/yushihhsieh/ecommerce-marketing-analytics/blob/c0268da970caec0f671c15b513b5152d8f0232d7/tests/assert_date_gaps_for_marketing.sql).

The **transformation** follows a layered approach in **dbt**:
- **Staging**: data cleaning and standardization
- **Intermediate**: metric calculations and joins
- **Marts**: business-level models (fct tables)

<img width="1373" height="459" alt="Screenshot 2026-04-12 at 17 48 22" src="https://github.com/user-attachments/assets/e82922cd-671d-4256-b1d7-6ad8551cbb49" />



# Executive Summary

## Overview of Findings
- All channels consistently deliver strong ROAS.
- TV and Email exhibit high spend variability, indicating unstable budget allocation.
- Efficiency curves reveal diminishing returns across all channels, with ROAS peaking at mid-to-high spend levels and declining at the highest spend levels.
- Reallocating budget toward high-efficiency channels such as Display and Email can significantly increase revenue.

Below is the overview page from the dashboard and more examples are included throughout the report. The entire interactive dashboard can be downloaded [here](https://lookerstudio.google.com/s/rxmZ-KoUJf4).

<img width="1075" height="472" alt="Screenshot 2026-04-12 at 18 35 18" src="https://github.com/user-attachments/assets/fce896a9-c2b5-4587-9c1f-288485923230" />



## Exploratory Analysis:
- **Stable spend vs variable revenue:** Spend remains relatively stable across the period with occasional spikes driven by campaign activity. Revenue does not consistently scale with spend, indicating varying efficiency over time.
- **Temporal performance variability:** Despite stable spend distribution (most days between 10K-11.7K), performance varies significantly across time. Highlighting strong temporal effects such as seasonality and promotions.
- **Day-of-week patterns:** Clear performance differences between weekdays and weekends, indicating user behavior shifts depending on time of week.

<img width="1076" height="605" alt="Screenshot 2026-04-12 at 18 35 51" src="https://github.com/user-attachments/assets/c7c221c5-a1f5-41c6-b17e-20a5d6b2dd14" />



## Channel Performance:
- **Short-term vs long-term performance divergence:** Short-term performance underestimates true channel value, which could lead to underinvestment if only 7-day metrics are used.
- **High spend ≠ high efficiency:** Channels with the highest spend do not consistently deliver the highest ROAS.
- **Top and bottom performing channels:** Paid Social generates the highest total attributed revenue (30-day), however, email contributes less to overall revenue.
- **Performance sensitivity to external factors:** Channel efficiency varies across: promotional vs non-promotional periods and weekend vs weekday.

<img width="1075" height="608" alt="Screenshot 2026-04-12 at 18 36 15" src="https://github.com/user-attachments/assets/b402578b-6d49-43f9-8bb6-77e1e5337151" />



## Budget Optimization:
- **Spending Patterns:** Paid Social has the most consistent spend (CV ~0.129), while TV shows the highest variability (CV ~0.131).
- **Efficiency curves:** Efficiency curves reveal diminishing returns across channels, with peak ROAS occurring at mid-level spend ranges rather than at maximum investment levels.
- **Budget Reallocation:** Reallocate budget from over-invested channels such as Paid Search and Paid Social toward higher-efficiency channels like Display and Email.

<img width="1067" height="598" alt="Screenshot 2026-04-12 at 18 36 39" src="https://github.com/user-attachments/assets/102ee2b0-0586-410b-bd9d-e13bad98e445" />



## Recommendations
Based on the insights and findings above, we would recommend the marketing team to consider the following:
- **Reallocate budget based on efficiency curves:** Shift spending from over-invested channels (Paid Search, Paid Social) to high-efficiency, underfunded channels (Display, Email).
- **Use long-term attribution metrics:** prioritize 30-day ROAS when evaluating channel performance, as short-term metrics (7-day) underestimate true value.
- **Leverage temporal patterns:** adjust budget for weekends, promotions, and seasonal trends to capture maximum efficiency.

## Assumptions and Caveats
Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:
- **Assumption 1: Attribution Model**
Revenue is allocated proportionally based on spend share. This assumes all channels contribute linearly to conversions.
- **Assumption 2: No Organic/Direct Channel**
Only paid channels are included in attribution. Total revenue may include non-marketing effects.



