WITH base AS (
    SELECT *
    FROM {{ ref('int_marketing__performance_enriched') }}

), final AS (
    SELECT date,
        
        -- Core metrics
        total_spend,
        revenue,
        transactions,
        new_customers,

        -- Efficiency metrics
        roas,
        cpa,
        cac,

        -- External factors
        is_weekend,
        is_holiday,
        promotion_active,
        competitor_index,
        seasonality_index,
        
        -- Derived metrics
        SAFE_DIVIDE(revenue, transactions) AS revenue_per_transaction,
        SAFE_DIVIDE(revenue, new_customers) AS revenue_per_customer
    FROM base

)
    SELECT *
    FROM final