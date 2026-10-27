
SELECT
    campaign_id,
    campaign_name,
    channel,
    country

FROM {{ ref('stg_campaigns') }}
