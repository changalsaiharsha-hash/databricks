-- Q2 · INNER versus LEFT join

-- The trap: adding a WHERE clause on the right-hand table silently converts a
-- LEFT join back into an INNER join. That is the single most common join bug.

-- Customers with no orders at all

SELECT
    c.region,
    COUNT(*) AS customers_without_orders
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.customer_id
WHERE o.customer_id IS NULL
GROUP BY c.region
ORDER BY c.region;