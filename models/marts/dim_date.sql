WITH dates AS (
    SELECT
        DATEADD(
            day,
            ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1,
            '2026-01-01'::DATE
        )::DATE AS date

    FROM TABLE(GENERATOR(ROWCOUNT => 90))
)

SELECT
    date,
    YEAR(date) AS year,
    QUARTER(date) AS quarter,
    MONTH(date) AS month_number,
    TO_CHAR(date, 'YYYY-MM') AS month,
    DAY(date) AS day_of_month

FROM dates