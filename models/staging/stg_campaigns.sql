
select
   NULLIF(TRIM(campaign_id::VARCHAR), '') AS campaign_id,
    TRIM(campaign_name::VARCHAR) AS campaign_name,
    UPPER(TRIM(channel::VARCHAR)) AS channel,
    UPPER(TRIM(country::VARCHAR)) AS country
from
{{ source('salesforce', 'CAMPAIGNS') }}