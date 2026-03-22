# End-to-End-Sales-Analytics-Pipeline
# End-to-End Sales Analytics Project

## Business Problem
Analyze company sales data to find revenue trends, 
profit drivers and business improvement opportunities.

## Tools Used
- Python (Pandas, Matplotlib, Seaborn)
- MySQL (SQL Analysis)
- Power BI (Dashboard)
- Excel (Data Validation)

## Dataset
Superstore Sales Dataset - 9977 records

## Steps Performed
1. Data Cleaning (Python)
2. SQL Analysis (MySQL)
3. EDA Charts (Python)
4. Dashboard (Power BI)
5. Insights & Recommendations

## Key Insights
- Technology category drives highest profit
- Heavy discounts cause negative profit
- West region is most profitable
- Tables & Bookcases lose money consistently

## Recommendations
- Cap discounts at 20% maximum
- Focus on Technology products
- Improve South region performance
- Target Corporate segment more

# Business Insights & Recommendations

## Key Business Insights

### 1. Technology drives highest profit
- Technology = 45% of total profit
- Technology profit margin = 17%
- Furniture profit margin = only 3%
- Office Supplies profit margin = 17%

### 2. Discounts are destroying profit
- No discount orders = highest profit margin
- Low discount (1-20%) = moderate profit
- Medium discount (21-40%) = low profit
- High discount (41%+) = NEGATIVE profit
- Every 10% increase in discount = 3% drop in margin

### 3. West region is most profitable
- West = highest revenue AND profit
- South = lowest profit despite decent sales
- East = second highest revenue
- Central = moderate performance

### 4. Furniture is a problem category
- Tables = consistently negative profit
- Bookcases = negative profit
- Chairs = positive but low margin
- Heavy discounting on furniture = main cause

### 5. Consumer segment dominates revenue
- Consumer = 51% of total revenue
- Corporate = 30% of total revenue
- Home Office = 19% of total revenue
- But Corporate has BETTER profit margin

### 6. Sub-category performance gap
- Copiers = highest profit margin
- Phones = highest revenue
- Tables = biggest loss maker
- Bookcases = second biggest loss maker

---

## Business Recommendations (With Numbers)

### 1. Cap discounts at 20% maximum
- Current avg discount = 15%
- High discount orders = 20% of all orders
- Reducing high discounts could increase
  overall profit margin by 8-10%
- Expected profit increase = $25,000-30,000

### 2. Focus on Technology products
- Technology = 45% profit contribution
- Increasing Technology marketing by 10%
  could grow revenue by $50,000+
- Specifically push Copiers and Phones

### 3. Reprice or discontinue Tables
- Tables lose money on every sale
- Removing Tables could save $17,000/year
  in losses
- Alternative: increase Tables price by 15%

### 4. Target Corporate segment more
- Corporate has better profit margin
  than Consumer segment
- Increasing Corporate sales by 10%
  could improve overall margin by 2-3%
- Focus sales team on B2B customers

### 5. Fix South region performance
- South has 3rd highest revenue but
  lowest profit margin
- High discounting in South = main cause
- Reducing South discounts by 10%
  could add $15,000 in profit

### 6. Invest more in West region
- West has highest profit margin
- Increasing West marketing budget by 15%
  could generate $40,000 additional revenue

---

## Challenges Faced
- Dataset had no Order Date for time series analysis
- Found 17 duplicate rows in raw data
- Negative profit anomalies in Furniture category
- Had to engineer Discount Bucket column manually
- No Customer ID for individual customer analysis

---

## Future Improvements
- Add customer churn prediction using ML
- Add sales forecasting with Prophet or ARIMA
- Automate ETL pipeline using Apache Airflow
- Deploy dashboard to Power BI Service cloud
- Add real-time data refresh capability
- Add RFM customer segmentation analysis
