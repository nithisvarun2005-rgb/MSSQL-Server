# Set 1 – Retail Sales Reporting

# Retail Sales Reporting

## Project Overview
This project focuses on generating business reports for a retail sales team using SQL Server and MongoDB. It analyzes sales transactions, customer purchasing patterns, product performance, and revenue trends.

## Technologies Used
- Microsoft SQL Server
- MongoDB
- MongoDB Compass
- SQL (T-SQL)
- MongoDB Aggregation Framework

## Database Tables
The SQL reports use the following tables:
- `Orders`
- `Order_Items`
- `Customers`
- `Products`

## SQL Reporting Tasks
The project includes eight SQL reports:

1. Top 5 products by revenue.
2. Month-wise sales analysis.
3. Customers with more than three orders using `HAVING`.
4. Average basket value per city.
5. Orders without payment using `LEFT JOIN`.
6. Customers who have not placed any orders.
7. Product-category revenue share.
8. Day with the highest sales.

## SQL Concepts and Functions
- Joins: INNER JOIN, LEFT JOIN
- Aggregate functions: SUM, COUNT, AVG
- GROUP BY and HAVING
- Subqueries
- String functions: UPPER, CONCAT
- Date functions: DATEDIFF, FORMAT
- Mathematical functions: ROUND
- NULL handling

## MongoDB Aggregation
Three aggregation pipelines are implemented:

1. Month-wise sales.
2. Top products by revenue.
3. Average basket value.

The pipelines use `$match`, `$group`, and `$sort`.

## Project Files
- `Day 6 Set 1.sql` – SQL Server reporting queries.
- `Day 6 Set 1.js` – MongoDB aggregation pipelines.
  
## Expected Outcome
The project provides insights into monthly sales, top-performing products, customer purchasing behaviour, and revenue distribution across product categories.

# Set 2 - Insurance Policy Reporting

# Insurance Policy Reporting

## Project Overview
This project focuses on analyzing insurance policies, customers, premium collections, and claims. It generates management reports to help an insurance company monitor policy performance and claim-related activities.

## Technologies Used
- Microsoft SQL Server
- MongoDB
- MongoDB Compass
- SQL (T-SQL)
- MongoDB Aggregation Framework

## Database Tables
The SQL reports use the following entities:
- `Policies`
- `Customers`
- `Premiums`
- `Claims`

## SQL Reporting Tasks
The project includes eight SQL reports:

1. Policies expiring in the next 30 days.
2. Premium collected per product.
3. Customers with more than one active policy.
4. Claim ratio per product.
5. Policies without claims.
6. Average premium by age band.
7. Monthly new policies.
8. Top 5 agents by premium collected.

## SQL Concepts and Functions
- Joins
- Aggregate functions: SUM, COUNT, AVG
- GROUP BY and HAVING
- WHERE and HAVING differences
- Date functions: DATEADD, DATEDIFF
- Conditional expressions: CASE
- String functions
- Policy number masking
- Date-based policy expiry calculations

## MongoDB Aggregation
Three aggregation pipelines are implemented using the claims-notes collection:

1. Claims count per status.
2. Average settlement time.
3. Top 3 damage categories.

The pipelines demonstrate filtering, grouping, sorting, and aggregation operations.

## Project Files
- `Day 2 Set 2.sql` – SQL Server reporting queries.
- `Day 2 Set 2.js` – MongoDB aggregation pipelines.

## Expected Outcome
The project provides insights into policy expiry, premium collections, customer policy activity, claim ratios, and agent performance.

# Set - 3  Telecom Usage and Billing Reporting
# Telecom Usage and Billing Reporting

## Project Overview
This project focuses on analyzing telecom subscriber usage, plan performance, call records, and invoice information. It generates reports to help a telecom operator understand customer usage patterns, revenue performance, and billing status.

## Technologies Used
- Microsoft SQL Server
- MongoDB
- MongoDB Compass
- SQL (T-SQL)
- MongoDB Aggregation Framework

## Database Tables
The SQL reports use the following tables:
- `Subscribers`
- `Plans`
- `Call_Records`
- `Invoices`

## SQL Reporting Tasks
The project includes eight SQL reports:

1. Total call minutes per plan.
2. Subscribers exceeding their data limit.
3. Month-wise revenue.
4. Invoices overdue by more than 15 days.
5. Subscribers with no usage.
6. Average Revenue Per User (ARPU) by circle.
7. Plan popularity.
8. Top 10 data consumers.

## SQL Concepts and Functions
- INNER JOIN and LEFT JOIN
- Aggregate functions: SUM, COUNT, AVG
- GROUP BY and ORDER BY
- Subqueries
- String functions
- Date functions
- Invoice number formatting
- Due-date status calculation
- NULL handling in SUM and AVG

## MongoDB Aggregation
Three aggregation pipelines are implemented over the usage-events collection:

1. Hourly usage analysis.
2. Average session length.
3. Busiest cell tower based on usage.

The pipelines demonstrate `$match`, `$group`, `$sort`, and aggregation operations.

## Project Files
- `Day 6 Set 3.sql` – SQL Server reporting queries.
- `Day 6 Set 3` – MongoDB aggregation pipelines.

## Expected Outcome
The project provides insights into subscriber usage, monthly revenue, plan popularity, overdue invoices, and network usage patterns.
