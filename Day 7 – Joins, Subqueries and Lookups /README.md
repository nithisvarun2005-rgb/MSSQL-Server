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
