WITH BASE AS (
SELECT *
from {{ ref('stg_opportunities') }}
     WHERE loaded_date <= CAST('{{ var("as_of") }}' AS DATE)
)

SELECT 
* 
FROM
BASE 
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY opportunity_id
    ORDER BY version DESC, loaded_date DESC
) = 1