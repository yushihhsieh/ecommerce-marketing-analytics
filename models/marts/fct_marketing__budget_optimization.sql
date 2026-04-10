WITH base AS (
    SELECT *
    FROM {{ ref('int_marketing__channel_efficiency') }}

), totals AS (
    SELECT SUM(total_spend) AS total_budget
    FROM base

), scored AS (
    SELECT *,   
        -- Normalize ROAS into weights
        avg_roas_30d / SUM(avg_roas_30d) OVER () AS performance_weight
    FROM base

), bounded AS (
    SELECT *,      
        -- Apply constraints
        CASE
            WHEN performance_weight > 0.4 THEN 0.4   -- cap max allocation
            WHEN performance_weight < 0.05 THEN 0.05 -- minimum allocation
            ELSE performance_weight
        END AS bounded_weight
    FROM scored

), normalized AS (
    SELECT *,
        SUM(bounded_weight) OVER () AS total_weight
    FROM bounded

), final AS (
    SELECT n.channel,
        n.total_spend AS current_spend,
        n.avg_roas_30d,
        t.total_budget,

        -- Final optimized allocation
        (n.bounded_weight / n.total_weight) * t.total_budget AS optimized_spend,

        -- Expected revenue
        (n.bounded_weight / n.total_weight) * t.total_budget * n.avg_roas_30d AS expected_revenue,

        -- Change %
        SAFE_DIVIDE(
            ((n.bounded_weight / n.total_weight) * t.total_budget - n.total_spend),
            n.total_spend
        ) AS spend_change_pct
    FROM normalized n
    CROSS JOIN totals t

)
    SELECT *
    FROM final