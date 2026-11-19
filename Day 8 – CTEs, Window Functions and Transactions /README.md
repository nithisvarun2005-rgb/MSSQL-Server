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
