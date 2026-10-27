{{ config(severity='error', store_failures=true) }}

SELECT *
FROM {{ ref('fct_spend') }}

WHERE spend_usd IS NULL
   OR spend_usd < 0
   OR impressions IS NULL
   OR impressions < 0
   OR clicks IS NULL
   OR clicks < 0