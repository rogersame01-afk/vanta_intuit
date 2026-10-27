    SELECT
        CAST(spend_id AS VARCHAR) AS spend_id,
        CAST(spend_date AS DATE) AS spend_date,
        CAST(campaign_id AS VARCHAR) AS campaign_id,
        UPPER(TRIM(CAST(currency AS VARCHAR))) AS currency,
        CAST(spend_local AS NUMBER(18, 2)) AS spend_local,
        CAST(impressions AS INTEGER) AS impressions,
        CAST(clicks AS INTEGER) AS clicks,
        CAST(loaded_date AS DATE) AS loaded_date,
        CAST(version AS INTEGER) AS version

    FROM {{ source('advertising', 'SPEND') }}