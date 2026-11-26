use retaildb;

--Creating Tables
CREATE TABLE PriceAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangedBy VARCHAR(100),
    ChangedAt DATETIME DEFAULT GETDATE()
);
GO
CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    UnitPrice DECIMAL(10,2),
    CostPrice DECIMAL(10,2)
);

--Inserting Values into Tables
INSERT INTO Products
    (ProductID, ProductName, UnitPrice, CostPrice)
VALUES
    (1, 'Laptop', 50000, 40000),
    (2, 'Mobile', 20000, 15000),
    (3, 'Keyboard', 1500, 1000),
    (4, 'Mouse', 800, 500);

SELECT * FROM Products;


-- Task 1: After update Trigger 
CREATE OR ALTER TRIGGER trg_ProductPriceAudit
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PriceAudit
    (
        ProductID,
        OldPrice,
        NewPrice,
        ChangedBy,
        ChangedAt
    )
    SELECT
        d.ProductID,
        d.UnitPrice,
        i.UnitPrice,
        SUSER_SNAME(),
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i
        ON d.ProductID = i.ProductID
    WHERE d.UnitPrice <> i.UnitPrice;
END;



UPDATE Products
SET UnitPrice = 200
WHERE ProductID = 1;
SELECT * FROM PriceAudit;
UPDATE Products
SET UnitPrice = UnitPrice + 10
WHERE ProductID IN (1, 2, 3);


-- Task 2 : Instead of Trigger 
CREATE TABLE RejectedPriceAttempts
(
    AttemptID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    OldPrice DECIMAL(10,2),
    AttemptedPrice DECIMAL(10,2),
    CostPrice DECIMAL(10,2),
    AttemptedBy VARCHAR(100),
    AttemptedAt DATETIME DEFAULT GETDATE(),
    RejectionReason VARCHAR(200)
);



CREATE OR ALTER TRIGGER trg_ValidateProductPrice
ON Products
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;


    INSERT INTO RejectedPriceAttempts
    (
        ProductID,
        OldPrice,
        AttemptedPrice,
        CostPrice,
        AttemptedBy,
        RejectionReason
    )
    SELECT
        i.ProductID,
        d.UnitPrice,
        i.UnitPrice,
        i.CostPrice,
        SUSER_SNAME(),
        'Selling price cannot be below cost price'
    FROM inserted i
    INNER JOIN deleted d
        ON i.ProductID = d.ProductID
    WHERE i.UnitPrice < i.CostPrice;

 
    UPDATE p
    SET
        p.ProductName = i.ProductName,
        p.UnitPrice = i.UnitPrice,
        p.CostPrice = i.CostPrice
    FROM Products p
    INNER JOIN inserted i
        ON p.ProductID = i.ProductID
    WHERE i.UnitPrice >= i.CostPrice;
END;
GO

UPDATE Products
SET UnitPrice = 35000
WHERE ProductID = 1;
SELECT * FROM RejectedPriceAttempts;
SELECT * FROM Products
WHERE ProductID = 1;
 
UPDATE Products
SET UnitPrice = 45000
WHERE ProductID = 1;
SELECT * FROM PriceAudit;

-- Task 3 : Single row and multi row updates 
 
UPDATE Products
SET UnitPrice = 900
WHERE ProductID = 4;
SELECT * FROM Products
WHERE ProductID = 4;
SELECT * FROM PriceAudit
WHERE ProductID = 4;


UPDATE Products
SET UnitPrice =
    CASE ProductID
        WHEN 1 THEN 35000
        WHEN 2 THEN 21000
        WHEN 3 THEN 900
    END
WHERE ProductID IN (1, 2, 3);
SELECT * FROM Products
WHERE ProductID IN (1, 2, 3);
SELECT * FROM PriceAudit
ORDER BY AuditID DESC;
