-- Creating Database
CREATE DATABASE BankDB;
USE BankDB;

-- Creating Tables
CREATE TABLE Accounts
(
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(100) NOT NULL,
    Balance DECIMAL(18,2) NOT NULL,
    Status VARCHAR(20) NOT NULL
);

CREATE TABLE Transactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionDate DATETIME2 DEFAULT SYSDATETIME(),
    TransactionType VARCHAR(20) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    BalanceAfter DECIMAL(18,2) NOT NULL,
    Description VARCHAR(200),

    FOREIGN KEY (AccountID)
    REFERENCES Accounts(AccountID)
);

--Inserting Values Into Tables
INSERT INTO Accounts
(AccountID, AccountHolder, Balance, Status)
VALUES
(101, 'Arun', 10000.00, 'ACTIVE'),
(102, 'Bala', 5000.00, 'ACTIVE'),
(103, 'Charan', 2000.00, 'BLOCKED'),
(104, 'Deepa', 15000.00, 'ACTIVE'),
(105, 'Elango', 8000.00, 'ACTIVE');

INSERT INTO Transactions
(AccountID, TransactionDate, TransactionType,
 Amount, BalanceAfter, Description)
VALUES
(101, '2026-11-01 09:00:00', 'CREDIT', 2000, 10000, 'Salary credited'),
(101, '2026-11-05 10:00:00', 'DEBIT', 500, 9500, 'Shopping payment'),
(101, '2026-11-10 11:00:00', 'CREDIT', 1000, 10500, 'Money received'),
(101, '2026-11-15 12:00:00', 'DEBIT', 1500, 9000, 'Bill payment'),
(102, '2026-11-02 09:30:00', 'CREDIT', 1000, 5000, 'Cash deposit'),
(102, '2026-11-08 14:00:00', 'DEBIT', 500, 4500, 'Online payment'),
(102, '2026-11-12 15:00:00', 'CREDIT', 2000, 6500, 'Money received');


-- Question 1: Funds Transfer Using Transactions
BEGIN TRY
    BEGIN TRAN;

    DECLARE @FromAccount INT = 101;
    DECLARE @ToAccount INT = 102;
    DECLARE @Amount DECIMAL(10,2) = 1000;

    DECLARE @Balance DECIMAL(10,2);
    DECLARE @FromStatus VARCHAR(20);
    DECLARE @ToStatus VARCHAR(20);

   
    SELECT
        @Balance = Balance,
        @FromStatus = Status
    FROM Accounts WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @FromAccount;

    
    SELECT @ToStatus = Status
    FROM Accounts WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @ToAccount;

    IF @Balance IS NULL OR @ToStatus IS NULL
        THROW 50001, 'Account does not exist', 1;

    IF @FromStatus <> 'ACTIVE'
       OR @ToStatus <> 'ACTIVE'
        THROW 50002, 'Account is not active', 1;

    IF @Amount <= 0
        THROW 50003, 'Invalid transfer amount', 1;

    IF @Balance < @Amount
        THROW 50004, 'Insufficient balance', 1;

    -- Debit 
    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @FromAccount;

    -- Credit 
    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @ToAccount;

    COMMIT TRAN;

    PRINT 'Transfer successful';

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRAN;

    PRINT ERROR_MESSAGE();

END CATCH;

-- Question 2: Demonstrate Deliberate Failure and Rollback
BEGIN TRY

    BEGIN TRAN;

    
    UPDATE Accounts
    SET Balance = Balance - 1000
    WHERE AccountID = 101;

    PRINT 'Amount debited successfully';


    THROW 50005, 'Simulated failure after debit', 1;


    UPDATE Accounts
    SET Balance = Balance + 1000
    WHERE AccountID = 102;

    COMMIT TRAN;

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRAN;

    PRINT 'Transaction rolled back';
    PRINT ERROR_MESSAGE();

END CATCH;


SELECT AccountID, Balance
FROM Accounts
WHERE AccountID IN (101, 102);

-- Question 3: SAVEPOINT – Roll Back Only Fee Posting

BEGIN TRY

    BEGIN TRAN;

    
    UPDATE Accounts
    SET Balance = Balance - 500
    WHERE AccountID = 101;

    
    UPDATE Accounts
    SET Balance = Balance + 500
    WHERE AccountID = 102;

    PRINT 'Transfer completed';

   
    SAVE TRAN FeeSavepoint;

  
    INSERT INTO Transactions
    (AccountID, TransactionType, Amount, BalanceAfter)
    SELECT
        AccountID,
        'FEE',
        25,
        Balance
    FROM Accounts
    WHERE AccountID = 101;

  
    ROLLBACK TRAN FeeSavepoint;

    PRINT 'Fee posting rolled back';

   
    COMMIT TRAN;

    PRINT 'Transfer committed successfully';

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRAN;

    PRINT ERROR_MESSAGE();

END CATCH;

-- Question 4: Monthly Statement Using CTE, ROW_NUMBER and LAG

DECLARE @AccountID INT = 101;

DECLARE @StartDate DATE = '2026-11-01';

DECLARE @EndDate DATE = '2026-12-01';

WITH AccountHistory AS
(
    SELECT
        TransactionID,
        AccountID,
        TransactionDate,
        TransactionType,
        Amount,
        BalanceAfter,

        LAG(BalanceAfter) OVER
        (
            PARTITION BY AccountID
            ORDER BY TransactionDate, TransactionID
        ) AS PreviousBalance

    FROM Transactions
    WHERE AccountID = @AccountID
),

MonthlyStatement AS
(
    SELECT
        ROW_NUMBER() OVER
        (
            ORDER BY TransactionDate, TransactionID
        ) AS RowNumber,

        TransactionID,
        AccountID,
        TransactionDate,
        TransactionType,
        Amount,
        PreviousBalance,
        BalanceAfter

    FROM AccountHistory
    WHERE TransactionDate >= @StartDate
      AND TransactionDate < @EndDate
)

SELECT *
FROM MonthlyStatement
ORDER BY TransactionDate, TransactionID;

-- Question 5: READ COMMITTED, SNAPSHOT
-- Session 1:
BEGIN TRAN;

UPDATE Accounts
SET Balance = Balance - 1000
WHERE AccountID = 101;

-- Do not commit yet

-- Session 2:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT Balance
FROM Accounts
WHERE AccountID = 101;

-- After Session 1:
COMMIT TRAN;

-- Part B: SNAPSHOT Isolation
ALTER DATABASE BankDB
SET ALLOW_SNAPSHOT_ISOLATION ON;

-- Session 1:
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN;

SELECT Balance
FROM Accounts
WHERE AccountID = 101;

-- Keep transaction open

-- Session 2:
UPDATE Accounts
SET Balance = Balance - 100
WHERE AccountID = 101;

COMMIT TRAN;

-- Session 1:
SELECT Balance
FROM Accounts
WHERE AccountID = 101;

COMMIT TRAN;

