--Question 1: Normalise the spreadsheet to 3NF, identify anomalies and draw the ER diagram

--1. Normalisation to 3NF
--The original spreadsheet combines product, supplier, warehouse and stock information in one table.

--We can decompose it into the following relational tables:
--Table	Important columns
--Category	CategoryID (PK), CategoryName
--Supplier	SupplierID (PK), SupplierName, SupplierPhone
--Warehouse	WarehouseID (PK), WarehouseName
--Product	SKU (PK), ProductName, CategoryID (FK), SupplierID (FK), ReorderLevel
--Inventory	SKU (PK, FK), WarehouseID (PK, FK), Quantity

--Why this is 3NF:
--- 1NF: Each column contains atomic values; no repeating groups.
--- 2NF: Every non-key attribute depends on the entire primary key. Inventory uses a composite key.
--- 3NF: Supplier, category and warehouse details are separated, eliminating transitive dependencies.
--Anomalies in the original spreadsheet
--1. Insertion anomaly: Cannot store a new supplier unless a product associated with that supplier is added.
--2. Update anomaly: Changing a supplier's phone number requires updating multiple product rows.
--3. Deletion anomaly: Deleting the last product supplied by a supplier may accidentally remove the supplier's information.



--Question 2: Write SQL Server scripts to create the database and tables

--Creating Database
CREATE DATABASE RetailDB;

USE RetailDB;

--Creating Tables

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE Supplier (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(120) NOT NULL UNIQUE,
    SupplierPhone VARCHAR(20) NOT NULL
);

CREATE TABLE Warehouse (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Product (
    SKU VARCHAR(20) PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL UNIQUE,

    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,

    ReorderLevel INT NOT NULL DEFAULT 5,

    CHECK (ReorderLevel >= 0),

    FOREIGN KEY (CategoryID)
    REFERENCES Category(CategoryID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,

    FOREIGN KEY (SupplierID)
    REFERENCES Supplier(SupplierID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

CREATE TABLE Inventory (
    SKU VARCHAR(20),
    WarehouseID INT,

    Quantity INT NOT NULL DEFAULT 0,

    PRIMARY KEY (SKU, WarehouseID),

    CHECK (Quantity >= 0),

    FOREIGN KEY (SKU)
    REFERENCES Product(SKU)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    FOREIGN KEY (WarehouseID)
    REFERENCES Warehouse(WarehouseID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

--Question 3: Insert at least 10 rows per table and demonstrate four failing inserts

INSERT INTO Category (CategoryName)
VALUES
('Electronics'),
('Furniture'),
('Stationery'),
('Sports'),
('Kitchenware'),
('Toys'),
('Personal Care'),
('Clothing'),
('Automotive'),
('Home Appliances');

INSERT INTO Supplier
(SupplierName, SupplierPhone)
VALUES
('ABC Suppliers', '9876501001'),
('XYZ Traders', '9876501002'),
('Bright Tech', '9876501003'),
('Home Products', '9876501004'),
('Paper World', '9876501005'),
('Sports Hub', '9876501006'),
('Kitchen Craft', '9876501007'),
('Play World', '9876501008'),
('Style Street', '9876501009'),
('Auto Parts', '9876501010');

INSERT INTO Warehouse (WarehouseName)
VALUES
('Chennai'),
('Coimbatore'),
('Bangalore'),
('Hyderabad'),
('Mumbai'),
('Delhi'),
('Kochi'),
('Pune'),
('Kolkata'),
('Jaipur');

INSERT INTO Product
(SKU, ProductName, CategoryID, SupplierID, ReorderLevel)
VALUES
('S101', 'Mouse', 1, 1, 10),
('S102', 'Keyboard', 1, 2, 5),
('S103', 'Chair', 2, 3, 5),
('S104', 'Notebook', 3, 4, 20),
('S105', 'Football', 4, 5, 6),
('S106', 'Cooking Pan', 5, 6, 7),
('S107', 'Toy Car', 6, 7, 5),
('S108', 'Face Wash', 7, 8, 12),
('S109', 'T Shirt', 8, 9, 10),
('S110', 'Car Holder', 9, 10, 5);

INSERT INTO Inventory
(SKU, WarehouseID, Quantity)
VALUES
('S101', 1, 100),
('S102', 1, 50),
('S103', 2, 25),
('S104', 2, 200),
('S105', 3, 45),
('S106', 4, 70),
('S107', 5, 35),
('S108', 6, 90),
('S109', 7, 110),
('S110', 8, 40);

--Demonstrate four deliberately failing inserts
--Duplicate Primary Key
INSERT INTO Product
(SKU, ProductName, CategoryID, SupplierID)
VALUES
('S101', 'Wireless Mouse', 1, 1);

--Missing Parent Record
INSERT INTO Product
(SKU, ProductName, CategoryID, SupplierID)
VALUES
('S111', 'Monitor', 999, 1);

--Negative Quantity
INSERT INTO Inventory
(SKU, WarehouseID, Quantity)
VALUES
('S101', 2, -10);

--NULL in mandatory column
INSERT INTO Product
(SKU, ProductName, CategoryID, SupplierID)
VALUES
('S112', NULL, 1, 1);


--Question 4: UPDATE and DELETE with WHERE

--A. Correct a supplier phone number
--Before
SELECT *FROM Supplier
WHERE SupplierID = 1;

UPDATE Supplier
SET SupplierPhone = '9000012345'
WHERE SupplierID = 1;

--After
SELECT *FROM Supplier
WHERE SupplierID = 1;

--B. Remove discontinued SKUs
--Before
SELECT *FROM Product
WHERE SKU = 'S110';

DELETE FROM Product
WHERE SKU = 'S110';

--After
SELECT *FROM Product
WHERE SKU = 'S110';





