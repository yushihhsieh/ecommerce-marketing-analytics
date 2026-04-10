WITH base AS (
    SELECT *
    FROM {{ ref('fct_marketing__channel_performance') }}

), stats AS (
    SELECT channel,
        AVG(spend) AS avg_spend,
        STDDEV(spend) AS stddev_spend,
        SAFE_DIVIDE(STDDEV(spend), AVG(spend)) AS cv_spend  -- coefficient of variation
    FROM base
    GROUP BY channel

)
    SELECT *
    FROM stats