-- Q9 · LAG — month-over-month change

-- Count shipped orders by month, then use LAG to get
-- the previous month's order count.

WITH monthly_orders AS (
    SELECT
        substr(order_date, 1, 7) AS month,
        COUNT(*) AS orders
    FROM orders
    WHERE status = 'shipped'
    GROUP BY substr(order_date, 1, 7)
),

with_previous AS (
    SELECT
        month,
        orders,
        LAG(orders) OVER (
            ORDER BY month
        ) AS previous_month
    FROM monthly_orders
)

SELECT
    month,
    orders,
    previous_month,
    orders - previous_month AS change,
    CASE
        WHEN previous_month IS NULL THEN NULL
        WHEN previous_month = 0 THEN NULL
        ELSE ROUND(
            (CAST(orders AS REAL) - previous_month)
            * 100.0 / previous_month,
            2
        )
    END AS percentage_change
FROM with_previous
ORDER BY month;