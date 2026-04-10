WITH base AS (
    SELECT channel,
        SUM(spend) AS current_spend,
        SUM(attributed_revenue_30d) AS current_revenue
    FROM {{ ref('fct_marketing__channel_performance') }}
    GROUP BY channel

), optimization AS (
    SELECT channel,
        optimized_spend,
        expected_revenue
    FROM {{ ref('fct_marketing__budget_optimization') }}

), final AS (
    SELECT b.channel,

        -- Current state
        b.current_spend,
        b.current_revenue,
        SAFE_DIVIDE(b.current_revenue, b.current_spend) AS current_roas,

        -- Optimized state
        o.optimized_spend,
        o.expected_revenue,
        SAFE_DIVIDE(o.expected_revenue, o.optimized_spend) AS optimized_roas,

        -- Changes
        o.optimized_spend - b.current_spend AS spend_change,
        SAFE_DIVIDE(o.optimized_spend - b.current_spend, b.current_spend) AS spend_change_pct,

        -- Impact
        o.expected_revenue - b.current_revenue AS revenue_uplift
    FROM base b
    LEFT JOIN optimization o
        ON b.channel = o.channel

)
    SELECT *
    FROM final