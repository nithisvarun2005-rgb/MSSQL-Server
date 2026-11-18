-- Creating Database
CREATE DATABASE LogisticsDB;

USE LogisticsDB;

-- Creating Tables
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Phone VARCHAR(15)
);

CREATE TABLE Hubs
(
    HubID INT PRIMARY KEY,
    HubName VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

CREATE TABLE Carriers
(
    CarrierID INT PRIMARY KEY,
    CarrierName VARCHAR(100) NOT NULL
);

CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    SupervisorID INT NULL,

    FOREIGN KEY (SupervisorID)
    REFERENCES Employees(EmployeeID)
);

CREATE TABLE Shipments
(
    ShipmentID INT PRIMARY KEY,
    CustomerID INT,
    HubID INT,
    CarrierID INT,
    ShipDate DATE,
    ExpectedDeliveryDate DATE,
    ActualDeliveryDate DATE NULL,
    ShippingCost DECIMAL(10,2),

    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID),

    FOREIGN KEY (HubID)
    REFERENCES Hubs(HubID),

    FOREIGN KEY (CarrierID)
    REFERENCES Carriers(CarrierID)
);

CREATE TABLE Delivery_Events
(
    EventID INT PRIMARY KEY,
    ShipmentID INT,
    EventDate DATE,
    EventStatus VARCHAR(50),

    FOREIGN KEY (ShipmentID)
    REFERENCES Shipments(ShipmentID)
);

-- Inserting Values Into Tables
INSERT INTO Customers
VALUES
(1, 'Arun Kumar', 'Chennai', '9876543210'),
(2, 'Priya Sharma', 'Coimbatore', '9876543211'),
(3, 'Karthik Raj', 'Madurai', '9876543212'),
(4, 'Divya Sri', 'Chennai', '9876543213'),
(5, 'Rahul Kumar', 'Salem', '9876543214'),
(6, 'Sneha Devi', 'Trichy', '9876543215'),
(7, 'Vijay Anand', 'Erode', '9876543216'),
(8, 'Meena Rani', 'Tiruppur', '9876543217');

INSERT INTO Hubs
VALUES
(1, 'Chennai Central Hub', 'Chennai'),
(2, 'Coimbatore Hub', 'Coimbatore'),
(3, 'Madurai Hub', 'Madurai'),
(4, 'Salem Hub', 'Salem'),
(5, 'Trichy Hub', 'Trichy');

INSERT INTO Carriers
VALUES
(1, 'Fast Express'),
(2, 'Blue Dart'),
(3, 'Professional Couriers'),
(4, 'DTDC');

INSERT INTO Employees
VALUES
(1, 'Ramesh', NULL),
(2, 'Suresh', 1),
(3, 'Kumar', 1),
(4, 'Priya', 2),
(5, 'Divya', 2),
(6, 'Arun', 3);

INSERT INTO Shipments
VALUES
(101, 1, 1, 1, '2026-01-01', '2026-01-03', '2026-01-07', 500),
(102, 1, 2, 2, '2026-01-05', '2026-01-08', '2026-01-08', 300),
(103, 2, 1, 1, '2026-01-10', '2026-01-12', '2026-01-16', 700),
(104, 2, 3, 3, '2026-01-15', '2026-01-18', '2026-01-19', 450),
(105, 3, 2, 2, '2026-02-01', '2026-02-04', '2026-02-10', 900),
(106, 3, 1, 4, '2026-02-05', '2026-02-08', '2026-02-08', 250),
(107, 4, 3, 1, '2026-02-10', '2026-02-13', '2026-02-18', 600),
(108, 4, 2, 3, '2026-02-15', '2026-02-18', NULL, 350),
(109, 5, 1, 2, '2026-03-01', '2026-03-04', '2026-03-09', 800),
(110, 5, 3, 4, '2026-03-05', '2026-03-08', '2026-03-08', 400);

INSERT INTO Delivery_Events
VALUES
(1, 101, '2026-01-01', 'Shipment Created'),
(2, 101, '2026-01-03', 'In Transit'),
(3, 101, '2026-01-07', 'Delivered'),
(4, 102, '2026-01-05', 'Shipment Created'),
(5, 102, '2026-01-08', 'Delivered'),
(6, 103, '2026-01-10', 'Shipment Created'),
(7, 103, '2026-01-16', 'Delivered'),
(8, 104, '2026-01-15', 'Shipment Created'),
(9, 104, '2026-01-19', 'Delivered'),
(10, 105, '2026-02-01', 'Shipment Created');

-- Question 1.Solve ten business questions using INNER, LEFT, FULL and self joins

-- Join type: INNER JOIN
-- 1.Find shipments delayed by more than two days with carrier names.
SELECT
    S.ShipmentID,
    C.CarrierName,
    S.ExpectedDeliveryDate,
    S.ActualDeliveryDate,
    DATEDIFF(DAY, S.ExpectedDeliveryDate, S.ActualDeliveryDate) AS DelayDays
FROM Shipments S
INNER JOIN Carriers C
    ON S.CarrierID = C.CarrierID
WHERE DATEDIFF(DAY, S.ExpectedDeliveryDate, S.ActualDeliveryDate) > 2;

-- 2.Find hubs with no outbound shipments.
-- Join type: LEFT JOIN
SELECT
    H.HubID,
    H.HubName
FROM Hubs H
LEFT JOIN Shipments S
    ON H.HubID = S.HubID
WHERE S.ShipmentID IS NULL;

-- 3.Display employees along with their supervisors.
-- Join type: SELF JOIN
SELECT
    E.EmployeeID,
    E.EmployeeName,
    M.EmployeeName AS SupervisorName
FROM Employees E
LEFT JOIN Employees M
    ON E.SupervisorID = M.EmployeeID;

-- 4. Retrieve shipments with their corresponding customer details.
-- Join type: INNER JOIN
SELECT
    S.ShipmentID,
    C.CustomerID,
    C.CustomerName,
    S.ShipDate,
    S.ShippingCost
FROM Shipments S
INNER JOIN Customers C
    ON S.CustomerID = C.CustomerID;

-- 5. Display shipments with their delivery events.
-- Join type: LEFT JOIN
SELECT
    S.ShipmentID,
    S.ShipDate,
    D.EventID,
    D.EventDate,
    D.EventStatus
FROM Shipments S
LEFT JOIN Delivery_Events D
    ON S.ShipmentID = D.ShipmentID;

-- 6. Find customers who have not shipped any packages.
-- Join type: LEFT JOIN
SELECT
    C.CustomerID,
    C.CustomerName
FROM Customers C
LEFT JOIN Shipments S
    ON C.CustomerID = S.CustomerID
WHERE S.ShipmentID IS NULL;

-- 7. Display all hubs and their associated shipments, including unmatched records.
-- Join type: FULL OUTER JOIN
SELECT
    H.HubID,
    H.HubName,
    S.ShipmentID,
    S.ShipDate
FROM Hubs H
FULL OUTER JOIN Shipments S
    ON H.HubID = S.HubID;

-- 8. Compare shipments handled by different carriers.
-- Join type: INNER JOIN
SELECT
    S.ShipmentID,
    C.CarrierName,
    S.ShippingCost
FROM Shipments S
INNER JOIN Carriers C
    ON S.CarrierID = C.CarrierID
ORDER BY C.CarrierName, S.ShippingCost DESC;

-- 9. Find shipments with missing carrier information.
-- Join type: LEFT JOIN
SELECT
    S.ShipmentID,
    S.CarrierID,
    C.CarrierName
FROM Shipments S
LEFT JOIN Carriers C
    ON S.CarrierID = C.CarrierID
WHERE C.CarrierID IS NULL;

-- 10. Generate a combined shipment report with customer, hub, and carrier details.
-- Join type: Multiple INNER JOINs
SELECT
    S.ShipmentID,
    C.CustomerName,
    H.HubName,
    CR.CarrierName,
    S.ShipDate,
    S.ShippingCost
FROM Shipments S
INNER JOIN Customers C
    ON S.CustomerID = C.CustomerID
INNER JOIN Hubs H
    ON S.HubID = H.HubID
INNER JOIN Carriers CR
    ON S.CarrierID = CR.CarrierID;

--Question 2.Find customers who shipped to every hub using IN, EXISTS, ANY and ALL.
-- Using IN – Customers who shipped to a particular hub
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Shipments
    WHERE HubID = 1
);

-- Using EXISTS – Customers who have shipped to every hub
SELECT C.CustomerID, C.CustomerName
FROM Customers C
WHERE NOT EXISTS
(
    SELECT 1
    FROM Hubs H
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM Shipments S
        WHERE S.CustomerID = C.CustomerID
          AND S.HubID = H.HubID
    )
);

-- Using ANY – Carriers whose average delay exceeds at least one carrier's average delay
SELECT
    CarrierID,
    AVG(CAST(DATEDIFF(DAY, ExpectedDeliveryDate, ActualDeliveryDate) AS DECIMAL(10,2))) AS AverageDelay
FROM Shipments
WHERE ActualDeliveryDate IS NOT NULL
GROUP BY CarrierID
HAVING AVG(CAST(DATEDIFF(DAY, ExpectedDeliveryDate, ActualDeliveryDate) AS DECIMAL(10,2)))
>
ANY
(
    SELECT AVG(CAST(DATEDIFF(DAY, ExpectedDeliveryDate, ActualDeliveryDate) AS DECIMAL(10,2)))
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
    GROUP BY CarrierID
);

-- Using ALL – Carriers whose average delay exceeds every carrier's average delay
SELECT
    CarrierID,
    AVG(CAST(DATEDIFF(DAY, ExpectedDeliveryDate, ActualDeliveryDate) AS DECIMAL(10,2))) AS AverageDelay
FROM Shipments
WHERE ActualDeliveryDate IS NOT NULL
GROUP BY CarrierID
HAVING AVG(CAST(DATEDIFF(DAY, ExpectedDeliveryDate, ActualDeliveryDate) AS DECIMAL(10,2)))
>
ALL
(
    SELECT AVG(CAST(DATEDIFF(DAY, ExpectedDeliveryDate, ActualDeliveryDate) AS DECIMAL(10,2)))
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
    GROUP BY CarrierID
);

-- Find carriers whose average delay is above the overall average delay.
SELECT
    C.CarrierID,
    C.CarrierName,
    AVG(CAST(DATEDIFF(DAY, S.ExpectedDeliveryDate, S.ActualDeliveryDate) AS DECIMAL(10,2))) AS AverageDelay
FROM Carriers C
INNER JOIN Shipments S
    ON C.CarrierID = S.CarrierID
WHERE S.ActualDeliveryDate IS NOT NULL
GROUP BY C.CarrierID, C.CarrierName
HAVING AVG(CAST(DATEDIFF(DAY, S.ExpectedDeliveryDate, S.ActualDeliveryDate) AS DECIMAL(10,2)))
>
(
    SELECT AVG(CAST(DATEDIFF(DAY, ExpectedDeliveryDate, ActualDeliveryDate) AS DECIMAL(10,2)))
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
);

-- Question 3. Rewrite two subqueries as joins
-- Find customers who have shipments using a subquery.

-- Subquery approach:
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Shipments
);

-- JOIN approach:
SELECT DISTINCT
    C.CustomerID,
    C.CustomerName
FROM Customers C
INNER JOIN Shipments S
    ON C.CustomerID = S.CustomerID;

/*
Explanation:
Both approaches return customers who have shipments.
The JOIN approach makes the relationship between the tables explicit.
DISTINCT avoids duplicate customers when they have multiple shipments.
*/

-- Question.4 Nested subquery
-- Find the second-highest shipping cost per hub.
SELECT
    H.HubID,
    H.HubName,
    S.ShippingCost AS SecondHighestCost
FROM Hubs H
INNER JOIN Shipments S
    ON H.HubID = S.HubID
WHERE S.ShippingCost =
(
    SELECT MAX(S1.ShippingCost)
    FROM Shipments S1
    WHERE S1.HubID = H.HubID
      AND S1.ShippingCost <
      (
          SELECT MAX(S2.ShippingCost)
          FROM Shipments S2
          WHERE S2.HubID = H.HubID
      )
);
/*
Explanation:
1. The innermost query finds the highest shipping cost for each hub.
2. The middle query finds the maximum cost below that highest cost.
3. The outer query returns the shipment with that second-highest cost.
*/






