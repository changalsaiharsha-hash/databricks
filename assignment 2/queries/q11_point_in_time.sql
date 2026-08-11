-- Q11 · Point-in-time lookup

-- Keep only the latest version of each order.
WITH latest_orders AS (
    SELECT
        order_id,
        order_date
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

-- Find the price that was valid on the order date.
-- valid_to is exclusive.
priced_lines AS (
    SELECT
        i.order_item_id,
        i.product_id,
        i.quantity,
        ph.unit_price AS pit_price
    FROM latest_orders AS lo
    JOIN order_items AS i
        ON i.order_id = lo.order_id
    JOIN price_history AS ph
        ON ph.product_id = i.product_id
        AND lo.order_date >= ph.valid_from
        AND lo.order_date < ph.valid_to
),

-- Current price.
-- 9999-12-31 represents the open-ended/current price window.
today_prices AS (
    SELECT
        product_id,
        unit_price AS today_price
    FROM price_history
    WHERE valid_to = '9999-12-31'
)

SELECT
    SUM(pl.quantity * pl.pit_price) AS pit,
    SUM(pl.quantity * tp.today_price) AS today,
    SUM(pl.quantity * tp.today_price)
        - SUM(pl.quantity * pl.pit_price) AS overstatement,
    COUNT(*) AS lines
FROM priced_lines AS pl
JOIN today_prices AS tp
    ON tp.product_id = pl.product_id;