WITH spend AS (
    SELECT *
    FROM {{ ref('int_marketing__marketing_spend_pivoted') }}

), revenue AS (
    SELECT *
    FROM {{ ref('int_marketing__daily_metrics') }}

), external AS (
    SELECT *
    FROM {{ ref('stg_marketing__external_factors') }}

), joined AS (
    SELECT s.date,
        s.channel,
        s.spend,
        r.revenue,
        r.transactions,
        r.new_customers,
        SUM(s.spend) OVER (PARTITION BY s.date) AS total_spend,
        e.is_weekend,
        e.is_holiday,
        e.promotion_active,
        e.competitor_index,
        e.seasonality_index
    FROM spend s
    LEFT JOIN revenue r
        ON s.date = r.date   
    LEFT JOIN external e
        ON s.date = e.date

), windowed AS (
    SELECT date,
        channel,
        spend,
        total_spend,
        transactions,
        new_customers,
        revenue,
        SUM(revenue) OVER (ORDER BY date ROWS BETWEEN CURRENT ROW AND 6 FOLLOWING) AS revenue_7d,
        SUM(revenue) OVER (ORDER BY date ROWS BETWEEN CURRENT ROW AND 13 FOLLOWING) AS revenue_14d,
        SUM(revenue) OVER (ORDER BY date ROWS BETWEEN CURRENT ROW AND 29 FOLLOWING) AS revenue_30d,
        is_weekend,
        is_holiday,
        promotion_active,
        competitor_index,
        seasonality_index
    FROM joined

), allocation AS (
    SELECT date,
        channel,
        spend,

        -- Spend share per channel
        SAFE_DIVIDE(spend, total_spend) AS spend_share,

        -- Allocate transactions
        SAFE_DIVIDE(spend, total_spend) * transactions AS allocated_transactions,

        -- Allocate new customers
        SAFE_DIVIDE(spend, total_spend) * new_customers AS allocated_new_customers,

        -- Allocate windowed revenue
        SAFE_DIVIDE(spend, total_spend) * revenue AS allocated_revenue,
        SAFE_DIVIDE(spend, total_spend) * revenue_7d AS attributed_revenue_7d,
        SAFE_DIVIDE(spend, total_spend) * revenue_14d AS attributed_revenue_14d,
        SAFE_DIVIDE(spend, total_spend) * revenue_30d AS attributed_revenue_30d,

        -- ROAS
        SAFE_DIVIDE(SAFE_DIVIDE(spend, total_spend) * revenue_7d, spend) AS roas_7d,
        SAFE_DIVIDE(SAFE_DIVIDE(spend, total_spend) * revenue_14d, spend) AS roas_14d,
        SAFE_DIVIDE(SAFE_DIVIDE(spend, total_spend) * revenue_30d, spend) AS roas_30d,

        is_weekend,
        is_holiday,
        promotion_active,
        competitor_index,
        seasonality_index
    FROM windowed

), final AS (
    SELECT date,
        channel,
        spend,
        allocated_transactions,
        allocated_new_customers,
        allocated_revenue,
        attributed_revenue_7d,
        attributed_revenue_14d,
        attributed_revenue_30d,
        roas_7d,
        roas_14d,
        roas_30d,
        is_weekend,
        is_holiday,
        promotion_active,
        competitor_index,
        seasonality_index        
    FROM allocation

)
    SELECT *
    FROM final