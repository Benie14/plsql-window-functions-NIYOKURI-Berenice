# PLSQL – window - functions – NIYOKURI - Berenice
# Business Context
About Rwanda Coffee Collective is a specialty coffee retailer based in Rwanda, with cafes based out of Kigali, Rubavu and Huye + premium coffee at great prices. Shubi’s sources directly from Rwandan coffee farmers and serves retail customers as well as companies. Being in several places with a variety of products, the company has high customer, product and transaction data.
## Data Challenge
It's hard to track and analyze performance by region and product category. The organization triage is to determine best sellers by region, to track the sales trends, customer segmentation of ‘small spender’, and business growing pattern. Without accurate insights, inventory management and marketing initiatives are still inefficient.
## Expected Outcome
The analysis will reveal:
- Top-selling products by region and quarter
- Monthly sales trends and growth patterns 
- Customer segmentation by spending levels
- Seasonal insights on coffee and equipment sales
- Regional performance comparisons
## Success Criteria
To solve this, I applied five window functions:
1. Top 5 products per region and quarter → RANK()
2. Running monthly sales totals → SUM() OVER()
3. Month-over-month sales growth → LAG()
4. Customer quartiles by spending → NTILE(4)
5. 3-month moving average of sales → AVG() OVER()
## Database Schema
I designed three related tables:
Customers – stores customer information
- customer_id (PK), name, region, email, phone
Products – stores product catalog 
- product_id (PK), name, category, price, cost_price
Transactions – records all sales
- transaction_id (PK), customer_id (FK), product_id (FK), sale_date, amount, quantity
## Results Analysis
### What happened?
- Identified top-selling products in each region
- Found consistent sales growth from January to March
- Discovered premium coffee beans as the highest revenue generator
- Segmented customers into four distinct spending tiers
### Diagnostic 
- Kigali region shows highest sales due to urban concentration and corporate clients
- Premium products drive disproportionate revenue despite lower volume
- Customer loyalty programs effectively retain high-value clients
- Seasonal demand affects equipment vs. coffee sales patterns
### Prescriptive
- Increase inventory of premium coffee beans in Kigali by 25%
- Develop targeted marketing for top-spending customer quartile 
- Expand successful Kigali strategies to other regions
- Use moving averages for seasonal inventory planning
- Create loyalty incentives for mid-tier customers to increase spending
## References
•	Oracle PL/SQL Documentation 
•	W3Schools SQL Tutorial 
•	Database Journal SQL Analytics 
•	Rwanda Coffee Industry Reports

All sources were properly cited. Implementations and analysis represent original work. No AI-
generated content was copied without attribution or adaptation.




