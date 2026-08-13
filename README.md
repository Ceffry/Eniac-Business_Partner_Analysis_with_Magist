# Eniac-Business Partner Analysis with Magist

## Project Overview

Eniac, a European e-commerce company specialising in tech products, is considering expanding into the Brazilian market through a 3-year partnership with Magist, a Brazilian SaaS company providing order management, logistics, shipment and after-sales services.

This project analyses Magist's e-commerce database using SQL and Tableau to evaluate two key concerns: whether Magist's marketplace is a good fit for Eniac's tech-focused catalogue and whether its delivery performance meets Eniac's customer experience expectations. Based on the findings, a 6-month reassessment of the partnership opportunity is recommended.

---

## Dataset & Sources

- Source: Magist Brazilian e-commerce database snapshot
- Time period: 25 months of order data
- Product categories: 74
- Key data: Orders, order items, products, sellers, customers, product categories, payments, reviews and geographic data
- Tools: MySQL Workbench and Tableau

The database was provided as part of the Eniac × Magist business case.

---

## Key Findings & Results

### Tech Market

- Tech products account for approximately 14% of total revenue.
- Computer Accessories is the only Tech category competing with the top Non-Tech sellers.
- All other Tech categories generate less than 50% of the revenue of the 8th-largest Non-Tech category.
- Tech products performed worse than other product categories in recent months.

### Premium Tech

- The market for expensive tech products is relatively small.
- Expensive products are purchased less frequently than less expensive products.
- This creates a potential market-fit risk for Eniac, whose catalogue is 100% tech-focused and heavily based on high-end and Apple-compatible accessories.

### Delivery Performance

- 92% of deliveries arrived on time.
- 8% of deliveries were delayed.
- While most deliveries arrive on time, delayed orders can experience substantial delays.
- The carrier stage of the delivery process is a significant source of delays.

---

## Main Risks for Eniac

| Risk | Finding |
|---|---|
| Market fit | Magist currently has a limited market for expensive tech products |
| Premium products | Expensive tech products sell considerably less |
| Tech revenue | Tech contributes approximately 14% of total revenue |
| Category fit | Computer Accessories is the only Tech category competing with top Non-Tech categories |
| Recent performance | Tech products performed worse than other categories in recent months |
| Delivery reliability | 8% of deliveries were delayed |
| Delay severity | Delayed orders can experience substantial additional delivery time |

---

## Recommendation

### Reassess the partnership opportunity in 6 months.

Based on the analysis, we recommend not committing immediately to the full 3-year partnership without further evaluation.

The two main concerns are:

1. Market Fit

Magist does not currently show a large market for expensive tech products. This creates a potential mismatch with Eniac's high-end, tech-focused catalogue.

2. Operational Reliability

Although 92% of deliveries arrive on time, the 8% that are delayed can experience substantial delays, particularly during the carrier stage.

We therefore recommend using the next 6 months to monitor:

- Tech category performance
- Demand for higher-priced products
- Recent sales trends
- Delivery reliability
- Severity of delivery delays

After 6 months, Eniac should reassess whether Magist can support its product strategy and customer experience requirements.

---

## Technologies Used

- MySQL Workbench
  - Data exploration
  - Aggregations
  - Filtering and categorisation
  - Revenue analysis
  - Delivery-time analysis

- Tableau
  - Data visualisation
  - Revenue comparisons
  - Delivery performance
  - Business insights

---

## Project Structure

```text
├── README.md
├── Magist Analysis.sql
├── Eniac Worksheets.twbx
└── Images/
    └── tech_vs_nontech_revenue.png
