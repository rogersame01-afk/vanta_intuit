SELECT
    NULLIF(TRIM(OPPORTUNITY_ID::VARCHAR), '')  AS opportunity_id,
    NULLIF(TRIM(LEAD_ID::VARCHAR), '')         AS lead_id,
    TRY_TO_DATE(CREATED_DATE::VARCHAR)         AS created_date,
    TRIM(CAST(STAGE AS VARCHAR))               AS stage,
    TRY_TO_DECIMAL(PIPELINE_USD::VARCHAR, 18, 2) AS pipeline_usd,
    CAST(loaded_date AS DATE)                  AS loaded_date,
    CAST(version AS INTEGER)                   AS version
FROM {{ source('salesforce', 'OPPORTUNITIES') }}