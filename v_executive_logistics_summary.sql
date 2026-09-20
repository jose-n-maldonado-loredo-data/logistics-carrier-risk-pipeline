CREATE OR REPLACE VIEW v_executive_logistics_summary AS
SELECT 
    o.order_id,
    o.order_date,
    o.customer_region,
    o.warehouse_region,
    o.product_category,
    o.delivery_partner,
    o.delivery_status,
    o.order_value,
    (o.shipping_cost + o.logistics_cost) AS total_logistics_cost,
    r.delay_risk_category,
    CASE 
        WHEN o.delivery_status IN ('Delayed', 'Severely Delayed') THEN 15
        ELSE 0
    END AS estimated_delay_penalty
FROM logistics_orders o
LEFT JOIN v_order_delay_risk r ON o.order_id = r.order_id;
