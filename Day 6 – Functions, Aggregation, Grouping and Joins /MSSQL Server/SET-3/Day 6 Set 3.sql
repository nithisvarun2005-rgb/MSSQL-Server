--Creating Database
CREATE DATABASE InsurancePolicyDB;

USE InsurancePolicyDB;

--Creating Tables
CREATE TABLE Customers (CustomerID INT PRIMARY KEY,CustomerName VARCHAR(100) NOT NULL,DateOfBirth DATE NOT NULL,City VARCHAR(60));

CREATE TABLE Products ( ProductID INT PRIMARY KEY, ProductName VARCHAR(80) NOT NULL);

CREATE TABLE Agents ( AgentID INT PRIMARY KEY, AgentName VARCHAR(100) NOT NULL);

CREATE TABLE Policies ( PolicyID INT PRIMARY KEY, PolicyNumber VARCHAR(30) NOT NULL UNIQUE, CustomerID INT NOT NULL, ProductID INT NOT NULL, AgentID INT NOT NULL, StartDate DATE NOT NULL, EndDate DATE NOT NULL,
PremiumAmount DECIMAL(12,2) NOT NULL CHECK (PremiumAmount >= 0), PremiumCollected DECIMAL(12,2) NOT NULL CHECK (PremiumCollected >= 0), PolicyStatus VARCHAR(20) NOT NULL, FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID), FOREIGN KEY (ProductID) REFERENCES Products(ProductID), FOREIGN KEY (AgentID) REFERENCES Agents(AgentID));

CREATE TABLE Claims ( ClaimID INT PRIMARY KEY, PolicyID INT NOT NULL, ClaimDate DATE NOT NULL, ClaimAmount DECIMAL(12,2) NOT NULL CHECK (ClaimAmount >= 0), ClaimStatus VARCHAR(20) NOT NULL,
SettlementDate DATE NULL, DamageCategory VARCHAR(60) NOT NULL, FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID));

--Inserting Values into Tables

INSERT INTO Customers VALUES
(1,'Arun Kumar','1988-04-12','Coimbatore'),
(2,'Meera Nair','1995-09-23','Chennai'),
(3,'Ravi Shah','1972-02-08','Bengaluru'),
(4,'Divya Menon','2001-06-17','Coimbatore'),
(5,'Karthik Rao','1960-11-30','Chennai'),
(6,'Sara Thomas','1982-01-05','Madurai');

INSERT INTO Products VALUES
(1,'Health Plus'),(2,'Motor Secure'),(3,'Home Protect'),(4,'Life Shield');

INSERT INTO Agents VALUES
(1,'Anita'),(2,'Bala'),(3,'Charan'),(4,'Deepa'),(5,'Eshan'),(6,'Farah');

INSERT INTO Policies VALUES
(101,'HLT-10001',1,1,1,'2025-12-01','2026-12-01',12000,12000,'Active'),
(102,'MTR-10002',1,2,2,'2026-03-01','2027-03-01',8000,8000,'Active'),
(103,'HOM-10003',2,3,1,'2026-01-15','2026-11-25',15000,15000,'Active'),
(104,'LIF-10004',3,4,3,'2024-06-01','2027-06-01',20000,20000,'Active'),
(105,'HLT-10005',4,1,4,'2026-02-01','2026-12-10',10000,10000,'Active'),
(106,'MTR-10006',5,2,2,'2025-11-01','2026-11-20',9000,9000,'Active'),
(107,'HOM-10007',6,3,5,'2026-04-01','2027-04-01',18000,18000,'Active'),
(108,'HLT-10008',2,1,6,'2025-05-01','2026-05-01',11000,11000,'Expired'),
(109,'LIF-10009',5,4,3,'2026-07-01','2027-07-01',25000,25000,'Active'),
(110,'MTR-10010',3,2,4,'2026-08-01','2027-08-01',7000,5000,'Active'),
(111,'HOM-10011',1,3,5,'2026-09-01','2027-09-01',14000,14000,'Active'),
(112,'HLT-10012',6,1,1,'2026-10-01','2027-10-01',13000,13000,'Active');

INSERT INTO Claims VALUES
(201,101,'2026-02-10',3000,'Settled','2026-02-20','Medical'),
(202,102,'2026-05-12',2500,'Settled','2026-05-22','Collision'),
(203,103,'2026-10-02',5000,'Approved',NULL,'Fire'),
(204,104,'2026-03-15',7000,'Settled','2026-04-04','Medical'),
(205,105,'2026-08-20',2000,'Rejected',NULL,'Medical'),
(206,106,'2026-11-05',3500,'Under Review',NULL,'Collision'),
(207,107,'2026-06-18',6000,'Settled','2026-07-03','Water Damage'),
(208,109,'2026-09-10',4000,'Approved',NULL,'Medical'),
(209,110,'2026-10-25',1500,'Settled','2026-11-04','Collision'),
(210,111,'2026-11-01',8000,'Under Review',NULL,'Fire');

--Declaring a Variable 
DECLARE @ReportDate DATE = '2026-11-17';

--Policies expiring in the next 30 days.
SELECT PolicyID, CONCAT(LEFT(PolicyNumber,3),'-*****-',RIGHT(PolicyNumber,4)) AS MaskedPolicyNumber, EndDate, DATEDIFF(DAY,@ReportDate,EndDate) AS DaysToExpiry
FROM Policies WHERE EndDate >= @ReportDate AND EndDate < DATEADD(DAY,31,@ReportDate)
ORDER BY EndDate;

-- Premium collected per product.
SELECT pr.ProductName, SUM(po.PremiumCollected) AS TotalPremiumCollected FROM Policies po JOIN Products pr ON po.ProductID = pr.ProductID
GROUP BY pr.ProductName
ORDER BY TotalPremiumCollected DESC;

--Customers with more than one active policy.
SELECT c.CustomerID, UPPER(c.CustomerName) AS CustomerName, COUNT(*) AS ActivePolicyCount FROM Customers c JOIN Policies p ON c.CustomerID = p.CustomerID
WHERE p.PolicyStatus = 'Active'
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(*) > 1
ORDER BY ActivePolicyCount DESC;

-- Claim ratio per product: total claim amount divided by premium collected.
WITH PremiumTotals AS ( SELECT ProductID, SUM(PremiumCollected) AS PremiumCollected FROM Policies GROUP BY ProductID),
ClaimTotals AS ( SELECT p.ProductID, SUM(cl.ClaimAmount) AS TotalClaimAmount FROM Policies p JOIN Claims cl ON p.PolicyID = cl.PolicyID GROUP BY p.ProductID)
SELECT pr.ProductName, ISNULL(ct.TotalClaimAmount,0) AS TotalClaimAmount, pt.PremiumCollected, CAST(100.0 * ISNULL(ct.TotalClaimAmount,0) / NULLIF(pt.PremiumCollected,0) AS DECIMAL(8,2)) AS ClaimRatioPercent
FROM Products pr
JOIN PremiumTotals pt ON pr.ProductID = pt.ProductID
LEFT JOIN ClaimTotals ct ON pr.ProductID = ct.ProductID
ORDER BY ClaimRatioPercent DESC;

--Policies without claims.
SELECT p.PolicyID, CONCAT(LEFT(p.PolicyNumber,3),'-*****-',RIGHT(p.PolicyNumber,4)) AS MaskedPolicyNumber, c.CustomerName, pr.ProductName FROM Policies p
JOIN Customers c ON p.CustomerID = c.CustomerID
JOIN Products pr ON p.ProductID = pr.ProductID
LEFT JOIN Claims cl ON p.PolicyID = cl.PolicyID
WHERE cl.ClaimID IS NULL
ORDER BY p.PolicyID;

--Average premium by customer age band.
SELECT CASE
WHEN DATEDIFF(YEAR,c.DateOfBirth,@ReportDate) - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,c.DateOfBirth,@ReportDate),c.DateOfBirth) > @ReportDate THEN 1 ELSE 0 END < 30 THEN 'Under 30'
WHEN DATEDIFF(YEAR,c.DateOfBirth,@ReportDate) - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,c.DateOfBirth,@ReportDate),c.DateOfBirth) > @ReportDate THEN 1 ELSE 0 END < 45 THEN '30-44'
WHEN DATEDIFF(YEAR,c.DateOfBirth,@ReportDate) - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,c.DateOfBirth,@ReportDate),c.DateOfBirth) > @ReportDate THEN 1 ELSE 0 END < 60 THEN '45-59'
ELSE '60+' END AS AgeBand,
CAST(AVG(p.PremiumAmount) AS DECIMAL(10,2)) AS AveragePremium
FROM Policies p JOIN Customers c ON p.CustomerID = c.CustomerID
GROUP BY CASE
WHEN DATEDIFF(YEAR,c.DateOfBirth,@ReportDate) - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,c.DateOfBirth,@ReportDate),c.DateOfBirth) > @ReportDate THEN 1 ELSE 0 END < 30 THEN 'Under 30'
WHEN DATEDIFF(YEAR,c.DateOfBirth,@ReportDate) - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,c.DateOfBirth,@ReportDate),c.DateOfBirth) > @ReportDate THEN 1 ELSE 0 END < 45 THEN '30-44'
WHEN DATEDIFF(YEAR,c.DateOfBirth,@ReportDate) - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,c.DateOfBirth,@ReportDate),c.DateOfBirth) > @ReportDate THEN 1 ELSE 0 END < 60 THEN '45-59'
ELSE '60+' END
ORDER BY AgeBand;

--Monthly new policies.
SELECT FORMAT(StartDate,'yyyy-MM') AS PolicyMonth, COUNT(*) AS NewPolicyCount FROM Policies
GROUP BY FORMAT(StartDate,'yyyy-MM') ORDER BY PolicyMonth;

--Top five agents by premium collected.
SELECT TOP 5 a.AgentName, SUM(p.PremiumCollected) AS TotalPremiumCollected
FROM Agents a JOIN Policies p ON a.AgentID = p.AgentID
GROUP BY a.AgentID, a.AgentName
ORDER BY TotalPremiumCollected DESC, a.AgentName;

--Policy
SELECT PolicyID,
CONCAT(LEFT(PolicyNumber,3),'-*****-',RIGHT(PolicyNumber,4)) AS MaskedPolicyNumber,
DATEDIFF(DAY,StartDate,@ReportDate) AS PolicyAgeDays,
CASE
WHEN DATEDIFF(DAY,StartDate,@ReportDate) < 365 THEN 'Less than 1 year'
WHEN DATEDIFF(DAY,StartDate,@ReportDate) < 1095 THEN '1-2 years'
ELSE '3+ years'
END AS PolicyAgeBand
FROM Policies ORDER BY PolicyID;
