-- Q4 · Aggregation and NULL behaviour

-- COUNT(*) counts every customer.
-- COUNT(credit_limit) counts only customers with a credit limit.
-- AVG(credit_limit) ignores NULL values.
-- SUM(credit_limit) also ignores NULL values.

SELECT
    COUNT(*) AS all_c,
    COUNT(credit_limit) AS with_limit,
    COUNT(*) - COUNT(credit_limit) AS nulls,
    AVG(credit_limit) AS avg_ignoring,
    AVG(COALESCE(credit_limit, 0)) AS avg_zero,
    SUM(credit_limit) AS sum_ignoring,
    SUM(COALESCE(credit_limit, 0)) AS sum_coalesce
FROM customers;