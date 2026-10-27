SELECT
    'lead_account' AS relationship,
    l.lead_id AS record_id
FROM {{ ref('fct_lead') }} l
LEFT JOIN {{ ref('dim_account') }} a
    ON l.account_id = a.account_id
WHERE a.account_id IS NULL

UNION ALL

SELECT
    'lead_campaign',
    l.lead_id
FROM {{ ref('fct_lead') }} l
LEFT JOIN {{ ref('dim_campaign') }} c
    ON l.campaign_id = c.campaign_id
WHERE c.campaign_id IS NULL

UNION ALL

SELECT
    'spend_campaign',
    s.spend_id
FROM {{ ref('fct_spend') }} s
LEFT JOIN {{ ref('dim_campaign') }} c
    ON s.campaign_id = c.campaign_id
WHERE c.campaign_id IS NULL

UNION ALL

SELECT
    'lead_date',
    l.lead_id
FROM {{ ref('fct_lead') }} l
LEFT JOIN {{ ref('dim_date') }} d
    ON l.date = d.date
WHERE d.date IS NULL

UNION ALL

SELECT
    'spend_date',
    s.spend_id
FROM {{ ref('fct_spend') }} s
LEFT JOIN {{ ref('dim_date') }} d
    ON s.date = d.date
WHERE d.date IS NULL