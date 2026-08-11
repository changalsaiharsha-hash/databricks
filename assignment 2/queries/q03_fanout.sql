-- Q3 · The fan-out trap

-- Use only the latest version of each order.
-- This makes sure we are demonstrating the fan-out problem only.

WITH latest_orders AS (
    SELECT *
    FROM (
        SELECT
            o.*,
            ROW_NUMBER() OVER (
                PARTITION BY o.order_id
                ORDER BY o.updated_at DESC, o.order_row_id DESC
            ) AS rn
        FROM orders AS o
    )
    WHERE rn = 1
),

-- WRONG: joining orders directly to order_items creates multiple
-- rows for orders that contain multiple items.

naive AS (
    SELECT
        lo.status,
        COUNT(*) AS inflated,
        SUM(i.quantity) AS qty_wrong
    FROM latest_orders AS lo
    JOIN order_items AS i
        ON i.order_id = lo.order_id
    GROUP BY lo.status
),

-- RIGHT: aggregate the many-side first so that there is
-- only one row per order before joining.

item_totals AS (
    SELECT
        order_id,
        SUM(quantity) AS total_quantity
    FROM order_items
    GROUP BY order_id
),

correct AS (
    SELECT
        lo.status,
        COUNT(*) AS correct,
        SUM(it.total_quantity) AS qty_right
    FROM latest_orders AS lo
    LEFT JOIN item_totals AS it
        ON it.order_id = lo.order_id
    GROUP BY lo.status
)

SELECT
    n.status,
    n.inflated,
    c.correct,
    n.inflated - c.correct AS added,
    n.qty_wrong,
    c.qty_right
FROM naive AS n
JOIN correct AS c
    ON c.status = n.status
ORDER BY n.status;