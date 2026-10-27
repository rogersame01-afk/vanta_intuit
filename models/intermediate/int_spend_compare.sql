WITH BASE AS
(
    Select
    *
 FROM {{ ref('stg_spend_compare') }}
     WHERE loaded_date <= CAST('{{ var("as_of") }}' AS DATE)
)

Select
* 
from
base
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY spend_id
    ORDER BY version DESC, loaded_date DESC
) = 1