--Task 1 : views 
--view 1:  order summary
CREATE VIEW vw_order_summary
AS
SELECT
    o.OrderID,
    o.CustomerName,
    o.OrderDate,
    oi.ProductID,
    oi.Quantity,
    oi.UnitPrice,
    (oi.Quantity * oi.UnitPrice) AS TotalAmount
FROM Orders o
JOIN OrderItems oi
    ON o.OrderID = oi.OrderID;
GO
SELECT * FROM vw_order_summary;

--view 2 :low stock products
go
CREATE VIEW vw_low_stock
AS
SELECT
    ProductID,
    ProductName,
    StockQuantity,
    UnitPrice
FROM Products
WHERE StockQuantity < 10 with check option;
GO
-- update using with check option
UPDATE vw_low_stock
SET StockQuantity = 8
WHERE ProductID = 103;
SELECT * FROM vw_low_stock;

 -- Task 2 : stored procedure 
CREATE TYPE OrderLineType AS TABLE
(
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);
GO

CREATE OR ALTER PROCEDURE usp_PlaceOrder
    @CustomerName VARCHAR(100),
    @OrderLines OrderLineType READONLY,
    @OrderID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM @OrderLines)
            THROW 50002, 'Order must contain at least one item.', 1;

        IF EXISTS
        (
            SELECT 1
            FROM @OrderLines
            WHERE Quantity <= 0 OR UnitPrice <= 0
        )
            THROW 50003, 'Invalid order item details.', 1;

        IF EXISTS
        (
            SELECT 1
            FROM @OrderLines ol
            LEFT JOIN Products p WITH (UPDLOCK, HOLDLOCK)
                ON p.ProductID = ol.ProductID
            WHERE p.ProductID IS NULL
               OR p.StockQuantity < ol.Quantity
        )
            THROW 50001, 'Insufficient stock or invalid product.', 1;

        INSERT INTO Orders (CustomerName, OrderDate)
        VALUES (@CustomerName, GETDATE());

        SET @OrderID = SCOPE_IDENTITY();

        UPDATE p
        SET p.StockQuantity = p.StockQuantity - ol.Quantity
        FROM Products p
        JOIN @OrderLines ol
            ON p.ProductID = ol.ProductID;

        INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
        SELECT @OrderID, ProductID, Quantity, UnitPrice
        FROM @OrderLines;

        COMMIT TRANSACTION;

        PRINT 'Order placed successfully';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        SET @OrderID = NULL;
        THROW;
    END CATCH;
END;
GO
--run 
DECLARE @Items OrderLineType;
DECLARE @NewOrderID INT;

INSERT INTO @Items (ProductID, Quantity, UnitPrice)
VALUES
    (101, 2, 800),
    (102, 1, 1500);

EXEC usp_PlaceOrder
    @CustomerName = 'Gayathri',
    @OrderLines = @Items,
    @OrderID = @NewOrderID OUTPUT;

SELECT @NewOrderID AS GeneratedOrderID;


-- Task 3: Functions 
--scalar functions
go
CREATE OR ALTER FUNCTION fn_OrderTotalWithTax
(
    @OrderID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total =
        SUM(Quantity * UnitPrice) * 1.18
    FROM OrderItems
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO
SELECT dbo.fn_OrderTotalWithTax(1) AS TotalWithTax;


go
CREATE OR ALTER FUNCTION fn_CustomerOrders
(
    @CustomerName VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        o.OrderID,
        o.CustomerName,
        o.OrderDate,
        SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
    FROM Orders o
    JOIN OrderItems oi
        ON o.OrderID = oi.OrderID
    WHERE o.CustomerName = @CustomerName
    GROUP BY
        o.OrderID,
        o.CustomerName,
        o.OrderDate
);
GO

--run the function
SELECT *
FROM dbo.fn_CustomerOrders('Gayathri');

-- Task 4 : Cursor 
CREATE TABLE OrderFollowUps
(
    FollowUpID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    FollowUpDate DATE DEFAULT GETDATE(),
    Remarks VARCHAR(200)
);
GO
ALTER TABLE Orders
ADD OrderStatus VARCHAR(20) NOT NULL
    CONSTRAINT DF_Orders_OrderStatus DEFAULT 'Pending';
GO

--cursor procedure 
CREATE OR ALTER PROCEDURE usp_CreateOrderFollowUps
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;

    DECLARE OrderCursor CURSOR FOR
        SELECT OrderID
        FROM Orders
        WHERE OrderStatus = 'Pending'
          AND OrderDate < DATEADD(DAY, -3, GETDATE());

    OPEN OrderCursor;

    FETCH NEXT FROM OrderCursor INTO @OrderID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO OrderFollowUps (OrderID, Remarks)
        VALUES (@OrderID, 'Follow-up required for pending order');

        FETCH NEXT FROM OrderCursor INTO @OrderID;
    END;

    CLOSE OrderCursor;
    DEALLOCATE OrderCursor;
END;
GO

EXEC usp_CreateOrderFollowUps;
SELECT * FROM OrderFollowUps;


INSERT INTO OrderFollowUps (OrderID, Remarks)
SELECT
    OrderID,
    'Follow-up required for pending order'
FROM Orders
WHERE OrderStatus = 'Pending'
  AND OrderDate < DATEADD(DAY, -3, GETDATE());
