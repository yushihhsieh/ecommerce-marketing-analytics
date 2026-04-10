select date,
    is_weekend,
    is_holiday,
    promotion_active,
    competitor_index,
    seasonality_index
from {{ source('marketing', 'external_factors') }}