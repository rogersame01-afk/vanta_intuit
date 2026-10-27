
SELECT
    NULLIF(TRIM(account_id::VARCHAR), '') AS account_id,
    TRIM(account_name::VARCHAR) AS account_name,
    UPPER(TRIM(country::VARCHAR)) AS country,
    CAST(employee_count AS INTEGER) AS employee_count

FROM {{ source('salesforce', 'ACCOUNTS') }}

