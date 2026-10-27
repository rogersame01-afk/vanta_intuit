WITH base as (
 SELECT *
 from {{ ref('stg_billing') }}
 WHERE loaded_date <= CAST('{{ var("as_of") }}' AS DATE)
)
select 
*
from
base
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY billing_id
    ORDER BY version DESC, loaded_date DESC
) = 1