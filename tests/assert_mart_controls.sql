SELECT 'fixture_total_mismatch' AS failure

WHERE
    (SELECT COUNT(*) FROM {{ ref('fct_lead') }}) <> 236

    OR
    (SELECT COUNT(*) FROM {{ ref('fct_spend') }}) <> 531

    OR
    (SELECT SUM(is_mql) FROM {{ ref('fct_lead') }}) <> 111

    OR
    (SELECT SUM(has_opportunity) FROM {{ ref('fct_lead') }}) <> 39

    OR
    ABS(
        (SELECT SUM(spend_usd) FROM {{ ref('fct_spend') }})
        - 57539.00
    ) > 0.01

    OR
    ABS(
        (SELECT SUM(pipeline_usd) FROM {{ ref('fct_lead') }})
        - 1186000.00
    ) > 0.01

    OR
    ABS(
        (SELECT SUM(revenue_30d_usd) FROM {{ ref('fct_lead') }})
        - 29541.18
    ) > 0.01