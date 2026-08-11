-- Q8 · ROW_NUMBER versus RANK versus DENSE_RANK

-- Find the top 3 products by quantity sold in each region.
-- Show all three ranking functions to demonstrate how ties are handled.

WITH product_sales AS (
    SELECT
        c.region,
        i.product_id,
        SUM(i.quantity) AS quantity_sold
    FROM orders AS o
    JOIN customers AS c
        ON c.customer_id = o.customer_id
    JOIN order_items AS i
        ON i.order_id = o.order_id
    GROUP BY
        c.region,
        i.product_id
),

ranked AS (
    SELECT
        region,
        product_id,
        quantity_sold,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS row_number_rank,

        RANK() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS rank_rank,

        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS dense_rank
    FROM product_sales
)

SELECT
    region,
    product_id,
    quantity_sold,
    row_number_rank,
    rank_rank,
    dense_rank
FROM ranked
WHERE rank_rank <= 3
ORDER BY region, rank_rank, product_id;