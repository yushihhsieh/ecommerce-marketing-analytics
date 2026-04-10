WITH source AS (
    SELECT *
    FROM {{ ref('stg_marketing__marketing_spend') }}

), unpivoted AS (
    SELECT date,
        channel,
        spend
    FROM source
    UNPIVOT (
        spend FOR channel IN (
            paid_search_spend,
            paid_social_spend,
            display_spend,
            email_spend,
            affiliate_spend,
            tv_spend
        )
    )

), cleaned AS (
    SELECT date,
        -- Clean channel names
        REPLACE(channel, '_spend', '') AS channel,
        spend
    FROM unpivoted

)
    SELECT *
    FROM cleaned