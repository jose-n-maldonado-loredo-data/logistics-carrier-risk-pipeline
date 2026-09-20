# 🚚 Logistics Analytics & Carrier Risk Pipeline

## 📌 Executive Summary
An end-to-end data analytics solution bridging a local **PostgreSQL 18** database with an interactive **Power BI** executive dashboard[cite: 2]. The pipeline isolates high-risk shipments, quantifies delay penalty exposure, and highlights operational cost leakage across delivery partners[cite: 2].

---

## 🎯 Key Business Findings
* **Total Volume:** Analyzed **15,000** distinct customer orders across multi-regional distribution networks[cite: 2].
* **Financial Risk:** Identified **$123.87K** in total estimated delay penalty exposure out of **$908.73K** in total logistics spend[cite: 2].
* **High-Risk Exposure:** Flagged **746 High-Risk shipments** requiring immediate operational intervention[cite: 2].
* **Carrier Performance:** Identified **Partner B** ($25.5K) and **Partner D** ($25.1K) as the primary drivers of delay penalty costs[cite: 2].

---

## 🛠️ Tech Stack & Architecture
* **Database Management:** PostgreSQL 18 (Relational Data Modeling, Views, Joins, Aggregations)[cite: 7, 8]
* **Business Intelligence:** Power BI Desktop (Import Mode, Data Modeling, DAX, KPI Cards, Bar & Donut Visuals)[cite: 7, 8]
* **Connection:** Native PostgreSQL connector via `localhost:5432`[cite: 7, 8]

---

## 🗄️ Database Implementation (`v_executive_logistics_summary`)
Data was extracted from raw logistics order tables and consolidated into an executive view using PostgreSQL[cite: 7, 8]:

```sql
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
    o.total_logistics_cost,
    r.delay_risk_category,
    CASE 
        WHEN o.delivery_status IN ('Delayed', 'Severely Delayed') THEN 15
        ELSE 0
    END AS estimated_delay_penalty
FROM logistics_orders o
LEFT JOIN v_order_delay_risk r ON o.order_id = r.order_id;
// Total Volume Measure
Total Orders = COUNTROWS('public v_executive_logistics_summary')
```
---

##🧮 Explicit DAX Measures

```dax
// Total Spend Aggregation
Total Spend = SUM('public v_executive_logistics_summary'[total_logistics_cost])

// Financial Risk Exposure
Total Penalty Exposure = SUM('public v_executive_logistics_summary'[estimated_delay_penalty])

// Filtered High-Risk Volume
High Risk Orders = 
CALCULATE(
    COUNTROWS('public v_executive_logistics_summary'),
    'public v_executive_logistics_summary'[delay_risk_category] = "High Risk"
)
```
