WITH base AS (
    SELECT *
    FROM {{ ref('fct_marketing__channel_performance') }}

), aggregated AS (
    SELECT channel,
        AVG(roas_7d) AS avg_roas_7d,
        AVG(roas_14d) AS avg_roas_14d,
        AVG(roas_30d) AS avg_roas_30d,
        SUM(spend) AS total_spend,
        SUM(attributed_revenue_30d) AS total_revenue_30d
    FROM base
    GROUP BY channel

)
    SELECT *
    FROM aggregated