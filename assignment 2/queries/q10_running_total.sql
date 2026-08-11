-- Q10 · Running totals and window framing

-- Daily shipped-order counts for 2024.

WITH daily_orders AS (
    SELECT
        substr(order_date, 1, 10) AS day,
        COUNT(*) AS orders
    FROM orders
    WHERE status = 'shipped'
      AND substr(order_date, 1, 4) = '2024'
    GROUP BY substr(order_date, 1, 10)
)

SELECT
    day,
    orders,

    -- Cumulative total from the beginning through the current row
    SUM(orders) OVER (
        ORDER BY day
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,

    -- Current day + six previous days
    AVG(orders) OVER (
        ORDER BY day
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS ma7,

    -- Three days before + current day + three days after
    AVG(orders) OVER (
        ORDER BY day
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
    ) AS centred

FROM daily_orders
ORDER BY day;