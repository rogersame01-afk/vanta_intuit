
WITH opportunity_metrics AS (
    SELECT
        l.lead_id,

        COUNT(o.opportunity_id) AS opportunity_count,

        COALESCE(
            SUM(o.pipeline_usd),
            0
        ) AS pipeline_usd,

        COALESCE(
            SUM(
                CASE
                    WHEN o.stage = 'Closed Won'
                        THEN o.pipeline_usd
                    ELSE 0
                END
            ),
            0
        ) AS won_bookings_usd

    FROM {{ ref('int_valid_leads') }} l

    LEFT JOIN {{ ref('int_opp_status') }} o
        ON l.lead_id = o.lead_id
       AND o.disposition = 'accepted'
       AND l.score >= 70
       AND o.created_date >= l.created_date
       AND o.created_date <= DATEADD(
           day, 30, l.created_date
       )

    GROUP BY l.lead_id
),

usage_metrics AS (
    SELECT
        l.lead_id,

        COALESCE(
            SUM(b.net_revenue_usd),
            0
        ) AS revenue_30d_usd

    FROM {{ ref('int_valid_leads') }} l

    LEFT JOIN {{ ref('stg_billing') }} b
        ON l.account_id = b.account_id

       -- Assign account revenue to one lead only.
       AND l.account_lead_rank = 1

       -- Include the acquisition date.
       AND b.usage_date >= l.created_date

       -- Exclude day 30: this gives 30 calendar dates.
       AND b.usage_date < DATEADD(
           day, 30, l.created_date
       )

       AND b.usage_date <=
           CAST('{{ var("as_of") }}' AS DATE)

    GROUP BY l.lead_id
)

SELECT
    l.lead_id,
    l.account_id,
    l.campaign_id,
    l.created_date AS date,

    CASE
        WHEN l.score >= 70 THEN 1
        ELSE 0
    END AS is_mql,

    CASE
        WHEN l.score >= 70
         AND DATEADD(day, 30, l.created_date)
             <= CAST('{{ var("as_of") }}' AS DATE)
            THEN 1
        ELSE 0
    END AS is_mature_mql,

    CASE
        WHEN o.opportunity_count > 0 THEN 1
        ELSE 0
    END AS has_opportunity,

    o.opportunity_count,
    o.pipeline_usd,
    o.won_bookings_usd,

    CASE
        WHEN l.account_lead_rank = 1 THEN 1
        ELSE 0
    END AS is_acquired_account,

    u.revenue_30d_usd,

    CASE
        WHEN u.revenue_30d_usd > 0 THEN 1
        ELSE 0
    END AS is_paid_account

FROM {{ ref('int_valid_leads') }} l

INNER JOIN opportunity_metrics o
    ON l.lead_id = o.lead_id

INNER JOIN usage_metrics u
    ON l.lead_id = u.lead_id