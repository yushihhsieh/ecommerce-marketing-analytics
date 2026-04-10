WITH base AS (
    SELECT channel,
        spend,
        roas_30d
    FROM {{ ref('fct_marketing__channel_performance') }}

), deciles AS (
    SELECT *,
        NTILE(10) OVER (PARTITION BY channel ORDER BY spend) AS spend_decile
    FROM base

), aggregated AS (
    SELECT channel,
        spend_decile,
        AVG(spend) AS avg_spend,
        AVG(roas_30d) AS avg_roas
    FROM deciles
    GROUP BY channel, spend_decile

)
    SELECT *
    FROM aggregated