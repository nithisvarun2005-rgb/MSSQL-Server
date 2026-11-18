-- Creating Database
CREATE DATABASE RetailReturnsDB;
USE RetailReturnsDB;

-- Creating Tables
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Phone VARCHAR(15)
);

CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2) NOT NULL
);

CREATE TABLE Stores
(
    StoreID INT PRIMARY KEY,
    StoreName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    JobRole VARCHAR(50),
    ManagerID INT NULL,

    FOREIGN KEY (ManagerID)
        REFERENCES Employees(EmployeeID)
);

CREATE TABLE Sales
(
    SaleID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    StoreID INT NOT NULL,
    EmployeeID INT NOT NULL,
    SaleDate DATE NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    FOREIGN KEY (StoreID)
        REFERENCES Stores(StoreID),

    FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

CREATE TABLE SaleItems
(
    SaleItemID INT PRIMARY KEY,
    SaleID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (SaleID)
        REFERENCES Sales(SaleID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    CHECK (Quantity > 0),
    CHECK (UnitPrice > 0)
);

CREATE TABLE Returns
(
    ReturnID INT PRIMARY KEY,
    SaleID INT NOT NULL,
    ReturnDate DATE NOT NULL,
    ReturnReason VARCHAR(200),
    ReturnStatus VARCHAR(30),

    FOREIGN KEY (SaleID)
        REFERENCES Sales(SaleID)
);

CREATE TABLE ReturnItems
(
    ReturnItemID INT PRIMARY KEY,
    ReturnID INT NOT NULL,
    SaleItemID INT NOT NULL,
    ReturnQuantity INT NOT NULL,

    FOREIGN KEY (ReturnID)
        REFERENCES Returns(ReturnID),

    FOREIGN KEY (SaleItemID)
        REFERENCES SaleItems(SaleItemID),

    CHECK (ReturnQuantity > 0)
);

CREATE TABLE Refunds
(
    RefundID INT PRIMARY KEY,
    ReturnID INT NOT NULL,
    RefundDate DATE NULL,
    RefundAmount DECIMAL(10,2) NOT NULL,
    RefundStatus VARCHAR(30),

    FOREIGN KEY (ReturnID)
        REFERENCES Returns(ReturnID),

    CHECK (RefundAmount >= 0)
);

CREATE TABLE ReturnFeedback
(
    FeedbackID INT PRIMARY KEY,
    ReturnID INT NOT NULL,
    FeedbackDate DATE NOT NULL,
    Rating INT,
    Comments VARCHAR(300),

    FOREIGN KEY (ReturnID)
        REFERENCES Returns(ReturnID),

    CHECK (Rating BETWEEN 1 AND 5)
);

-- Inserting Values Into Tables
INSERT INTO Customers
VALUES
(1, 'Arun Kumar', 'Chennai', '9876543210'),
(2, 'Priya Sharma', 'Coimbatore', '9876543211'),
(3, 'Karthik Raj', 'Madurai', '9876543212'),
(4, 'Divya Sri', 'Salem', '9876543213'),
(5, 'Rahul Kumar', 'Trichy', '9876543214'),
(6, 'Sneha Devi', 'Chennai', '9876543215'),
(7, 'Vijay Anand', 'Erode', '9876543216'),
(8, 'Meena Rani', 'Tiruppur', '9876543217'),
(9, 'Sanjay Kumar', 'Madurai', '9876543218'),
(10, 'Nisha Devi', 'Salem', '9876543219');

INSERT INTO Products
VALUES
(101, 'Laptop', 'Electronics', 50000),
(102, 'Mobile Phone', 'Electronics', 20000),
(103, 'Headphones', 'Accessories', 3000),
(104, 'Office Chair', 'Furniture', 8000),
(105, 'Keyboard', 'Accessories', 1500),
(106, 'Monitor', 'Electronics', 12000);

INSERT INTO Stores
VALUES
(1, 'Chennai Central', 'Chennai', 'South'),
(2, 'Coimbatore Mall', 'Coimbatore', 'South'),
(3, 'Mumbai Central', 'Mumbai', 'West'),
(4, 'Pune Mall', 'Pune', 'West'),
(5, 'Delhi Central', 'Delhi', 'North'),
(6, 'Jaipur Mall', 'Jaipur', 'North');

INSERT INTO Employees
VALUES
(1, 'Ramesh', 'Store Manager', NULL),
(2, 'Suresh', 'Store Manager', NULL),
(3, 'Ganesh', 'Regional Manager', NULL);

INSERT INTO Employees
VALUES
(4, 'Kumar', 'Sales Executive', 1),
(5, 'Priya', 'Sales Executive', 1),
(6, 'Divya', 'Sales Executive', 2),
(7, 'Arun', 'Sales Executive', 2),
(8, 'Meena', 'Sales Executive', 3);

INSERT INTO Sales
VALUES
(1001, 1, 1, 4, '2026-01-05'),
(1002, 2, 1, 5, '2026-01-08'),
(1003, 3, 2, 6, '2026-01-10'),
(1004, 4, 2, 6, '2026-01-12'),
(1005, 5, 3, 7, '2026-01-15'),
(1006, 6, 3, 7, '2026-01-18'),
(1007, 7, 4, 8, '2026-01-20'),
(1008, 8, 4, 8, '2026-01-22'),
(1009, 9, 5, 4, '2026-01-25'),
(1010, 10, 5, 5, '2026-01-28'),
(1011, 1, 6, 6, '2026-02-01'),
(1012, 2, 6, 6, '2026-02-03');

INSERT INTO SaleItems
VALUES
(1, 1001, 101, 10, 50000),
(2, 1001, 102, 10, 20000),
(3, 1002, 101, 10, 50000),
(4, 1002, 103, 10, 3000),
(5, 1003, 102, 10, 20000),
(6, 1003, 104, 10, 8000),
(7, 1004, 103, 10, 3000),
(8, 1004, 105, 10, 1500),
(9, 1005, 101, 10, 50000),
(10, 1005, 106, 10, 12000),
(11, 1006, 102, 10, 20000),
(12, 1006, 103, 10, 3000),
(13, 1007, 104, 10, 8000),
(14, 1007, 105, 10, 1500),
(15, 1008, 101, 10, 50000),
(16, 1008, 102, 10, 20000),
(17, 1009, 103, 10, 3000),
(18, 1009, 106, 10, 12000),
(19, 1010, 104, 10, 8000),
(20, 1010, 105, 10, 1500),
(21, 1011, 101, 10, 50000),
(22, 1011, 103, 10, 3000),
(23, 1012, 102, 10, 20000),
(24, 1012, 106, 10, 12000);

INSERT INTO ReturnItems
VALUES
(1, 201, 1, 3),
(2, 201, 2, 1),
(3, 202, 3, 2),
(4, 203, 5, 3),
(5, 204, 7, 2),
(6, 205, 9, 2),
(7, 206, 11, 1),
(8, 207, 13, 2),
(9, 208, 15, 3),
(10, 209, 17, 2),
(11, 210, 19, 1),
(12, 211, 21, 2);

INSERT INTO Refunds
VALUES
(301, 201, '2026-02-05', 170000, 'Completed'),
(302, 202, '2026-02-06', 100000, 'Completed'),
(303, 203, '2026-02-08', 60000, 'Completed'),
(304, 205, '2026-02-13', 100000, 'Completed'),
(305, 207, '2026-02-18', 16000, 'Completed'),
(306, 208, '2026-02-20', 210000, 'Completed'),
(307, 210, '2026-02-25', 8000, 'Pending'),
(308, 211, '2026-02-28', 100000, 'Completed');

INSERT INTO ReturnFeedback
VALUES
(401, 201, '2026-02-06', 2, 'Product quality was poor'),
(402, 202, '2026-02-07', 3, 'Wrong product received'),
(403, 203, '2026-02-09', 1, 'Product stopped working'),
(404, 204, '2026-02-10', 3, 'Return is still pending'),
(405, 205, '2026-02-14', 2, 'Product was damaged'),
(406, 206, '2026-02-15', 4, 'Changed my mind'),
(407, 207, '2026-02-19', 2, 'Not satisfied'),
(408, 208, '2026-02-21', 3, 'Incorrect delivery'),
(409, 209, '2026-02-23', 2, 'Waiting for refund'),
(410, 210, '2026-02-26', 4, 'Refund is pending');

-- Question1. Ten SQL reporting questions
-- Find products with a return rate above 10%
WITH ReturnedQuantity AS
(
    SELECT
        SaleItemID,
        SUM(ReturnQuantity) AS TotalReturned
    FROM ReturnItems
    GROUP BY SaleItemID
)
SELECT
    P.ProductID,
    P.ProductName,
    SUM(SI.Quantity) AS TotalSold,
    SUM(COALESCE(RQ.TotalReturned, 0)) AS TotalReturned,
    CAST(
        SUM(COALESCE(RQ.TotalReturned, 0)) * 100.0 /
        NULLIF(SUM(SI.Quantity), 0)
        AS DECIMAL(10,2)
    ) AS ReturnRate
FROM Products P
INNER JOIN SaleItems SI
    ON P.ProductID = SI.ProductID
LEFT JOIN ReturnedQuantity RQ
    ON SI.SaleItemID = RQ.SaleItemID
GROUP BY
    P.ProductID,
    P.ProductName
HAVING
    SUM(COALESCE(RQ.TotalReturned, 0)) * 100.0 /
    NULLIF(SUM(SI.Quantity), 0) > 10;

-- 2. Find customers who returned products but have no refund record
SELECT DISTINCT
    C.CustomerID,
    C.CustomerName
FROM Customers C
INNER JOIN Sales S
    ON C.CustomerID = S.CustomerID
INNER JOIN Returns R
    ON S.SaleID = R.SaleID
WHERE NOT EXISTS
(
    SELECT 1
    FROM Refunds RF
    WHERE RF.ReturnID = R.ReturnID
);

-- 3. Find the store with the highest total refund value
SELECT TOP 1 WITH TIES
    ST.StoreID,
    ST.StoreName,
    SUM(RF.RefundAmount) AS TotalRefundValue
FROM Stores ST
INNER JOIN Sales S
    ON ST.StoreID = S.StoreID
INNER JOIN Returns R
    ON S.SaleID = R.SaleID
INNER JOIN Refunds RF
    ON R.ReturnID = RF.ReturnID
GROUP BY
    ST.StoreID,
    ST.StoreName
ORDER BY
    SUM(RF.RefundAmount) DESC;

-- 4. Display employees and their managers
SELECT
    E.EmployeeID,
    E.EmployeeName,
    E.JobRole,
    M.EmployeeName AS ManagerName
FROM Employees E
LEFT JOIN Employees M
    ON E.ManagerID = M.EmployeeID;

-- 5. Display all returns with customer and product details
SELECT
    R.ReturnID,
    C.CustomerName,
    P.ProductName,
    RI.ReturnQuantity,
    R.ReturnDate,
    R.ReturnReason,
    R.ReturnStatus
FROM Returns R
INNER JOIN Sales S
    ON R.SaleID = S.SaleID
INNER JOIN Customers C
    ON S.CustomerID = C.CustomerID
INNER JOIN ReturnItems RI
    ON R.ReturnID = RI.ReturnID
INNER JOIN SaleItems SI
    ON RI.SaleItemID = SI.SaleItemID
INNER JOIN Products P
    ON SI.ProductID = P.ProductID;

-- 6. Find total refunds for each store
SELECT
    ST.StoreID,
    ST.StoreName,
    COALESCE(SUM(F.RefundAmount), 0) AS TotalRefund
FROM Stores ST
LEFT JOIN Sales S
    ON ST.StoreID = S.StoreID
LEFT JOIN Returns R
    ON S.SaleID = R.SaleID
LEFT JOIN Refunds F
    ON R.ReturnID = F.ReturnID
GROUP BY ST.StoreID, ST.StoreName
ORDER BY TotalRefund DESC;

-- 7. Find customers who have returned more than one product
SELECT
    C.CustomerID,
    C.CustomerName,
    SUM(RI.ReturnQuantity) AS TotalReturnedQuantity
FROM Customers C
INNER JOIN Sales S
    ON C.CustomerID = S.CustomerID
INNER JOIN Returns R
    ON S.SaleID = R.SaleID
INNER JOIN ReturnItems RI
    ON R.ReturnID = RI.ReturnID
GROUP BY C.CustomerID, C.CustomerName
HAVING SUM(RI.ReturnQuantity) > 1;

-- 8. Find returns with no refund record
SELECT
    R.ReturnID,
    R.SaleID,
    R.ReturnDate,
    R.ReturnReason,
    R.ReturnStatus
FROM Returns R
LEFT JOIN Refunds F
    ON R.ReturnID = F.ReturnID
WHERE F.RefundID IS NULL;

-- 9. Find products whose return quantity is greater than the average return quantity per product
SELECT
    P.ProductID,
    P.ProductName,
    SUM(RI.ReturnQuantity) AS TotalReturnedQuantity
FROM Products P
INNER JOIN SaleItems SI
    ON P.ProductID = SI.ProductID
INNER JOIN ReturnItems RI
    ON SI.SaleItemID = RI.SaleItemID
GROUP BY P.ProductID, P.ProductName
HAVING SUM(RI.ReturnQuantity) >
(
    SELECT AVG(ProductReturn.TotalReturned)
    FROM
    (
        SELECT
            SUM(RI2.ReturnQuantity) AS TotalReturned
        FROM SaleItems SI2
        INNER JOIN ReturnItems RI2
            ON SI2.SaleItemID = RI2.SaleItemID
        GROUP BY SI2.ProductID
    ) AS ProductReturn
);

-- 10. Generate a complete return and refund report
SELECT
    R.ReturnID,
    R.ReturnDate,
    C.CustomerName,
    ST.StoreName,
    P.ProductName,
    RI.ReturnQuantity,
    R.ReturnStatus,
    F.RefundAmount,
    F.RefundStatus,
    E.EmployeeName
FROM Returns R
INNER JOIN Sales S
    ON R.SaleID = S.SaleID
INNER JOIN Customers C
    ON S.CustomerID = C.CustomerID
INNER JOIN Stores ST
    ON S.StoreID = ST.StoreID
INNER JOIN Employees E
    ON S.EmployeeID = E.EmployeeID
INNER JOIN ReturnItems RI
    ON R.ReturnID = RI.ReturnID
INNER JOIN SaleItems SI
    ON RI.SaleItemID = SI.SaleItemID
INNER JOIN Products P
    ON SI.ProductID = P.ProductID
LEFT JOIN Refunds F
    ON R.ReturnID = F.ReturnID
ORDER BY R.ReturnDate;

-- Question.2 – IN, NOT IN, NULL pitfall and NOT EXISTS
-- 1. Find customers who made at least one return using IN
SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID IN
(
    SELECT S.CustomerID
    FROM Sales S
    INNER JOIN Returns R
        ON S.SaleID = R.SaleID
);

-- 2. Find customers who never made a return using NOT IN
SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID NOT IN
(
    SELECT S.CustomerID
    FROM Sales S
    INNER JOIN Returns R
        ON S.SaleID = R.SaleID
);

-- 3. Demonstrate the NULL problem with NOT IN
SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID NOT IN
(
    SELECT CAST(NULL AS INT)
);

-- 4. Correct the NULL problem using NOT EXISTS
SELECT
    C.CustomerID,
    C.CustomerName
FROM Customers C
WHERE NOT EXISTS
(
    SELECT 1
    FROM Sales S
    INNER JOIN Returns R
        ON S.SaleID = R.SaleID
    WHERE S.CustomerID = C.CustomerID
);

-- Question 3: ANY and ALL
-- 1. Find stores whose refunds are greater than ANY other store in their region
;WITH StoreRefunds AS
(
    SELECT
        ST.StoreID,
        ST.StoreName,
        ST.Region,
        COALESCE(SUM(F.RefundAmount), 0) AS TotalRefund
    FROM Stores ST
    LEFT JOIN Sales S
        ON ST.StoreID = S.StoreID
    LEFT JOIN Returns R
        ON S.SaleID = R.SaleID
    LEFT JOIN Refunds F
        ON R.ReturnID = F.ReturnID
    GROUP BY ST.StoreID, ST.StoreName, ST.Region
)
SELECT
    SR.StoreID,
    SR.StoreName,
    SR.Region,
    SR.TotalRefund
FROM StoreRefunds SR
WHERE SR.TotalRefund > ANY
(
    SELECT OtherStore.TotalRefund
    FROM StoreRefunds OtherStore
    WHERE OtherStore.Region = SR.Region
      AND OtherStore.StoreID <> SR.StoreID
);

-- 2. Find stores whose refunds are greater than ALL other stores in their region
;WITH StoreRefunds AS
(
    SELECT
        ST.StoreID,
        ST.StoreName,
        ST.Region,
        COALESCE(SUM(F.RefundAmount), 0) AS TotalRefund
    FROM Stores ST
    LEFT JOIN Sales S
        ON ST.StoreID = S.StoreID
    LEFT JOIN Returns R
        ON S.SaleID = R.SaleID
    LEFT JOIN Refunds F
        ON R.ReturnID = F.ReturnID
    GROUP BY ST.StoreID, ST.StoreName, ST.Region
)
SELECT
    SR.StoreID,
    SR.StoreName,
    SR.Region,
    SR.TotalRefund
FROM StoreRefunds SR
WHERE SR.TotalRefund > ALL
(
    SELECT OtherStore.TotalRefund
    FROM StoreRefunds OtherStore
    WHERE OtherStore.Region = SR.Region
      AND OtherStore.StoreID <> SR.StoreID
);

-- Question:4 Two nested subqueries with execution results
-- 1. Find products whose return rate is above the average product return rate
SELECT
    ProductRates.ProductName,
    ProductRates.ReturnRate
FROM
(
    SELECT
        P.ProductID,
        P.ProductName,
        CAST(
            COALESCE(SUM(RI.ReturnQuantity), 0) * 100.0
            / NULLIF(SUM(SI.Quantity), 0)
            AS DECIMAL(10,2)
        ) AS ReturnRate
    FROM Products P
    INNER JOIN SaleItems SI
        ON P.ProductID = SI.ProductID
    LEFT JOIN ReturnItems RI
        ON SI.SaleItemID = RI.SaleItemID
    GROUP BY P.ProductID, P.ProductName
) AS ProductRates
WHERE ProductRates.ReturnRate >
(
    SELECT AVG(InnerRates.ReturnRate)
    FROM
    (
        SELECT
            CAST(
                COALESCE(SUM(RI2.ReturnQuantity), 0) * 100.0
                / NULLIF(SUM(SI2.Quantity), 0)
                AS DECIMAL(10,2)
            ) AS ReturnRate
        FROM Products P2
        INNER JOIN SaleItems SI2
            ON P2.ProductID = SI2.ProductID
        LEFT JOIN ReturnItems RI2
            ON SI2.SaleItemID = RI2.SaleItemID
        GROUP BY P2.ProductID
    ) AS InnerRates
);

-- 2. Find stores whose refund value is above the average refund value of all stores
SELECT
    StoreTotals.StoreName,
    StoreTotals.TotalRefund
FROM
(
    SELECT
        ST.StoreID,
        ST.StoreName,
        COALESCE(SUM(F.RefundAmount), 0) AS TotalRefund
    FROM Stores ST
    LEFT JOIN Sales S
        ON ST.StoreID = S.StoreID
    LEFT JOIN Returns R
        ON S.SaleID = R.SaleID
    LEFT JOIN Refunds F
        ON R.ReturnID = F.ReturnID
    GROUP BY ST.StoreID, ST.StoreName
) AS StoreTotals
WHERE StoreTotals.TotalRefund >
(
    SELECT AVG(RefundTotals.TotalRefund)
    FROM
    (
        SELECT
            ST2.StoreID,
            COALESCE(SUM(F2.RefundAmount), 0) AS TotalRefund
        FROM Stores ST2
        LEFT JOIN Sales S2
            ON ST2.StoreID = S2.StoreID
        LEFT JOIN Returns R2
            ON S2.SaleID = R2.SaleID
        LEFT JOIN Refunds F2
            ON R2.ReturnID = F2.ReturnID
        GROUP BY ST2.StoreID
    ) AS RefundTotals
);

