{{ config(severity='error', store_failures=true) }}

WITH source_spend AS (
    SELECT
        CAST(spend_id AS VARCHAR) AS spend_id,
        CAST(campaign_id AS VARCHAR) AS campaign_id,
        CAST(spend_date AS DATE) AS spend_date,
        UPPER(TRIM(currency::VARCHAR)) AS currency,
        CAST(spend_local AS NUMBER(18, 2)) AS spend_local,
        CAST(loaded_date AS DATE) AS loaded_date,
        CAST(version AS INTEGER) AS version

    FROM {{ source('advertising', 'SPEND') }}
),

latest_available AS (
    SELECT *
    FROM source_spend

    WHERE loaded_date <= CAST('{{ var("as_of") }}' AS DATE)

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY spend_id
        ORDER BY version DESC, loaded_date DESC
    ) = 1
),

expected AS (
    SELECT
        s.campaign_id,
        COUNT(*) AS expected_rows,

        SUM(
            ROUND(
                s.spend_local
                * CAST(f.usd_per_local AS NUMBER(18, 8)),
                2
            )
        ) AS expected_spend_usd

    FROM latest_available s

    INNER JOIN {{ source('salesforce', 'CAMPAIGNS') }} c
        ON s.campaign_id = c.campaign_id

    INNER JOIN {{ source('finance', 'FX') }} f
        ON s.spend_date = CAST(f.rate_date AS DATE)
       AND s.currency = UPPER(TRIM(f.currency::VARCHAR))

    WHERE s.spend_local >= 0
      AND CAST(f.usd_per_local AS NUMBER(18, 8)) > 0
      AND s.spend_date BETWEEN
          '2026-01-01'::DATE AND '2026-02-28'::DATE

    GROUP BY s.campaign_id
),

actual AS (
    SELECT
        campaign_id,
        COUNT(*) AS actual_rows,
        SUM(spend_usd) AS actual_spend_usd

    FROM {{ ref('fct_spend') }}

    GROUP BY campaign_id
)

SELECT
    COALESCE(e.campaign_id, a.campaign_id) AS campaign_id,
    e.expected_rows,
    a.actual_rows,
    e.expected_spend_usd,
    a.actual_spend_usd

FROM expected e

FULL OUTER JOIN actual a
    ON e.campaign_id = a.campaign_id

WHERE COALESCE(e.expected_rows, 0)
          <> COALESCE(a.actual_rows, 0)

   OR ABS(
        COALESCE(e.expected_spend_usd, 0)
        - COALESCE(a.actual_spend_usd, 0)
   ) > 0.01