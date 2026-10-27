WITH  Base as (
SELECT *
FROM
{{ ref('stg_leads') }}
 WHERE loaded_date <= CAST('{{ var("as_of") }}' AS DATE )
),

ranked AS (

    SELECT
        lead_id,
        account_id,
        campaign_id,
        created_date,
        score,
        is_test,
        loaded_date,
        record_version,

        ROW_NUMBER() OVER (
            PARTITION BY lead_id
            ORDER BY
                record_version DESC NULLS LAST,
                loaded_date DESC NULLS LAST
        ) AS row_num

    FROM Base

),

latest_version AS (

    SELECT
        lead_id,
        account_id,
        campaign_id,
        created_date as created_date,
        score,
        is_test,
        loaded_date,
        record_version

    FROM ranked

    WHERE row_num = 1

)

SELECT *
FROM latest_version

