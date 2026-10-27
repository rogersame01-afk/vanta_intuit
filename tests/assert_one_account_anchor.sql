{{ config(severity='error', store_failures=true) }}
SELECT
    account_id

FROM {{ ref('fct_lead') }}

GROUP BY account_id

HAVING SUM(is_acquired_account) <> 1