-- Creating Database
CREATE DATABASE RetailDB;
USE Retail DB;

-- Creating Tables

CREATE TABLE Categories
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),

    FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Orders
(
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT SYSDATETIME(),
    OrderStatus VARCHAR(20) DEFAULT 'PLACED',

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderLines
(
    OrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),

    FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

-- Inserting values into Tables

INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home Appliances');

INSERT INTO Products VALUES
(101, 'Laptop', 1, 50, 55000),
(102, 'Mobile Phone', 1, 100, 25000),
(103, 'Headphones', 1, 20, 2000),
(104, 'T-Shirt', 2, 80, 800),
(105, 'Jeans', 2, 30, 1500),
(106, 'Jacket', 2, 10, 3000),
(107, 'Mixer Grinder', 3, 40, 3500),
(108, 'Microwave Oven', 3, 15, 9000),
(109, 'Electric Kettle', 3, 25, 1800);

INSERT INTO Customers VALUES
(1, 'Arun', 'arun@gmail.com'),
(2, 'Bala', 'bala@gmail.com'),
(3, 'Charan', 'charan@gmail.com'),
(4, 'Deepa', 'deepa@gmail.com'),
(5, 'Elango', 'elango@gmail.com');

INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
VALUES
(1, '2026-01-10', 'PAID'),
(2, '2026-01-15', 'PAID'),
(3, '2026-02-05', 'PAID'),
(4, '2026-02-18', 'PAID'),
(5, '2026-03-08', 'PAID'),
(1, '2026-03-20', 'PAID');

INSERT INTO OrderLines (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 101, 2, 55000),
(1, 103, 3, 2000),

(2, 102, 2, 25000),
(2, 104, 5, 800),

(3, 101, 1, 55000),
(3, 105, 3, 1500),

(4, 102, 3, 25000),
(4, 107, 2, 3500),

(5, 103, 5, 2000),
(5, 106, 2, 3000),

(6, 101, 1, 55000),
(6, 108, 2, 9000);

-- Question 1: Write a transaction to decrement stock, insert the order and order lines; prove rollback when stock is insufficient

DECLARE @CustomerID INT = 2;
DECLARE @OrderID INT;

-- Products and quantities requested in this order
DECLARE @OrderItems TABLE
(
    ProductID INT PRIMARY KEY,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

-- Test with 999 to demonstrate rollback.
-- Change 999 to 2 to test a successful order.
INSERT INTO @OrderItems VALUES
(103, 999, 2000);

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Check whether every requested product exists
    -- and has sufficient stock.
    IF EXISTS
    (
        SELECT 1
        FROM @OrderItems OI
        LEFT JOIN Products P WITH (UPDLOCK, HOLDLOCK)
            ON P.ProductID = OI.ProductID
        WHERE P.ProductID IS NULL
           OR P.StockQuantity < OI.Quantity
    )
    BEGIN
        THROW 50001, 'Insufficient stock or invalid product.', 1;
    END;

   
    UPDATE P
    SET P.StockQuantity = P.StockQuantity - OI.Quantity
    FROM Products P
    JOIN @OrderItems OI
        ON P.ProductID = OI.ProductID;

    -- Inserting Values
    INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
    VALUES (@CustomerID, SYSDATETIME(), 'PLACED');

    SET @OrderID = SCOPE_IDENTITY();

    -- Inserting Values
    INSERT INTO OrderLines (OrderID, ProductID, Quantity, UnitPrice)
    SELECT @OrderID, ProductID, Quantity, UnitPrice
    FROM @OrderItems;

    COMMIT TRANSACTION;

    PRINT 'Order placed successfully.';
END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT 'Transaction failed.';
    PRINT ERROR_MESSAGE();

END CATCH;

-- Question 2: Use a correlated subquery to list products whose stock is below the average for their category
SELECT
    P.ProductID,
    P.ProductName,
    C.CategoryName,
    P.StockQuantity
FROM Products P
JOIN Categories C
    ON P.CategoryID = C.CategoryID
WHERE P.StockQuantity <
(
    SELECT AVG(P2.StockQuantity)
    FROM Products P2
    WHERE P2.CategoryID = P.CategoryID
);


-- Question 3: Use a CTE to rank products by sales within each category and return the top three
WITH ProductSales AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        P.CategoryID,
        C.CategoryName,
        SUM(OL.Quantity * OL.UnitPrice) AS TotalSales
    FROM Products P
    JOIN Categories C
        ON P.CategoryID = C.CategoryID
    JOIN OrderLines OL
        ON P.ProductID = OL.ProductID
    JOIN Orders O
        ON OL.OrderID = O.OrderID
    WHERE O.OrderStatus = 'PAID'
    GROUP BY
        P.ProductID,
        P.ProductName,
        P.CategoryID,
        C.CategoryName
),
RankedProducts AS
(
    SELECT
        ProductID,
        ProductName,
        CategoryName,
        TotalSales,
        ROW_NUMBER() OVER
        (
            PARTITION BY CategoryID
            ORDER BY TotalSales DESC, ProductID
        ) AS ProductRank
    FROM ProductSales
)
SELECT
    ProductID,
    ProductName,
    CategoryName,
    TotalSales,
    ProductRank
FROM RankedProducts
WHERE ProductRank <= 3
ORDER BY CategoryName, ProductRank;

-- Question 4: Use LEAD/LAG to show month-on-month sales changes for each product
WITH MonthlySales AS
(
    SELECT
        OL.ProductID,
        P.ProductName,
        DATEFROMPARTS(
            YEAR(O.OrderDate),
            MONTH(O.OrderDate),
            1
        ) AS SalesMonth,
        SUM(OL.Quantity * OL.UnitPrice) AS MonthlySales
    FROM Orders O
    JOIN OrderLines OL
        ON O.OrderID = OL.OrderID
    JOIN Products P
        ON OL.ProductID = P.ProductID
    WHERE O.OrderStatus = 'PAID'
    GROUP BY
        OL.ProductID,
        P.ProductName,
        YEAR(O.OrderDate),
        MONTH(O.OrderDate)
),
SalesComparison AS
(
    SELECT
        ProductID,
        ProductName,
        SalesMonth,
        MonthlySales,

        LAG(MonthlySales) OVER
        (
            PARTITION BY ProductID
            ORDER BY SalesMonth
        ) AS PreviousMonthSales,

        LEAD(MonthlySales) OVER
        (
            PARTITION BY ProductID
            ORDER BY SalesMonth
        ) AS NextMonthSales

    FROM MonthlySales
)
SELECT
    ProductID,
    ProductName,
    SalesMonth,
    MonthlySales,
    PreviousMonthSales,

    MonthlySales - PreviousMonthSales AS MonthOnMonthChange,

    NextMonthSales
FROM SalesComparison
ORDER BY ProductID, SalesMonth;

