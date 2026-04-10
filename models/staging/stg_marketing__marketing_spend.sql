select date,
    paid_search_spend,
    paid_social_spend,
    display_spend,
    email_spend,
    affiliate_spend,
    tv_spend
from {{ source('marketing', 'marketing_spend') }}