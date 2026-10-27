SELECT
    *,

    ROW_NUMBER() OVER (
        PARTITION BY account_id
        ORDER BY created_date, lead_id
    ) AS account_lead_rank

FROM {{ ref('int_marketing_leads') }}

WHERE disposition = 'accepted'