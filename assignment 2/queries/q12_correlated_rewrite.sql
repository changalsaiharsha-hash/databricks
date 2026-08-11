-- Q12 · Rewrite a slow correlated subquery

-- Compute the running order count over ALL orders first.
-- Only after the window calculation do we filter to shipped orders.

WITH counted AS (
    SELECT
        order_row_id,
        order_id,
        customer_id,
        order_date,
        status,
        COUNT(*) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
            RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS orders_to_date
    FROM orders
)

SELECT
    order_id,
    customer_id,
    order_date,
    orders_to_date
FROM counted
WHERE status = 'shipped'
ORDER BY order_row_id;