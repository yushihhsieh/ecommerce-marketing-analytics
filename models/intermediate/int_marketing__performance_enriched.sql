WITH base AS (
    SELECT *
    FROM {{ ref('int_marketing__daily_metrics') }}

), external AS (
    SELECT date,
        is_weekend,
        is_holiday,
        promotion_active,
        competitor_index,
        seasonality_index
    FROM {{ ref('stg_marketing__external_factors') }}

), joined AS (
    SELECT b.date,
        b.total_spend,
        b.revenue,
        b.transactions,
        b.new_customers,
        e.is_weekend,
        e.is_holiday,
        e.promotion_active,
        e.competitor_index,
        e.seasonality_index
    FROM base b
    LEFT JOIN external e
        ON b.date = e.date

), metrics AS (
    SELECT *,
        -- Core KPIs
        SAFE_DIVIDE(revenue, total_spend) AS roas,
        SAFE_DIVIDE(total_spend, transactions) AS cpa,
        SAFE_DIVIDE(total_spend, new_customers) AS cac
    FROM joined

)
    SELECT *
    FROM metrics