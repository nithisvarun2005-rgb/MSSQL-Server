# SET-1

# Logistics Shipment Analysis

## Project Overview
This project focuses on analyzing shipment operations for a logistics company. It uses SQL Server and MongoDB to generate business reports related to shipments, delivery delays, hubs, carriers, customers, and employees.

The project demonstrates advanced SQL joins, subqueries, and MongoDB aggregation using `$lookup` to analyze logistics data and identify important operational insights.

## Technologies Used
- Microsoft SQL Server
- SQL (T-SQL)
- MongoDB
- MongoDB Compass
- MongoDB Aggregation Framework

## Database Entities

The SQL reports use the following tables:

- `Shipments` – Stores shipment details, shipping costs, and delivery information.
- `Hubs` – Stores logistics hub information.
- `Carriers` – Stores carrier details.
- `Customers` – Stores customer information.
- `Delivery_Events` – Stores shipment tracking and delivery events.
- `Employees` – Stores employee details and supervisor relationships.

## SQL Reporting Tasks

The project includes ten business questions using different join operations:

1. Identify shipments delayed by more than two days along with carrier names.
2. Find hubs with no outbound shipments.
3. Display employees along with their supervisors.
4. Retrieve shipments with their corresponding customer details.
5. Find shipments and their delivery event information.
6. Identify customers who have not shipped any packages.
7. Display all hubs and their associated shipments, including unmatched records.
8. Compare shipments handled by different carriers.
9. Find shipments with missing carrier or hub information.
10. Generate combined shipment reports using multiple tables.

## Advanced SQL Concepts

### Join Operations
- `INNER JOIN`
- `LEFT JOIN`
- `FULL OUTER JOIN`
- Self Join

### Subqueries
- `IN`
- `EXISTS`
- `ANY`
- `ALL`
- Nested Subqueries
- Correlated Subqueries

### Additional SQL Tasks
- Rewrite two subqueries using JOIN operations.
- Compare readability between JOIN and subquery approaches.
- Retrieve the second-highest shipping cost per hub using a nested subquery.
- Calculate carrier average delays and compare them with the overall average delay.

## MongoDB Aggregation

Three aggregation pipelines are implemented using `$lookup`:

1. **Shipments with Delivery Events** – Combines shipment details with their related delivery event records.
2. **Customers with Their Shipments** – Retrieves customer information along with their shipment history.
3. **Carriers with Delay Statistics** – Analyzes carrier performance using shipment delay information.

### Embedding vs `$lookup`
The project also explains when embedding documents is preferable to using `$lookup`.

- **Embedding:** Suitable when related data is frequently accessed together and has a manageable size.
- **$lookup:** Suitable when related data is maintained in separate collections and needs to be joined during queries.

## Project Files

| File | Description |
|---|---|
| `Day 7 Set 1.sql` | Contains advanced SQL queries using joins and subqueries. |
| `Day 7 Set 2.js` | Contains MongoDB aggregation pipelines using `$lookup`. |


## Expected Outcome

This project helps analyze logistics operations by identifying delayed shipments, evaluating carrier performance, monitoring hub activity, understanding customer shipment patterns, and examining employee reporting relationships.

It also demonstrates how relational joins and MongoDB aggregation can retrieve and analyze related business information.

# SET-2

# Banking Loan Analysis

## Project Overview
This project focuses on analyzing banking loan operations using SQL Server and MongoDB. It helps a bank's credit team examine loans, customers, branches, repayments, and guarantors.

The project demonstrates advanced SQL joins, correlated and uncorrelated subqueries, EXISTS and NOT EXISTS operators, nested queries, and MongoDB aggregation using `$lookup`.

## Technologies Used
- Microsoft SQL Server
- SQL (T-SQL)
- MongoDB
- MongoDB Compass
- MongoDB Aggregation Framework

## Database Tables

The SQL reports use the following tables:

- `Loans` – Stores loan details, loan amounts, instalments, and branch information.
- `Customers` – Stores customer information.
- `Branches` – Stores bank branch details.
- `Repayments` – Stores loan repayment transactions.
- `Guarantors` – Stores guarantor details and their relationships with borrowers.

## SQL Reporting Tasks

The project includes ten business questions:

1. Identify loans overdue by more than three instalments.
2. Find customers with loans in more than one branch.
3. Identify guarantors who are also borrowers using a self join.
4. Find branches that have no loans.
5. Retrieve loans with their corresponding customer details.
6. Display loan and repayment information.
7. Find customers with multiple loans.
8. Identify loans with outstanding balances.
9. Find customers whose total loan exposure exceeds their branch average.
10. Generate a combined loan report using multiple tables.

## Advanced SQL Concepts

### Join Operations
- INNER JOIN
- LEFT JOIN
- SELF JOIN
- Multiple-table JOIN

### Subqueries
- Correlated subqueries
- Uncorrelated subqueries
- EXISTS
- NOT EXISTS
- Nested subqueries

### Additional SQL Tasks
- Identify customers whose total loan exposure exceeds the branch average.
- Find customers with loans but no repayments in the last 60 days.
- Find branches whose highest loan amount is greater than the bank-wide average of branch maximum loan amounts.

## MongoDB Aggregation

Three aggregation pipelines are implemented using `$lookup`:

1. **Loans with Customer Details** – Combines loan documents with customer information.
2. **Loans with Repayment Details** – Retrieves repayment information associated with each loan.
3. **Last Repayment for Each Loan** – Finds the most recent repayment record for every loan.

## Project Files

| File | Description |
|---|---|
| `Day 7 Set 2.sql` | Contains advanced SQL queries using joins and subqueries. |
| `Day 7 Set 2.js` | Contains MongoDB aggregation pipelines using `$lookup`. |


## Expected Outcome

This project helps analyze banking loan operations by identifying overdue loans, monitoring repayment activity, evaluating customer loan exposure, examining branch performance, and identifying guarantors who are also borrowers.

It also demonstrates how SQL Server and MongoDB can be used to retrieve and analyze related financial information.

# SET-3

# Retail Returns and Refunds Analysis

## Project Overview

This project analyses retail returns, refunds, products, customers, stores, employees and customer feedback using SQL Server and MongoDB.

The main objective is to understand product return rates, customer return behaviour, refund values, store performance and customer feedback.

## Business Scenario

A retailer wants to analyse its return and refund operations to identify products with high return rates, customers who have returned products without receiving refunds, stores with high refund values and employee-manager relationships.

## Technologies Used

- Microsoft SQL Server
- T-SQL
- MongoDB
- MongoDB Compass
- SQL Server Management Studio (SSMS)

## Database Tables

The project uses 10 relational tables.

| No. | Table | Description |
|---:|---|---|
| 1 | Customers | Customer information |
| 2 | Products | Product information |
| 3 | Stores | Store and region information |
| 4 | Employees | Employee and manager information |
| 5 | Sales | Sales transaction details |
| 6 | SaleItems | Products and quantities sold |
| 7 | Returns | Return transaction details |
| 8 | ReturnItems | Products and quantities returned |
| 9 | Refunds | Refund amount, date and status |
| 10 | ReturnFeedback | Customer ratings and comments |

## Tasks Completed

### 1. SQL Reporting Queries

Created SQL queries to:

- Identify products with a return rate above 10%.
- Find customers who have returns without corresponding refunds.
- Identify stores with the highest refund value.
- Display employees and their managers using a self join.
- Display returns with customer and product details.
- Calculate total refunds for each store.
- Find customers who returned more than one product.
- Identify returns without refund records.
- Find products with above-average return quantities.
- Generate a complete return and refund report.

### 2. IN, NOT IN and NOT EXISTS

- Used `IN` to find customers who made returns.
- Used `NOT IN` to find customers who never made returns.
- Demonstrated the NULL problem with `NOT IN`.
- Corrected the NULL problem using `NOT EXISTS`.

### 3. ANY and ALL

Compared refund values between stores in the same region.

- `ANY`: Refund value greater than at least one other store in the region.
- `ALL`: Refund value greater than every other store in the region.

### 4. Nested Subqueries

Created nested subqueries to:

- Find products whose return rate is above the average product return rate.
- Find stores whose refund value is above the average refund value across all stores.

### 5. MongoDB Aggregation Pipelines

Created three aggregation pipelines using `$lookup`:

- Join returns with customer feedback.
- Join returns with sales, customers and feedback.
- Identify returns without customer feedback.

## SQL and MongoDB Concepts

**SQL Server:**
- INNER JOIN
- LEFT JOIN
- SELF JOIN
- GROUP BY
- HAVING
- IN and NOT IN
- EXISTS and NOT EXISTS
- ANY and ALL
- Nested subqueries

**MongoDB:**
- `$lookup`
- `$unwind`
- `$match`
- `$project`

## Project Files

| File | Description |
|---|---|
| `Day 7 Set 3.sql` | Contains advanced SQL queries using joins and subqueries. |
| `Day 7 Set 3.js` | Contains MongoDB aggregation pipelines using `$lookup`. |



## Expected Outcome

This project demonstrates how SQL Server joins, subqueries and comparison operators can be used to analyse retail return and refund data. MongoDB `$lookup` pipelines provide equivalent document-based join operations for combining return records with customer and feedback information.
