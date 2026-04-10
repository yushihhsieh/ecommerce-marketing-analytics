select date,
    revenue.revenue,
    transactions,
    new_customers
from {{ source('marketing', 'revenue') }}