-- Identify any date gaps in the marketing data.
-- Using LAG() window function to get the previous date; if date gap > 1 then there is a date gap.
WITH UNIONED AS (
    SELECT date,
        'marketing_spend' AS table_name
    FROM {{ source('marketing', 'marketing_spend') }}

    UNION ALL
    
    SELECT date,
        'revenue' AS table_name
    FROM {{ source('marketing', 'revenue') }}
    
    UNION ALL
    
    SELECT date,
        'external_factors' AS table_name
    FROM {{ source('marketing', 'external_factors') }}

), date_gaps as (
    SELECT date,
        table_name,
        LAG(date) OVER (PARTITION BY table_name ORDER BY date) AS prev_date,
        DATE_DIFF(date, LAG(date) OVER (PARTITION BY table_name ORDER BY date), DAY) AS date_diff
    FROM UNIONED
)
-- Missing 2023-10-29 and 2024-10-27 in three tabels.
	SELECT *
	FROM date_gaps
	WHERE date_diff > 1