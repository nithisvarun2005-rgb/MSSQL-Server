-- Creating Tables
CREATE TABLE Plans
(
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(50),
    Amount DECIMAL(10,2),
    ValidityDays INT,
    IsActive BIT
);

CREATE TABLE Subscribers
(
    SubscriberID INT PRIMARY KEY,
    SubscriberName VARCHAR(100),
    PhoneNumber VARCHAR(15),
    SubscriberType VARCHAR(20),
    Balance DECIMAL(10,2),
    PlanID INT,
    ValidityEndDate DATE,
    FOREIGN KEY (PlanID) REFERENCES Plans(PlanID)
);

CREATE TABLE Recharges
(
    RechargeID INT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    PlanID INT,
    Amount DECIMAL(10,2),
    RechargeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID),
    FOREIGN KEY (PlanID) REFERENCES Plans(PlanID)
);
GO

--insert values 
INSERT INTO Plans
VALUES
(1, 'Basic', 99, 28, 1),
(2, 'Unlimited', 299, 84, 1),
(3, 'Premium', 499, 90, 1);

INSERT INTO Subscribers
VALUES
(101, 'Arun', '9876543210', 'Prepaid', 30, 1, DATEADD(DAY, 10, GETDATE())),
(102, 'Priya', '9876543211', 'Prepaid', 150, 2, DATEADD(DAY, 20, GETDATE())),
(103, 'Kavin', '9876543212', 'Postpaid', 500, 3, DATEADD(DAY, 30, GETDATE())),
(104, 'Meena', '9876543213', 'Prepaid', 45, 1, DATEADD(DAY, 5, GETDATE()));

INSERT INTO Recharges (SubscriberID, PlanID, Amount)
VALUES
(101, 1, 99),
(101, 2, 299),
(102, 2, 299),
(104, 1, 99);
GO

--view 1
CREATE OR ALTER VIEW vw_prepaid_subscribers
AS
SELECT
    SubscriberID,
    SubscriberName,
    PhoneNumber,
    Balance,
    PlanID,
    ValidityEndDate
FROM Subscribers
WHERE SubscriberType = 'Prepaid';
GO

SELECT * FROM vw_prepaid_subscribers;
Go

--view 2
CREATE OR ALTER VIEW vw_recharge_summary
AS
SELECT
    s.SubscriberID,
    s.SubscriberName,
    COUNT(r.RechargeID) AS TotalRecharges,
    ISNULL(SUM(r.Amount), 0) AS TotalRechargeAmount
FROM Subscribers s
LEFT JOIN Recharges r
    ON s.SubscriberID = r.SubscriberID
GROUP BY
    s.SubscriberID,
    s.SubscriberName;
GO

SELECT * FROM vw_recharge_summary;
Go

-- Task 2 : Stored procedure 
CREATE OR ALTER PROCEDURE usp_Recharge
    @SubscriberID INT,
    @PlanID INT,
    @Amount DECIMAL(10,2),
    @NewBalance DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ValidityDays INT;
    DECLARE @IsActive BIT;

    BEGIN TRY
        BEGIN TRANSACTION;

  
        IF @Amount <= 0
            THROW 50001, 'Recharge amount must be greater than zero.', 1;

        IF NOT EXISTS
        (
            SELECT 1
            FROM Subscribers WITH (UPDLOCK, HOLDLOCK)
            WHERE SubscriberID = @SubscriberID
              AND SubscriberType = 'Prepaid'
        )
            THROW 50002, 'Prepaid subscriber not found.', 1;

        -- Check plan
        SELECT
            @ValidityDays = ValidityDays,
            @IsActive = IsActive
        FROM Plans
        WHERE PlanID = @PlanID
          AND Amount = @Amount;

        IF @ValidityDays IS NULL OR @IsActive = 0
            THROW 50003, 'Invalid or inactive recharge plan.', 1;

        -- Update balance and validity
        UPDATE Subscribers
        SET Balance = Balance + @Amount,
            PlanID = @PlanID,
            ValidityEndDate =
                DATEADD(DAY, @ValidityDays, CAST(GETDATE() AS DATE))
        WHERE SubscriberID = @SubscriberID;

        -- Get new balance
        SELECT @NewBalance = Balance
        FROM Subscribers
        WHERE SubscriberID = @SubscriberID;

        -- Inserting values into Tables
        INSERT INTO Recharges
        (
            SubscriberID,
            PlanID,
            Amount,
            RechargeDate
        )
        VALUES
        (
            @SubscriberID,
            @PlanID,
            @Amount,
            GETDATE()
        );

        COMMIT TRANSACTION;

        PRINT 'Recharge successful';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        SET @NewBalance = NULL;

        THROW;
    END CATCH;
END;
GO

--execution 
DECLARE @Balance DECIMAL(10,2);

EXEC usp_Recharge
    @SubscriberID = 101,
    @PlanID = 1,
    @Amount = 99,
    @NewBalance = @Balance OUTPUT;

SELECT @Balance AS NewBalance;
Go


--Task 3: Functions 
--scalar function
CREATE OR ALTER FUNCTION dbo.fn_ValidityDaysLeft
(
    @SubscriberID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @DaysLeft INT;

    SELECT @DaysLeft =
        DATEDIFF(DAY, CAST(GETDATE() AS DATE), ValidityEndDate)
    FROM Subscribers
    WHERE SubscriberID = @SubscriberID;

    RETURN @DaysLeft;
END;
GO


select dbo.fn_ValidityDaysLeft(101) as Remaining_days;
Go

--table values function
CREATE OR ALTER FUNCTION dbo.fn_LastFiveRecharges
(
    @SubscriberID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (5)
        RechargeID,
        SubscriberID,
        PlanID,
        Amount,
        RechargeDate
    FROM Recharges
    WHERE SubscriberID = @SubscriberID
    ORDER BY RechargeDate DESC, RechargeID DESC
);
GO

--execution
select * from dbo.fn_LastFiveRecharges(101);


--Task 4: Cursor 
CREATE TABLE NotificationLog
(
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    Message VARCHAR(200),
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0
);
GO


DECLARE
    @SubscriberID INT,
    @SubscriberName VARCHAR(100),
    @Balance DECIMAL(10,2);

DECLARE LowBalanceCursor CURSOR FOR
SELECT SubscriberID, SubscriberName, Balance
FROM Subscribers
WHERE Balance < 50;

OPEN LowBalanceCursor;

FETCH NEXT FROM LowBalanceCursor
INTO @SubscriberID, @SubscriberName, @Balance;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO NotificationLog
        (SubscriberID, Message)
    VALUES
        (
            @SubscriberID,
            'Dear ' + @SubscriberName +
            ', your balance is low. Current balance: ' +
            CAST(@Balance AS VARCHAR(20))
        );

    FETCH NEXT FROM LowBalanceCursor
    INTO @SubscriberID, @SubscriberName, @Balance;
END;

CLOSE LowBalanceCursor;
DEALLOCATE LowBalanceCursor;
GO
SELECT * FROM NotificationLog;


INSERT INTO NotificationLog (SubscriberID, Message)
SELECT
    SubscriberID,
    'Dear ' + SubscriberName +
    ', your balance is low. Current balance: ' +
    CAST(Balance AS VARCHAR(20))
FROM Subscribers
WHERE Balance < 50;
GO
SELECT * FROM NotificationLog;


