
SELECT
    CAST(rate_date AS DATE) AS rate_date,
    UPPER(TRIM(CAST(currency AS VARCHAR))) AS currency,
    CAST(usd_per_local AS NUMBER(18, 8)) AS usd_per_local

FROM {{ source('finance', 'FX') }}