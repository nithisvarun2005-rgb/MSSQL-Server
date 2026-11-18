--Creating Database
CREATE DATABASE BankingLoanDB;

USE BankingLoanDB;

--Creating Tables
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Phone VARCHAR(15)
);

CREATE TABLE Branches
(
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);

CREATE TABLE Loans
(
    LoanID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    LoanAmount DECIMAL(12,2) NOT NULL,
    TotalInstalments INT NOT NULL,
    PaidInstalments INT NOT NULL,
    LoanDate DATE NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    FOREIGN KEY (BranchID)
        REFERENCES Branches(BranchID),

    CHECK (LoanAmount > 0),
    CHECK (TotalInstalments > 0),
    CHECK (PaidInstalments >= 0 AND PaidInstalments <= TotalInstalments)
);

CREATE TABLE Repayments
(
    RepaymentID INT PRIMARY KEY,
    LoanID INT NOT NULL,
    RepaymentDate DATE NOT NULL,
    AmountPaid DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (LoanID)
        REFERENCES Loans(LoanID),

    CHECK (AmountPaid > 0)
);

CREATE TABLE Guarantors
(
    GuarantorID INT PRIMARY KEY,
    LoanID INT NOT NULL,
    GuarantorCustomerID INT NOT NULL,

    FOREIGN KEY (LoanID)
        REFERENCES Loans(LoanID),

    FOREIGN KEY (GuarantorCustomerID)
        REFERENCES Customers(CustomerID)
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

INSERT INTO Branches
VALUES
(1, 'Chennai Main Branch', 'Chennai'),
(2, 'Coimbatore Branch', 'Coimbatore'),
(3, 'Madurai Branch', 'Madurai'),
(4, 'Salem Branch', 'Salem'),
(5, 'Trichy Branch', 'Trichy'),
(6, 'Erode Branch', 'Erode');

INSERT INTO Loans
VALUES
(101, 1, 1, 500000, 24, 18, '2025-01-10'),
(102, 1, 2, 300000, 24, 20, '2025-03-15'),
(103, 2, 1, 800000, 36, 20, '2025-02-01'),
(104, 2, 3, 400000, 24, 15, '2025-04-10'),
(105, 3, 2, 600000, 36, 10, '2025-05-12'),
(106, 3, 1, 200000, 24, 22, '2025-06-20'),
(107, 4, 3, 900000, 36, 18, '2025-07-05'),
(108, 4, 1, 350000, 24, 12, '2025-08-15'),
(109, 5, 2, 700000, 36, 25, '2025-09-10'),
(110, 5, 3, 250000, 24, 10, '2025-10-01'),
(111, 6, 1, 1000000, 48, 20, '2025-11-11'),
(112, 6, 2, 450000, 24, 16, '2025-12-01'),
(113, 7, 3, 550000, 36, 12, '2026-01-05'),
(114, 7, 1, 650000, 36, 30, '2026-02-10'),
(115, 9, 2, 750000, 36, 15, '2026-03-01');

INSERT INTO Repayments
VALUES
(1, 101, '2026-09-10', 20000),
(2, 101, '2026-10-15', 20000),
(3, 102, '2026-08-10', 15000),
(4, 103, '2026-11-05', 25000),
(5, 103, '2026-07-15', 25000),
(6, 104, '2026-06-10', 18000),
(7, 105, '2026-11-12', 20000),
(8, 106, '2026-08-20', 12000),
(9, 107, '2026-09-01', 30000),
(10, 108, '2026-10-20', 15000),
(11, 109, '2026-05-15', 22000),
(12, 110, '2026-11-10', 10000),
(13, 111, '2026-07-20', 35000),
(14, 112, '2026-10-25', 18000),
(15, 113, '2026-06-15', 16000),
(16, 114, '2026-11-01', 25000),
(17, 115, '2026-08-05', 20000);

INSERT INTO Guarantors
VALUES
(1, 101, 2),
(2, 102, 3),
(3, 103, 4),
(4, 104, 5),
(5, 105, 6),
(6, 106, 7),
(7, 107, 1),
(8, 108, 8),
(9, 109, 9),
(10, 110, 10);

-- Question 1: Ten SQL business questions
-- 1. Find loans overdue by more than three instalments.
SELECT
    L.LoanID,
    C.CustomerName,
    L.LoanAmount,
    L.TotalInstalments,
    L.PaidInstalments,
    (L.TotalInstalments - L.PaidInstalments) AS OverdueInstalments
FROM Loans L
INNER JOIN Customers C
    ON L.CustomerID = C.CustomerID
WHERE (L.TotalInstalments - L.PaidInstalments) > 3;

-- 2. Find customers who have loans in more than one branch.
SELECT
    C.CustomerID,
    C.CustomerName,
    COUNT(DISTINCT L.BranchID) AS NumberOfBranches
FROM Customers C
INNER JOIN Loans L
    ON C.CustomerID = L.CustomerID
GROUP BY
    C.CustomerID,
    C.CustomerName
HAVING COUNT(DISTINCT L.BranchID) > 1;

-- 3. Find guarantors who are also borrowers using SELF JOIN.
SELECT DISTINCT
    G.GuarantorCustomerID,
    C.CustomerName AS GuarantorName
FROM Guarantors G
INNER JOIN Loans L
    ON G.GuarantorCustomerID = L.CustomerID
INNER JOIN Customers C
    ON G.GuarantorCustomerID = C.CustomerID;

-- 4. Find branches with no loans.
SELECT
    B.BranchID,
    B.BranchName
FROM Branches B
LEFT JOIN Loans L
    ON B.BranchID = L.BranchID
WHERE L.LoanID IS NULL;

-- 5. Display loan details with customer and branch information.
SELECT
    L.LoanID,
    C.CustomerName,
    B.BranchName,
    L.LoanAmount,
    L.LoanDate
FROM Loans L
INNER JOIN Customers C
    ON L.CustomerID = C.CustomerID
INNER JOIN Branches B
    ON L.BranchID = B.BranchID;

-- 6. Display all loans with their repayment details
SELECT
    L.LoanID,
    C.CustomerName,
    R.RepaymentID,
    R.RepaymentDate,
    R.AmountPaid
FROM Loans L
INNER JOIN Customers C
    ON L.CustomerID = C.CustomerID
LEFT JOIN Repayments R
    ON L.LoanID = R.LoanID;

-- 7. Find customers who have more than one loan.
SELECT
    C.CustomerID,
    C.CustomerName,
    COUNT(L.LoanID) AS TotalLoans
FROM Customers C
INNER JOIN Loans L
    ON C.CustomerID = L.CustomerID
GROUP BY
    C.CustomerID,
    C.CustomerName
HAVING COUNT(L.LoanID) > 1;

-- 8. Find loans with outstanding balances.
SELECT
    L.LoanID,
    C.CustomerName,
    L.LoanAmount,
    COALESCE(SUM(R.AmountPaid), 0) AS TotalRepaid,
    L.LoanAmount - COALESCE(SUM(R.AmountPaid), 0) AS OutstandingBalance
FROM Loans L
INNER JOIN Customers C
    ON L.CustomerID = C.CustomerID
LEFT JOIN Repayments R
    ON L.LoanID = R.LoanID
GROUP BY
    L.LoanID,
    C.CustomerName,
    L.LoanAmount
HAVING L.LoanAmount - COALESCE(SUM(R.AmountPaid), 0) > 0;

-- 9. Find customers whose total loan exposure exceeds their branch average.
SELECT
    C.CustomerID,
    C.CustomerName,
    L.BranchID,
    SUM(L.LoanAmount) AS TotalLoanExposure
FROM Customers C
INNER JOIN Loans L
    ON C.CustomerID = L.CustomerID
GROUP BY
    C.CustomerID,
    C.CustomerName,
    L.BranchID
HAVING SUM(L.LoanAmount) >
(
    SELECT AVG(CustomerLoanTotal)
    FROM
    (
        SELECT
            SUM(L2.LoanAmount) AS CustomerLoanTotal
        FROM Loans L2
        WHERE L2.BranchID = L.BranchID
        GROUP BY L2.CustomerID
    ) AS BranchCustomerTotals
);

-- 10. Display complete loan information with customer, branch, guarantor, and repayment details.
SELECT
    L.LoanID,
    C.CustomerName,
    B.BranchName,
    G.GuarantorCustomerID,
    R.RepaymentDate,
    R.AmountPaid,
    L.LoanAmount
FROM Loans L
INNER JOIN Customers C
    ON L.CustomerID = C.CustomerID
INNER JOIN Branches B
    ON L.BranchID = B.BranchID
LEFT JOIN Guarantors G
    ON L.LoanID = G.LoanID
LEFT JOIN Repayments R
    ON L.LoanID = R.LoanID;

-- Question 2 – Correlated and uncorrelated subqueries
-- Find customers whose total loan exposure exceeds the branch average.
-- A customer's loan exposure is the sum of all their loan amounts in a branch.

-- A. Using a correlated subquery
SELECT
    C.CustomerID,
    C.CustomerName,
    L.BranchID,
    SUM(L.LoanAmount) AS TotalLoanExposure
FROM Customers C
INNER JOIN Loans L
    ON C.CustomerID = L.CustomerID
GROUP BY
    C.CustomerID,
    C.CustomerName,
    L.BranchID
HAVING SUM(L.LoanAmount) >
(
    SELECT AVG(CustomerTotal)
    FROM
    (
        SELECT
            L2.CustomerID,
            SUM(L2.LoanAmount) AS CustomerTotal
        FROM Loans L2
        WHERE L2.BranchID = L.BranchID
        GROUP BY L2.CustomerID
    ) AS BranchAverage
);

-- B.Using an uncorrelated derived subquery
SELECT
    C.CustomerID,
    C.CustomerName,
    L.BranchID,
    SUM(L.LoanAmount) AS TotalLoanExposure
FROM Customers C
INNER JOIN Loans L
    ON C.CustomerID = L.CustomerID
INNER JOIN
(
    SELECT
        BranchID,
        AVG(CustomerTotal) AS BranchAverage
    FROM
    (
        SELECT
            BranchID,
            CustomerID,
            SUM(LoanAmount) AS CustomerTotal
        FROM Loans
        GROUP BY BranchID, CustomerID
    ) AS CustomerTotals
    GROUP BY BranchID
) AS BA
    ON L.BranchID = BA.BranchID
GROUP BY
    C.CustomerID,
    C.CustomerName,
    L.BranchID,
    BA.BranchAverage
HAVING SUM(L.LoanAmount) > BA.BranchAverage;

-- Question 3: EXISTS and NOT EXISTS
-- Find customers who have a loan but no repayment in the last 60 days.
SELECT
    C.CustomerID,
    C.CustomerName
FROM Customers C
WHERE EXISTS
(
    SELECT 1
    FROM Loans L
    WHERE L.CustomerID = C.CustomerID
)
AND NOT EXISTS
(
    SELECT 1
    FROM Loans L
    INNER JOIN Repayments R
        ON L.LoanID = R.LoanID
    WHERE L.CustomerID = C.CustomerID
      AND R.RepaymentDate >= DATEADD(DAY, -60, GETDATE())
      AND R.RepaymentDate <= GETDATE()
);

-- Question 4: Nested subquery
-- Find branches whose highest loan amount is greater than the bank-wide average of branch maximums.
SELECT
    B.BranchID,
    B.BranchName,
    MAX(L.LoanAmount) AS HighestLoanAmount
FROM Branches B
INNER JOIN Loans L
    ON B.BranchID = L.BranchID
GROUP BY
    B.BranchID,
    B.BranchName
HAVING MAX(L.LoanAmount) >
(
    SELECT AVG(BranchMaximum)
    FROM
    (
        SELECT
            BranchID,
            MAX(LoanAmount) AS BranchMaximum
        FROM Loans
        GROUP BY BranchID
    ) AS BranchMaxima
);
