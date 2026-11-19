# SET -1

# Bank Funds Transfer – Database Transactions Assignment

# Project Overview
This assignment demonstrates safe money transfers using SQL Server transactions and MongoDB multi-document transactions. It covers ACID atomicity, error handling, rollback, savepoints, monthly statements, and transaction isolation.
Technologies Used
- Microsoft SQL Server (T-SQL)
- DataGrip or SQL Server Management Studio
- MongoDB 8.x
- MongoDB Node.js driver (mongodb)

# Project Files

# File	Description

Day 8 Set 1.sql -	Creates sample SQL Server tables, demonstrates a deliberate failure and rollback, then performs a successful transfer with fee rollback to a savepoint.
Day 8 Set 1.js	- Implements a MongoDB multi-document funds transfer.



# Database Design
Accounts
Column	Type	Description
AccountID	INT	Primary key
Balance	DECIMAL(18,2)	Current account balance
Status	VARCHAR(20)	Account status, such as ACTIVE or BLOCKED


# Transactions
Column	Type	Description
TransactionID	BIGINT IDENTITY	Primary key
AccountID	INT	Account that owns the transaction
TransactionDate	DATETIME2	Transaction date and time
TransactionType	VARCHAR(20)	CREDIT, DEBIT or FEE
Amount	DECIMAL(18,2)	Transaction amount
BalanceAfter	DECIMAL(18,2)	Account balance after the transaction
Description	VARCHAR(200)	Transaction details

# Concepts Demonstrated
- ACID atomicity: Debit and credit succeed together or are both rolled back.
- BEGIN TRAN / COMMIT: Starts and commits a SQL Server transaction.
- ROLLBACK: Reverses uncommitted changes.
- TRY...CATCH and THROW: Detect and handle transaction errors.
- SAVE TRAN: Creates a savepoint for partial rollback.
- CTE: Organizes a monthly statement query.
- ROW_NUMBER(): Numbers statement rows.
- LAG(): Retrieves the previous transaction balance.
- READ COMMITTED: Prevents dirty reads.
- SNAPSHOT: Provides a transactionally consistent versioned view.
- MongoDB transaction: Applies related changes across multiple documents atomically.
 
# Conclusion
This project demonstrates how relational and document databases can maintain consistency during financial transfers. SQL Server transactions and MongoDB multi-document transactions help ensure that related account updates are committed together or rolled back when an error occurs.

# Set 2 – Airline Seat Booking

# Project Overview
This project demonstrates how an airline booking system reserves seats safely when multiple customers may try to book the same seat. It uses SQL Server transactions for relational data and a MongoDB multi-document transaction for the equivalent NoSQL workflow.

# Technologies
- Microsoft SQL Server (T-SQL)
- DataGrip or SQL Server Management Studio
- MongoDB
- MongoDB Node.js driver (mongodb)

# Database Tables
The SQL Server database is AirlineDB.
Table	Purpose
Flights	Flight number, route and departure time
Passengers	Passenger information
Seats	Seat number, flight and availability status
Bookings	Passenger, flight, seat, fare and booking date


# Relationships
- One flight has many seats.
- One flight can have many bookings.
- One passenger can have many bookings.
- Each booking refers to one seat.
- UNIQUE (FlightID, SeatNumber) prevents duplicate seat definitions within a flight.
- UNIQUE (SeatID) in Bookings prevents more than one booking row for a seat.

# Sample Data
The setup inserts 3 flights, 6 passengers, 18 seats and 6 initial bookings.

Flight AI201 contains tied fares of 5,000. Flight AI202 contains tied fares of 6,000. These ties are used to demonstrate RANK() and DENSE_RANK().

# Question 1 – Atomic Seat Booking
The booking transaction:
1. Starts a transaction.
2. Checks that the requested seat exists and is AVAILABLE.
3. Locks the seat row using UPDLOCK and HOLDLOCK.
4. Validates the passenger and fare.
5. Updates the seat status to BOOKED.
6. Inserts the booking record.
7. Commits both changes together.
8. Rolls back if an error occurs.

# Question 2 – Concurrent Booking
Two SQL Server sessions attempt to book the same seat.
- Under READ COMMITTED, a check and a later update performed as separate statements can allow both sessions to read AVAILABLE before either update commits. A conditional update and row-count check are required to prevent a stale availability check from becoming a successful second booking.
- Under SERIALIZABLE, SQL Server holds the relevant locks for the transaction, so the competing session waits and then sees the committed seat state.
The unique constraints are an additional integrity safeguard. For production code, use a single transaction, conditional status update, @@ROWCOUNT validation and appropriate error handling.

# Question 3 – Passenger Fare Ranking
The report joins Bookings, Flights and Passengers and uses RANK() and DENSE_RANK() partitioned by flight and ordered by fare descending.

RANK() leaves gaps after tied ranks. DENSE_RANK() does not leave gaps.

# Question 4 – CTE and Running Revenue
The CTE report calculates passenger fare rankings and running revenue for each flight using:

SUM(Fare) OVER (PARTITION BY FlightID ORDER BY BookingDate, BookingID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

The booking date and booking ID provide a deterministic order for the running total.

# Question 5 – MongoDB Transaction
The MongoDB example uses:
- seats collection to store seat documents.
- bookings collection to store booking documents.
- A session and withTransaction() to update the seat and insert the booking atomically.
If either operation fails, the transaction is aborted. MongoDB multi-document transactions require a replica set or sharded cluster; a standalone server is not sufficient.

# Project Files

# File	Description

Day 8 Set 2.sql -Contains all SQL tasks, including table creation, sample data, transactions, concurrency, ranking and CTE.

Day 8 Set 2.js	-Contains the MongoDB transaction implementation.

# Conclusion
The assignment demonstrates atomic seat reservation, concurrency control, ranking functions, CTEs, running totals and MongoDB transactions. These techniques help prevent duplicate seat bookings and keep booking records consistent.



# SET-3
# Retail Inventory and Order Management

# Project Overview
This project demonstrates how an online retailer can reserve stock when an order is placed and avoid inconsistent inventory when stock is insufficient or payment/order processing fails.

# The project uses:
- Microsoft SQL Server (T-SQL) for relational database operations.
- MongoDB with Node.js for a single-document atomic stock update.

# File Description
This project contains two implementation files:

# File Name	Description
Day 8 Task 3.sql	Contains database and table creation, sample data insertion, the stock reservation transaction with rollback demonstration, the correlated stock-average query, the category-wise top-three sales report using a CTE and ROW_NUMBER(), and monthly sales comparison using LAG() and LEAD().
Day 8 Task 3.js	Contains the MongoDB single-document stock decrement example using updateOne(), a stock-availability condition with $gte, and $inc to decrement stock atomically.


# Database Structure
The SQL Server database is named RetailDB.
Table	Purpose
Categories	Stores product categories.
Products	Stores product information, category, available stock and unit price.
Customers	Stores customer details.
Orders	Stores order details, customer, date and status.
OrderLines	Stores the products, quantities and unit prices belonging to each order.


# Relationships
- One category can contain many products.
- One customer can place many orders.
- One order can contain many order lines.
- Each order line refers to one product.

# Sample Data
The setup script inserts:
- 3 categories
- 9 products
- 5 customers
- 6 orders
- 12 order lines

The sample orders are marked PAID and have dates in January, February and March 2026. They are used by the sales-ranking and month-on-month reporting queries.
Question-wise Implementation

#Question 1 – Stock reservation transaction
The SQL transaction:
1. Checks that each requested product exists and has enough stock.
2. Decrements product stock.
3. Inserts the order.
4. Inserts the order lines.
5. Commits only if all operations succeed.
If stock is insufficient, an error is raised and the transaction is rolled back. To demonstrate rollback, the sample test requests 999 units of product 103, although only 20 are available. The stock and order tables remain unchanged by that failed attempt.

Change the test quantity to 2 to demonstrate a successful order.

# Question 2 – Correlated subquery
Lists products whose stock quantity is below the average stock quantity of products in the same category. The inner query refers to the outer product's CategoryID.

# Question 3 – CTE and ROW_NUMBER
Calculates paid sales revenue for each product, ranks products within each category using ROW_NUMBER() and PARTITION BY, and returns up to the top three products in each category.

Sales revenue is calculated as Quantity * UnitPrice.

# Question 4 – LAG and LEAD
Aggregates paid sales by product and month. LAG() returns the previous recorded sales month's revenue, while LEAD() returns the next recorded sales month's revenue. The difference between current and previous sales is shown as the month-on-month change.

The query compares recorded sales months. It does not generate missing months with zero sales.

# Question 5 – MongoDB atomic stock update
The JavaScript example uses updateOne() with a filter requiring stockQuantity to be at least the requested quantity. $inc decrements the stock in one atomic document update.

A multi-document transaction is needed when stock changes, order insertion and order-line insertion must all succeed or fail together. A single-document atomic update is sufficient when only one product document needs to be changed.

# Important Concepts
- BEGIN TRANSACTION, COMMIT and ROLLBACK
- TRY...CATCH, THROW and XACT_STATE()
- UPDLOCK and HOLDLOCK
- Correlated subqueries
- Common Table Expressions (CTEs)
- ROW_NUMBER() and PARTITION BY
- LAG() and LEAD()
- MongoDB updateOne(), $gte and $inc
- Single-document atomicity versus multi-document transactions

# Conclusion
This project demonstrates safe stock reservation, rollback on insufficient inventory, category-based inventory analysis, product sales ranking, monthly sales comparisons and MongoDB atomic stock updates
