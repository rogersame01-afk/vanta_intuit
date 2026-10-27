--The tests cover both table structure and important business assumptions.
{{ config(severity='error', store_failures=true) }}

SELECT *
FROM {{ ref('fct_lead') }}

WHERE is_mql IS NULL
   OR is_mql NOT IN (0, 1)

   OR is_mature_mql IS NULL
   OR is_mature_mql NOT IN (0, 1)

   OR has_opportunity IS NULL
   OR has_opportunity NOT IN (0, 1)

   OR is_acquired_account IS NULL
   OR is_acquired_account NOT IN (0, 1)

   OR is_paid_account IS NULL
   OR is_paid_account NOT IN (0, 1)

   OR is_mature_mql > is_mql
   OR has_opportunity > is_mql
   OR is_paid_account > is_acquired_account