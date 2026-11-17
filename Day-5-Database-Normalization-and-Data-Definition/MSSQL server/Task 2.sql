CREATE DATABASE Banking;

USE Banking;

/*Question1:Normalise to 3NF/BCNF, identify the candidate and composite keys 
1. Unnormalised table (UNF)
-Assume the original table contains:
CustomerID	CustomerName	Phone	AccountNo	AccountType	Balance	BranchID	BranchName	TransactionID	TransactionDate	Amount
C101	Arun	9876543210	A1001	Savings	25000	B01	Chennai	T01	2026-11-01	2000
C101	Arun	9876543210	A1001	Savings	25000	B01	Chennai	T02	2026-11-05	1000
C102	Priya	9876543211	A1002	Current	50000	B02	Coimbatore	T03	2026-11-06	5000

Problems with this table:
- Customer details are repeated for every transaction.
- Branch details are repeated.
- Updating customer or branch details requires changing multiple records.
- Deleting the last transaction could accidentally remove account-related information.
2. Functional dependencies
Assume the following business rules:

CustomerID → CustomerName, Phone

AccountNo → CustomerID, AccountType, Balance, BranchID

BranchID → BranchName

TransactionID → AccountNo, TransactionDate, Amount

These dependencies help us identify which attributes belong in separate tables.

3. Normalisation
1NF – First Normal Form
Rules:
- Each column must contain atomic values.
- No multiple values in a single cell.
- Each row must be uniquely identifiable.
The original table has repeating transaction information for each account.

We make each transaction a separate row and ensure all values are atomic.

2NF – Second Normal Form
Rules:
- Must satisfy 1NF.
- No partial dependency on a composite candidate key.
Suppose the original transaction-level relation has this composite key:

(AccountNo, TransactionID)

If account details depend only on AccountNo, they are partially dependent on the composite key.

So, separate account details from transactions.

3NF – Third Normal Form
Rules:
- Must satisfy 2NF.
- No transitive dependencies.

BCNF – Boyce-Codd Normal Form
Rule:

For every non-trivial functional dependency:

X → Y

X must be a super key.

Under the assumed business rules, the resulting tables below satisfy BCNF as well as 3NF.
4. Final normalised tables
We get four tables.
Table 1: Customer
Column	Key
CustomerID	PK
CustomerName	
Phone	UNIQUE

Table 2: Branch
Column	Key
BranchID	PK
BranchName	

Table 3: Account
Column	Key
AccountNo	PK
CustomerID	FK
BranchID	FK
AccountType	
Balance	

Table 4: Transaction
Column	Key
TransactionID	PK
AccountNo	FK
TransactionDate	
Amount	

5. Candidate keys and composite keys
A candidate key is a minimal set of attributes that uniquely identifies a row.
Table	Candidate key(s)	Primary key
Customer	CustomerID; Phone (if guaranteed unique)	CustomerID
Branch	BranchID	BranchID
Account	AccountNo	AccountNo
Transaction	TransactionID	TransactionID

Composite key: A key consisting of two or more columns.

In this design, all four tables have single-column primary keys. Therefore, they do not require composite primary keys.

However, if your banking rules allow an account to be jointly owned by multiple customers, we would introduce an AccountCustomer junction table:
CustomerID	AccountNo
C101	A1001
C102	A1001
C103	A1002

Its composite primary key would be:

(CustomerID, AccountNo)

This prevents the same customer-account combination from being inserted twice.*/


--Question 2.Create tables in SQL Server

--Creating Tables

CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Account (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    AccountNo VARCHAR(20) NOT NULL UNIQUE,
    AccountType VARCHAR(20) NOT NULL,
    Balance DECIMAL(12,2) NOT NULL DEFAULT 0,
    OpenDate DATE NOT NULL,

    CONSTRAINT CK_Account_Type
        CHECK (AccountType IN ('Savings', 'Current', 'Fixed Deposit')),

    CONSTRAINT CK_Savings_Balance
        CHECK (AccountType <> 'Savings' OR Balance >= 0)
);

CREATE TABLE CustomerAccount (
    CustomerID INT NOT NULL,
    AccountID INT NOT NULL,

    CONSTRAINT PK_CustomerAccount
        PRIMARY KEY (CustomerID, AccountID),

    CONSTRAINT FK_CA_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
        ON DELETE CASCADE,

    CONSTRAINT FK_CA_Account
        FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID)
        ON DELETE CASCADE
);

--Inserting Values to the Tables

INSERT INTO Customer (CustomerName, Phone, Email)
VALUES
('Arun', '9876543210', 'arun@gmail.com'),
('Kiran', '9876543211', 'kiran@gmail.com'),
('Priya', '9876543212', 'priya@gmail.com');

INSERT INTO Account (AccountNo, AccountType, Balance, OpenDate)
VALUES
('ACC001', 'Savings', 25000, '2026-07-10'),
('ACC002', 'Current', 50000, '2026-08-15'),
('ACC003', 'Savings', 15000, '2026-09-05'),
('ACC004', 'Fixed Deposit', 75000, '2026-05-20');

INSERT INTO CustomerAccount (CustomerID, AccountID)
VALUES
(1, 1),
(2, 2),
(1, 3),
(3, 4);

--Question 3. Difference between DROP, TRUNCATE and DELETE

--Creating Test Table
CREATE TABLE TestIdentity (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50)
);

INSERT INTO TestIdentity (Name)
VALUES ('Arun'), ('Kiran'), ('Priya');

SELECT * FROM TestIdentity;

--DELETE example
DELETE FROM TestIdentity
WHERE ID = 2;

SELECT * FROM TestIdentity;

INSERT INTO TestIdentity (Name)
VALUES ('Vijay');

SELECT * FROM TestIdentity;

--The new ID will be 4, because DELETE does not reset the identity counter

--TRUNCATE Example
TRUNCATE TABLE TestIdentity;

SELECT * FROM TestIdentity;

--Result: All rows are removed, but the table structure remains.

INSERT INTO TestIdentity (Name)
VALUES ('Meena');

SELECT * FROM TestIdentity;

--The new ID will be 1, because TRUNCATE resets the identity counter.

--DROP example
DROP TABLE TestIdentity;

--Result:
--- All table records are removed.
--- The table structure is removed.
--- Its identity definition is removed.
--- You cannot insert into it again until you recreate the table.

--Test rollback

--DELETE rollback:
BEGIN TRANSACTION;

DELETE FROM TestIdentity;

ROLLBACK TRANSACTION;

--TRUNCATE rollback:
BEGIN TRANSACTION;

TRUNCATE TABLE TestIdentity;

ROLLBACK TRANSACTION;

--DROP Rollback
BEGIN TRANSACTION;

DROP TABLE TestIdentity;

ROLLBACK TRANSACTION;

--Question 4. Retrieve accounts using WHERE, AND, OR, IN and BETWEEN

--WHERE
--Retrieve accounts with a balance greater than ₹20,000.
SELECT *FROM Account
WHERE Balance > 20000;

--AND
--Both conditions must be true.
SELECT *FROM Account
WHERE AccountType = 'Savings' AND Balance > 20000;

--OR
--At least one condition must be true.
SELECT *FROM Account
WHERE AccountType = 'Savings' OR AccountType = 'Current';

--IN
--Checks whether a value matches any value in a given list.
SELECT *FROM Account
WHERE AccountType IN ('Savings', 'Current');

--BETWEEN
--Checks whether a value falls within an inclusive range.
SELECT *FROM Account
WHERE Balance BETWEEN 10000 AND 50000;

--Accounts opened in the last quarter with balance above a threshold
DECLARE @Threshold DECIMAL(12,2) = 20000;

DECLARE @StartDate DATE =
    DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()) - 1, 0);

DECLARE @EndDate DATE =
    DATEADD(QUARTER, DATEDIFF(QUARTER, 0, GETDATE()), 0);

SELECT *
FROM Account
WHERE OpenDate >= @StartDate
  AND OpenDate < @EndDate
  AND Balance > @Threshold
  AND (
        AccountType IN ('Savings', 'Current')
        OR Balance BETWEEN 100000 AND 200000
      );


