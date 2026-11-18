CREATE DATABASE RetailDalesDB;

USE RetailSalesDB;

--create tables
CREATE TABLE Customers (CustomerID INT IDENTITY(1,1) PRIMARY KEY, CustomerName VARCHAR(100) NOT NULL, City VARCHAR(50) NOT NULL, Email VARCHAR(100) NOT NULL UNIQUE);

CREATE TABLE  Products (ProductID INT IDENTITY(1,1) PRIMARY KEY, ProductName VARCHAR(100) NOT NULL, Category VARCHAR(50) NOT NULL, UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0));

CREATE TABLE Orders (OrderID INT IDENTITY(1,1) PRIMARY KEY, CustomerID INT NOT NULL, OrderDate DATE NOT NULL, CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));

CREATE TABLE Order_Items (OrderItemID INT IDENTITY(1,1) PRIMARY KEY, OrderID INT NOT NULL, ProductID INT NOT NULL, Quantity INT NOT NULL CHECK (Quantity > 0), UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0), CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE, CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID));

CREATE TABLE Payments (PaymentID INT IDENTITY(1,1) PRIMARY KEY, OrderID INT NOT NULL UNIQUE, PaymentDate DATE NULL, Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0), PaymentMethod VARCHAR(30) NOT NULL, CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE);

--Inserting Values into Tables
INSERT INTO Customers (CustomerName, City, Email) VALUES ('Arun Kumar','Coimbatore','arun@example.com'),('Priya Sharma','Chennai','priya@example.com'),('Rahul Verma','Bengaluru','rahul@example.com'),('Sneha Reddy','Coimbatore','sneha@example.com'),('Karthik Raj','Chennai','karthik@example.com'),('Meera Iyer','Madurai','meera@example.com');

INSERT INTO Products (ProductName, Category, UnitPrice) VALUES ('Wireless Mouse','Electronics',800),('Mechanical Keyboard','Electronics',2500),('Cotton T-Shirt','Clothing',600),('Water Bottle','Accessories',350),('Laptop Stand','Accessories',1200);

INSERT INTO Orders (CustomerID, OrderDate) VALUES (1,'2026-01-05'),(1,'2026-01-18'),(1,'2026-02-10'),(1,'2026-02-22'),(2,'2026-01-12'),(2,'2026-02-14'),(3,'2026-02-05'),(4,'2026-03-02'),(5,'2026-03-10'),(5,'2026-03-15');

INSERT INTO Order_Items (OrderID, ProductID, Quantity, UnitPrice) VALUES (1,1,2,800),(1,4,1,350),(2,2,1,2500),(3,1,1,800),(3,5,1,1200),(4,3,2,600),(5,2,1,2500),(5,4,2,350),(6,3,3,600),(7,5,2,1200),(8,1,1,800),(8,3,1,600),(9,4,3,350),(10,2,1,2500),(10,5,1,1200);

INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod) VALUES (1,'VALUES-01-05',1950,'UPI'),(2,'2026-01-18',2500,'Card'),(4,'2026-02-22',1200,'UPI'),(5,'2026-01-12',3200,'Card'),(6,'2026-02-14',1800,'UPI'),(7,'2026-02-05',2400,'Net Banking'),(9,'2026-03-10',1050,'UPI'),(10,'2026-03-15',3700,'Card');

SELECT 'Customers' as TableName, COUNT(*) as TotalRows FROM Customers UNION all SELECT 'Products',COUNT(*) from Products UNION all SELECT 'Orders',COUNT(*) from Orders UNION all SELECT 'Order_Items',COUNT(*) from Order_Items union all select 'Payments',COUNT(*) from Payments;

--Top five products by revenue.
SELECT TOP 5 p.ProductID, p.ProductName, SUM(oi.Quantity * oi.UnitPrice) AS Revenue from Products p join Order_Items oi on p.ProductID = oi.ProductID 
GROUP BY p.ProductID, p.ProductName 
ORDER BY Revenue desc;

--Month-wise sales
SELECT
    FORMAT(o.OrderDate, 'yyyy-MM') AS SalesMonth,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
FROM Orders o
JOIN Order_Items oi
    ON o.OrderID = oi.OrderID
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY SalesMonth;

--Customers with more than three orders 
SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 3;

--Average basket value per city
SELECT
    c.City,
    ROUND(AVG(OrderTotal), 2) AS AverageBasketValue
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS OrderTotal
    FROM Order_Items
    GROUP BY OrderID
) x
    ON o.OrderID = x.OrderID
GROUP BY c.City;

--Orders without payment
SELECT
    o.OrderID,
    o.CustomerID,
    o.OrderDate
FROM Orders o
LEFT JOIN Payments p
    ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL;

--Customers with no orders
SELECT
    c.CustomerID,
    c.CustomerName,
    c.City
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

--Product-category revenue share
SELECT
    p.Category,
    SUM(oi.Quantity * oi.UnitPrice) AS CategoryRevenue,
    ROUND(
        SUM(oi.Quantity * oi.UnitPrice) * 100.0 /
        SUM(SUM(oi.Quantity * oi.UnitPrice)) OVER(),
        2
    ) AS RevenuePercentage
FROM Products p
JOIN Order_Items oi
    ON p.ProductID = oi.ProductID
GROUP BY p.Category;

--Day with the highest sales
SELECT TOP 1
    o.OrderDate,
    SUM(oi.Quantity * oi.UnitPrice) AS DailySales
FROM Orders o
JOIN Order_Items oi
    ON o.OrderID = oi.OrderID
GROUP BY o.OrderDate
ORDER BY DailySales DESC;

--Customer-friendly output 
SELECT c.CustomerID, UPPER(c.CustomerName) AS CustomerNameUpper, CONCAT(c.CustomerName,' - ',c.City) AS CustomerLabel, FORMAT(o.OrderDate,'dd MMM yyyy') AS FormattedOrderDate, DATEDIFF(DAY,o.OrderDate,CAST(GETDATE() as date)) AS DaysSinceOrder, ROUND(SUM(oi.Quantity * oi.UnitPrice),2) AS OrderTotal 
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN Order_Items oi ON o.OrderID = oi.OrderID 
GROUP BY c.CustomerID,c.CustomerName,c.City,o.OrderDate,o.OrderID 
ORDER BY o.OrderDate;

--NULL behaviour
SELECT COUNT(*) AS TotalRows, COUNT(PaymentDate) AS NonNullPaymentDates, AVG(CAST(Amount as decimal(10,2))) AS AveragePaymentAmount 
FROM Payments;

--Ignores the NULL amount
SELECT COUNT(*) AS TotalRows, COUNT(PaymentDate) AS NonNullDates, AVG(Amount) AS AverageNonNullAmount
FROM (VALUES (CAST('2026-01-01' as date),CAST(100.00 as decimal(10,2))),(CAST(NULL as date),CAST(200.00 as decimal(10,2))),(CAST('2026-01-03' as date),CAST(NULL as decimal(10,2)))) AS SampleData(PaymentDate,Amount);
