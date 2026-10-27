{{ config(materialized='view') }}

SELECT
    s.*,
    f.usd_per_local,

    CASE
        WHEN c.campaign_id IS NULL
            THEN 'orphan_campaign'

        WHEN s.spend_date IS NULL
          OR s.spend_date < '2026-01-01'::DATE
          OR s.spend_date > '2026-02-28'::DATE
            THEN 'outside_cohort'

        WHEN s.spend_local IS NULL
            THEN 'missing_spend'

        WHEN s.spend_local < 0
            THEN 'negative_spend'

        WHEN f.usd_per_local IS NULL
            THEN 'missing_fx'

        WHEN f.usd_per_local <= 0
            THEN 'invalid_fx'

        ELSE 'accepted'
    END AS disposition

FROM {{ ref('int_spend_compare') }} s

LEFT JOIN {{ ref('dim_campaign') }} c
    ON s.campaign_id = c.campaign_id

LEFT JOIN {{ ref('stg_fx') }} f
    ON s.spend_date = f.rate_date
   AND s.currency = f.currency