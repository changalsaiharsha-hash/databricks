-- Q6 · CTEs and readability

-- CTE 1: Keep only the latest version of each order
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

-- CTE 2: Count items for each order
order_items_count AS (
    SELECT
        lo.order_id,
        lo.customer_id,
        COUNT(i.order_item_id) AS items
    FROM latest_orders AS lo
    JOIN order_items AS i
        ON i.order_id = lo.order_id
    GROUP BY lo.order_id, lo.customer_id
),

-- CTE 3: Calculate average items per region
region_average AS (
    SELECT
        c.region,
        COUNT(oic.order_id) AS order_count,
        AVG(oic.items) AS average_items
    FROM order_items_count AS oic
    JOIN customers AS c
        ON c.customer_id = oic.customer_id
    GROUP BY c.region
)

-- Final result
SELECT
    region,
    order_count,
    average_items
FROM region_average
WHERE average_items > 2
ORDER BY region;