 WITH current_leads as (
    Select 
    * 
    from {{ ref('int_leads_current') }} 
 )


SELECT
    l.*,

    CASE
        WHEN a.account_id IS NULL
            THEN 'orphan_account'

        WHEN c.campaign_id IS NULL
            THEN 'orphan_campaign'

        WHEN a.country IS NULL
          OR c.country IS NULL
          OR a.country <> c.country
            THEN 'country_mismatch'

        WHEN a.employee_count IS NULL
          OR a.employee_count < 1
          OR a.employee_count > 499
            THEN 'outside_smb'

        WHEN l.is_test IS NULL
          OR l.is_test <> 0
            THEN 'test_or_invalid_flag'

        WHEN l.created_date IS NULL
          OR l.created_date < '2026-01-01'::DATE
          OR l.created_date > '2026-02-28'::DATE
            THEN 'outside_cohort'

        ELSE 'accepted'
    END AS disposition

FROM current_leads l

LEFT JOIN {{ ref('dim_account') }} a
    ON l.account_id = a.account_id

LEFT JOIN {{ ref('dim_campaign') }} c
    ON l.campaign_id = c.campaign_id