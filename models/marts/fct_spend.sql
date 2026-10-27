{{ config(materialized='table') }}

SELECT
    spend_id,
    campaign_id,
    spend_date AS date,

    CAST(
        ROUND(spend_local * usd_per_local, 2)
        AS NUMBER(18, 2)
    ) AS spend_usd,

    impressions,
    clicks

FROM {{ ref('int_spend_status') }}

WHERE disposition = 'accepted'