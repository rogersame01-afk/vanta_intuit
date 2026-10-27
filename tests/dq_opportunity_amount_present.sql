{{ config(severity='error', store_failures=true) }}

SELECT
    opportunity_id,
    pipeline_usd

FROM {{ ref('stg_opportunities') }}

WHERE pipeline_usd IS NULL