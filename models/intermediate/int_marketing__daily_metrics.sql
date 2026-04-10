WITH spend AS (
    SELECT date,
        SUM(spend) AS total_spend
    FROM {{ ref('int_marketing__marketing_spend_pivoted') }}
    GROUP BY date

), revenue AS (
    SELECT date,
        revenue,
        transactions,
        new_customers
    FROM {{ ref('stg_marketing__revenue') }}

), joined AS (
    SELECT s.date,
        s.total_spend,
        r.revenue,
        r.transactions,
        r.new_customers
    FROM spend s
    LEFT JOIN revenue r
        ON s.date = r.date

)
    SELECT *
    FROM joined