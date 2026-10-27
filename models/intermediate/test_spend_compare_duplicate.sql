SELECT
    spend_id,
    COUNT(*) AS row_count
FROM {{ ref('stg_spend_compare') }}
GROUP BY spend_id
HAVING COUNT(*) > 1