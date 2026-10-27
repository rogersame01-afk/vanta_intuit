{{ config(severity='error', store_failures=true) }}
SELECT
    rate_date,
    currency

FROM {{ ref('stg_fx') }}

GROUP BY rate_date, currency

HAVING COUNT(*) > 1