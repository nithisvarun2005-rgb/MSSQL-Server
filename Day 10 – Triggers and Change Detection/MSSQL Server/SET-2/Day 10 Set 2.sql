use bankdb

-- Creating Tables
CREATE TABLE Accounts
(
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(100),
    AccountType VARCHAR(20),
    Balance DECIMAL(12,2)
);
GO
CREATE TABLE Account_Transaction
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount DECIMAL(12,2),
    TransactionDate DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
GO
CREATE TABLE Transaction_Audit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID INT,
    ActionType VARCHAR(20),

    OldAccountID INT,
    NewAccountID INT,

    OldTransactionType VARCHAR(20),
    NewTransactionType VARCHAR(20),

    OldAmount DECIMAL(12,2),
    NewAmount DECIMAL(12,2),

    ChangedBy VARCHAR(100),
    ChangedAt DATETIME DEFAULT GETDATE()
);
GO

--Inserting Values into Tables
INSERT INTO Accounts
    (AccountID, AccountHolder, AccountType, Balance)
VALUES
    (101, 'Arun', 'Savings', 10000),
    (102, 'Priya', 'Savings', 15000),
    (103, 'Kavin', 'Current', 20000);
GO

INSERT INTO Account_Transaction
    (AccountID, TransactionType, Amount)
VALUES
    (101, 'Deposit', 5000),
    (102, 'Withdrawal', 2000),
    (103, 'Deposit', 3000);
GO

--Task 1 : After insert/update/delete trigger
CREATE OR ALTER TRIGGER trg_TransactionAudit
ON Account_Transaction
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Transaction_Audit
    (
        TransactionID,
        ActionType,
        OldAccountID,
        NewAccountID,
        OldTransactionType,
        NewTransactionType,
        OldAmount,
        NewAmount,
        ChangedBy,
        ChangedAt
    )
    SELECT
        COALESCE(i.TransactionID, d.TransactionID),

        CASE
            WHEN d.TransactionID IS NULL THEN 'INSERT'
            WHEN i.TransactionID IS NULL THEN 'DELETE'
            ELSE 'UPDATE'
        END,

        d.AccountID,
        i.AccountID,

        d.TransactionType,
        i.TransactionType,

        d.Amount,
        i.Amount,

        SUSER_SNAME(),
        GETDATE()

    FROM inserted i
    FULL OUTER JOIN deleted d
        ON i.TransactionID = d.TransactionID;
END;


--Inserting Values into Tables
INSERT INTO Account_Transaction
    (AccountID, TransactionType, Amount)
VALUES
    (101, 'Deposit', 1000);

UPDATE Account_Transaction
SET Amount = 2500
WHERE TransactionID = 2;

DELETE FROM Account_Transaction
WHERE TransactionID = 3;

SELECT *
FROM Transaction_Audit
ORDER BY AuditID;

-- Task 2 : Instead of Trigger 
CREATE OR ALTER VIEW dbo.vw_Accounts
AS
SELECT
    AccountID,
    AccountHolder,
    AccountType,
    Balance
FROM Accounts;
GO
CREATE OR ALTER TRIGGER dbo.trg_PreventNegativeBalance
ON dbo.vw_Accounts
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

 
    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN Accounts a
            ON i.AccountID = a.AccountID
        WHERE i.AccountType = 'Savings'
          AND i.Balance < 0
    )
    BEGIN
        THROW 50001, 'Savings account balance cannot be negative.', 1;
    END;

    UPDATE a
    SET
        a.AccountHolder = i.AccountHolder,
        a.AccountType = i.AccountType,
        a.Balance = i.Balance
    FROM Accounts a
    INNER JOIN inserted i
        ON a.AccountID = i.AccountID;
END
GO


UPDATE dbo.vw_Accounts
SET Balance = 12000
WHERE AccountID = 101;
SELECT * FROM Accounts;

UPDATE dbo.vw_Accounts
SET Balance = -500
WHERE AccountID = 101;
SELECT * FROM Accounts
WHERE AccountID = 101;


--Task 3 : Batch update 
UPDATE dbo.vw_Accounts
SET Balance =
    CASE AccountID
        WHEN 101 THEN 12000
        WHEN 102 THEN 18000
        WHEN 103 THEN 25000
        WHEN 104 THEN -500
        WHEN 105 THEN 15000
    END
WHERE AccountID IN (101, 102, 103, 104, 105);


SELECT AccountID, AccountHolder, AccountType, Balance
FROM Accounts
ORDER BY AccountID;
