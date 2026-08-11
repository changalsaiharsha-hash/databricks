-- Q5 · HAVING versus WHERE

-- WHERE filters rows before grouping.
-- HAVING filters groups after aggregation.

SELECT
    c.region,
    COUNT(*) AS order_count,
    COUNT(DISTINCT o.customer_id) AS customer_count
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
WHERE o.status = 'shipped'
GROUP BY c.region
HAVING COUNT(*) > 150
ORDER BY order_count DESC;