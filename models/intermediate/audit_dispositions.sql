--Explain why some source records do not reach the dashboard.
{{ config(materialized='table') }}

SELECT
    'lead' AS entity,
    disposition,
    COUNT(*) AS row_count

FROM {{ ref('int_valid_leads') }}

GROUP BY disposition

UNION ALL

SELECT
    'opportunity',
    disposition,
    COUNT(*)

FROM {{ ref('int_opp_status') }}

GROUP BY disposition

UNION ALL

SELECT
    'spend',
    disposition,
    COUNT(*)

FROM {{ ref('int_spend_status') }}

GROUP BY disposition