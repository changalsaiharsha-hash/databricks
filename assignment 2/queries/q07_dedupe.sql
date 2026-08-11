-- Q7 · Deduplicate: keep the latest record per key

-- Keep only the latest version of each order.
-- ROW_NUMBER gives exactly one row with rn = 1 for each order_id.

WITH ranked AS (
    SELECT
        o.*,
        ROW_NUMBER() OVER (
            PARTITION BY o.order_id
            ORDER BY o.updated_at DESC, o.order_row_id DESC
        ) AS rn
    FROM orders AS o
)

SELECT
    order_id,
    customer_id,
    order_date,
    status,
    updated_at
FROM ranked
WHERE rn = 1
ORDER BY order_id;