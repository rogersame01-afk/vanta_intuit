With base as (
select 
* 
FROM {{ source('salesforce', 'LEADS') }}),

renamed as (
SELECT
 -- Business identifiers
        NULLIF(TRIM(lead_id::VARCHAR), '') AS lead_id,
        NULLIF(TRIM(account_id::VARCHAR), '') AS account_id,
        NULLIF(TRIM(campaign_id::VARCHAR), '') AS campaign_id,
            -- Date standardization
        TRY_TO_DATE(created_date::VARCHAR)
            AS created_date,

        -- Lead scoring
        TRY_TO_NUMBER(score::VARCHAR)
            AS score,

        -- Normalize 0/1 or TRUE/FALSE
        TRY_TO_BOOLEAN(is_test::VARCHAR)
            AS is_test,

        -- Source audit attributes
        TRY_TO_DATE(loaded_date::VARCHAR)
            AS loaded_date,

        TRY_TO_NUMBER(version::VARCHAR)
            AS record_version
FROM base
)
SELECT *
FROM renamed
