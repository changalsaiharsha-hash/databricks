-- Q1 · Grain

-- The grain is NOT one row per order.
-- It is one row per version of an order.

SELECT
    COUNT(*) AS total,
    COUNT(DISTINCT order_id) AS "distinct",
    COUNT(*) - COUNT(DISTINCT order_id) AS surplus,
    ROUND(
        CAST(COUNT(*) AS REAL) / COUNT(DISTINCT order_id),
        2
    ) AS ratio
FROM orders;