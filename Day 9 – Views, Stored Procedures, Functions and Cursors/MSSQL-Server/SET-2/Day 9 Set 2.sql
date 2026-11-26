Create database newdb
use newdb

--table creation
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    AadhaarNumber VARCHAR(20)
);

CREATE TABLE Policies
(
    PolicyID INT PRIMARY KEY,
    CustomerID INT,
    RenewalDate DATE,
    PremiumAmount DECIMAL(10,2),
    PolicyStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

--insert values
INSERT INTO Customers
VALUES
(1, 'Arun', 'arun@gmail.com', '9876543210', 'XXXX1111'),
(2, 'Priya', 'priya@gmail.com', '9876543211', 'XXXX2222'),
(3, 'Kavin', 'kavin@gmail.com', '9876543212', 'XXXX3333');

INSERT INTO Policies
VALUES
(101, 1, DATEADD(DAY, 10, GETDATE()), 5000, 'Active'),
(102, 2, DATEADD(DAY, 20, GETDATE()), 7000, 'Active'),
(103, 3, DATEADD(DAY, 45, GETDATE()), 6000, 'Active');
GO


--Task 1: Creating views
CREATE OR ALTER VIEW vw_policy_due
AS
SELECT
    p.PolicyID,
    c.CustomerName,
    c.Email,
    c.Phone,
    p.RenewalDate,
    p.PremiumAmount,
    p.PolicyStatus
FROM Policies p
JOIN Customers c
    ON p.CustomerID = c.CustomerID
WHERE p.RenewalDate >= CAST(GETDATE() AS DATE)
  AND p.RenewalDate <= DATEADD(DAY, 30, CAST(GETDATE() AS DATE));
GO

SELECT * FROM vw_policy_due;

--Task 2 : Stored Procedure
CREATE TABLE PolicyClaims
(
    ClaimID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID INT,
    ClaimStatus VARCHAR(20),
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);
GO
CREATE TABLE PolicyRenewalAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID INT,
    OldPremium DECIMAL(10,2),
    NewPremium DECIMAL(10,2),
    RenewalDate DATE,
    RenewedAt DATETIME DEFAULT GETDATE()
);
GO

--stored procedure with transaction
CREATE OR ALTER PROCEDURE usp_RenewPolicy
    @PolicyID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @OldPremium DECIMAL(10,2);
    DECLARE @NewPremium DECIMAL(10,2);
    DECLARE @RenewalDate DATE;
    DECLARE @PolicyStatus VARCHAR(20);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Get policy details and lock the policy row
        SELECT
            @OldPremium = PremiumAmount,
            @RenewalDate = RenewalDate,
            @PolicyStatus = PolicyStatus
        FROM Policies WITH (UPDLOCK, HOLDLOCK)
        WHERE PolicyID = @PolicyID;

        -- Check whether policy exists
        IF @OldPremium IS NULL
            THROW 50001, 'Policy not found.', 1;

        -- Check whether policy is active
        IF @PolicyStatus <> 'Active'
            THROW 50002, 'Policy is not active.', 1;

        -- Check for pending claims
        IF EXISTS
        (
            SELECT 1
            FROM PolicyClaims
            WHERE PolicyID = @PolicyID
              AND ClaimStatus = 'Pending'
        )
            THROW 50003, 'Policy has pending claims.', 1;

     
        SET @NewPremium = @OldPremium * 1.05;

        -- Update policy
        UPDATE Policies
        SET PremiumAmount = @NewPremium,
            RenewalDate = DATEADD(YEAR, 1, @RenewalDate)
        WHERE PolicyID = @PolicyID;

        -- Insert audit record
        INSERT INTO PolicyRenewalAudit
        (
            PolicyID,
            OldPremium,
            NewPremium,
            RenewalDate
        )
        VALUES
        (
            @PolicyID,
            @OldPremium,
            @NewPremium,
            DATEADD(YEAR, 1, @RenewalDate)
        );

        COMMIT TRANSACTION;

        PRINT 'Policy renewed successfully';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

 
EXEC usp_RenewPolicy @PolicyID = 101;

-- Check updated policy
SELECT *
FROM Policies
WHERE PolicyID = 101;

-- Check audit record
SELECT *
FROM PolicyRenewalAudit
WHERE PolicyID = 101;
Go


 -- Task 3 : functions 
--scalar function
CREATE OR ALTER FUNCTION fn_PremiumWithNoClaimDiscount
(
    @PolicyID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Premium DECIMAL(10,2);

    SELECT @Premium = PremiumAmount
    FROM Policies
    WHERE PolicyID = @PolicyID;

    IF @Premium IS NULL
        RETURN NULL;

    -- Give 10% discount if there are no claims
    IF NOT EXISTS
    (
        SELECT 1
        FROM PolicyClaims
        WHERE PolicyID = @PolicyID
    )
    BEGIN
        SET @Premium = @Premium * 0.90;
    END;

    RETURN @Premium;
END;
GO


SELECT dbo.fn_PremiumWithNoClaimDiscount(101)
AS PremiumAfterDiscount;



ALTER TABLE Policies
ADD AgentID INT;
GO
UPDATE Policies
SET AgentID = 1
WHERE PolicyID IN (101, 102);

UPDATE Policies
SET AgentID = 2
WHERE PolicyID = 103;
GO
--function
CREATE OR ALTER FUNCTION fn_AgentRenewalQuotes
(
    @AgentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.PolicyID,
        c.CustomerName,
        p.RenewalDate,
        p.PremiumAmount AS CurrentPremium,
        dbo.fn_PremiumWithNoClaimDiscount(p.PolicyID)
            AS RenewalQuote
    FROM Policies p
    JOIN Customers c
        ON p.CustomerID = c.CustomerID
    WHERE p.AgentID = @AgentID
);
GO

--execution
SELECT *
FROM dbo.fn_AgentRenewalQuotes(1);


--Task 4: cursor
CREATE TABLE PolicyStatusAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID INT,
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

--cursor
CREATE OR ALTER PROCEDURE usp_UpdateLapsedPolicies
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PolicyID INT;

    DECLARE PolicyCursor CURSOR FOR
        SELECT PolicyID
        FROM Policies
        WHERE RenewalDate < CAST(GETDATE() AS DATE)
          AND PolicyStatus = 'Active';

    OPEN PolicyCursor;

    FETCH NEXT FROM PolicyCursor INTO @PolicyID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Policies
        SET PolicyStatus = 'Lapsed'
        WHERE PolicyID = @PolicyID
          AND PolicyStatus = 'Active';

        IF @@ROWCOUNT = 1
        BEGIN
            INSERT INTO PolicyStatusAudit
                (PolicyID, OldStatus, NewStatus)
            VALUES
                (@PolicyID, 'Active', 'Lapsed');
        END;

        FETCH NEXT FROM PolicyCursor INTO @PolicyID;
    END;

    CLOSE PolicyCursor;
    DEALLOCATE PolicyCursor;
END;
GO

EXEC usp_UpdateLapsedPolicies;

SELECT * FROM Policies;
SELECT * FROM PolicyStatusAudit;


UPDATE Policies
SET PolicyStatus = 'Lapsed'
OUTPUT
    deleted.PolicyID,
    deleted.PolicyStatus,
    inserted.PolicyStatus,
    GETDATE()
INTO PolicyStatusAudit
(
    PolicyID,
    OldStatus,
    NewStatus,
    UpdatedAt
)
WHERE RenewalDate < CAST(GETDATE() AS DATE)
  AND PolicyStatus = 'Active';


--------------------------------------------------------------------------------------------------------------------------------------------------
