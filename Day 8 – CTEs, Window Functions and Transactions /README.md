# SET -1

# Bank Funds Transfer – Database Transactions Assignment

# Project Overview
This assignment demonstrates safe money transfers using SQL Server transactions and MongoDB multi-document transactions. It covers ACID atomicity, error handling, rollback, savepoints, monthly statements, and transaction isolation.
Technologies Used
- Microsoft SQL Server (T-SQL)
- DataGrip or SQL Server Management Studio
- MongoDB 8.x
- Node.js
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


Transactions
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
