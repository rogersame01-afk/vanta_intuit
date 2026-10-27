
SELECT
    o.opportunity_id,
    o.lead_id,
    o.created_date,
    o.stage,
    o.pipeline_usd,
    o.loaded_date,
    o.version,

    CASE
        WHEN l.lead_id IS NULL
            THEN 'ineligible_lead'

        WHEN o.created_date IS NULL
            THEN 'missing_opportunity_date'

        WHEN o.created_date < l.created_date
            THEN 'before_lead'

        WHEN o.created_date >
             CAST('{{ var("as_of") }}' AS DATE)
            THEN 'future_opportunity'

        ELSE 'accepted'
    END AS disposition

FROM {{ ref('stg_opportunities') }} o

LEFT JOIN {{ ref('int_valid_leads') }} l
    ON o.lead_id = l.lead_id