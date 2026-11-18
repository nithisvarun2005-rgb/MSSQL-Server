CREATE DATABASE HospitalDB;
USE HospitalDB;

/*1. Unnormalised table (UNF)
Assume the hospital initially stores all information in one table:

Hospital_Record
PatientID	PatientName	DoctorID	DoctorName	DepartmentID	DepartmentName	VisitID	VisitDate	BillID	Amount
P101	Arun	D01	Kumar	DP01	Cardiology	V001	10-Nov-2026	B001	1500
P101	Arun	D01	Kumar	DP01	Cardiology	V002	12-Nov-2026	B002	2000
P102	Priya	D02	Priya	DP02	Neurology	V003	13-Nov-2026	B003	2500

3. First Normal Form (1NF)
Rules:
- Every column must contain atomic values.
- No multiple values in one cell.
- Each record must be uniquely identifiable.
Suppose the original table stores multiple visits in a single cell:
PatientID	PatientName	VisitDetails
P101	Arun	V001, 10-Nov; V002, 12-Nov

This violates 1NF because VisitDetails contains multiple values.

Decomposition into 1NF:

Each visit is stored in a separate row.
PatientID	PatientName	VisitID	VisitDate
P101	Arun	V001	10-Nov-2026
P101	Arun	V002	12-Nov-2026

1NF achieved
Every cell now contains a single value.
4. Second Normal Form (2NF)
Rules:
- Must satisfy 1NF.
- No partial dependency on a composite candidate key.
Consider the visit-level data with the composite key:

(PatientID, VisitID)

Some attributes depend only on PatientID:
PatientID → PatientName


But PatientName depends only on part of the composite key, not the complete key.

This is called a partial dependency.

Solution: Separate Patient and Visit.

Patient table:
PatientID (PK)	PatientName
P101	Arun
P102	Priya

Visit table:
VisitID (PK)	PatientID (FK)	VisitDate
V001	P101	10-Nov-2026
V002	P101	12-Nov-2026
V003	P102	13-Nov-2026

2NF achieved
Patient details are now stored only once.
5. Third Normal Form (3NF)
Rules:
- Must satisfy 2NF.
- No transitive dependency.
A transitive dependency occurs when a non-key attribute depends on another non-key attribute instead of directly depending on the primary key.

For example:
DoctorID → DepartmentID
DepartmentID → DepartmentName


Therefore:
DoctorID → DepartmentName


This is a transitive dependency.

Solution: Separate Doctor and Department.
A. Doctor table
DoctorID (PK)	DoctorName	DepartmentID (FK)
D01	Kumar	DP01
D02	Priya	DP02

B. Department table
DepartmentID (PK)	DepartmentName
DP01	Cardiology
DP02	Neurology

Now DepartmentName is stored only in Department.
C. Visit table
We also add DoctorID to Visit because each visit is associated with a doctor.
VisitID (PK)	PatientID (FK)	DoctorID (FK)	VisitDate
V001	P101	D01	10-Nov-2026
V002	P101	D01	12-Nov-2026
V003	P102	D02	13-Nov-2026

D. Billing table
Billing information is separated from Visit.
BillID (PK)	VisitID (FK)	Amount
B001	V001	1500
B002	V002	2000
B003	V003	2500

3NF achieved
6. Final normalised database – Five tables

Final 3NF structure
1. PATIENT

PK – PatientID

PatientName

2. DEPARTMENT

PK – DepartmentID

DepartmentName

3. DOCTOR

PK – DoctorID

FK – DepartmentID

DoctorName

4. VISIT

PK – VisitID

FK – PatientID

FK – DoctorID

VisitDate

5. BILLING

PK – BillID

FK – VisitID

Amount

PK = Primary Key · FK = Foreign Key*/

--2.Creating Tables 
CREATE TABLE Patient (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Phone VARCHAR(15),

    CHECK (Age >= 0),
    CHECK (Gender IN ('Male', 'Female', 'Other'))
);

CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Doctor (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    Specialization VARCHAR(100),

    FOREIGN KEY (DepartmentID)
    REFERENCES Department(DepartmentID)
);

CREATE TABLE Visit (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR(200),

    FOREIGN KEY (PatientID)
    REFERENCES Patient(PatientID),

    FOREIGN KEY (DoctorID)
    REFERENCES Doctor(DoctorID),

    CONSTRAINT CK_Visit_Date
    CHECK (VisitDate <= CAST(GETDATE() AS DATE))
);

CREATE TABLE Billing (
    BillID INT IDENTITY(1,1) PRIMARY KEY,
    VisitID INT NOT NULL UNIQUE,
    BillAmount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) NOT NULL
        DEFAULT 'Open',

    FOREIGN KEY (VisitID)
    REFERENCES Visit(VisitID),

    CONSTRAINT CK_Bill_Amount
    CHECK (BillAmount >= 0),

    CONSTRAINT CK_Bill_Status
    CHECK (Status IN ('Open', 'Paid', 'Pending'))
);

--3.ALTER TABLE operations

--Add insurance_id column
ALTER TABLE Patient
ADD insurance_id VARCHAR(30);

--Rename a table
EXEC sp_rename
'Department','HospitalDepartment';

--Retrieve the renamed table:
SELECT * FROM HospitalDepartment;

--Drop a constraint
--First, added a named constraint:
ALTER TABLE Patient
ADD CONSTRAINT CK_Patient_Age
CHECK (Age >= 0);

--Drop:
ALTER TABLE Patient
DROP CONSTRAINT CK_Patient_Age;

--Effect: Removes the specified age validation rule. The table and its records remain unchanged.

--Verification
SELECT name
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID('Patient');

--4.Insert, update, delete and retrieve records

--Insert records into Tables
INSERT INTO HospitalDepartment (DepartmentName) VALUES('Cardiology'),('Neurology'),('Orthopedics');

INSERT INTO Doctor(DoctorName, DepartmentID, Specialization)
VALUES
('Dr. Kumar', 1, 'Heart Specialist'),
('Dr. Ravi', 2, 'Brain Specialist'),
('Dr. Priya', 1, 'Cardiologist'),
('Dr. Arun', 3, 'Bone Specialist');

INSERT INTO Patient(PatientName, Age, Gender, Phone, insurance_id) VALUES('Arun', 25, 'Male', '9876543210', 'INS101'),
('Priya', 30, 'Female', '9876543211', 'INS102'),
('Kiran', 40, 'Male', '9876543212', 'INS103'),
('Meena', 28, 'Female', '9876543213', 'INS104');

INSERT INTO Visit(PatientID, DoctorID, VisitDate, Diagnosis)VALUES
(1, 1, '2026-10-10', 'Heart Pain'),
(2, 2, '2026-10-15', 'Migraine'),
(1, 3, '2026-11-05', 'Chest Pain'),
(3, 4, '2026-11-10', 'Bone Fracture');

INSERT INTO Billing(VisitID, BillAmount)VALUES(1, 1500),(2, 2000),(3, 1000),(4, 3000);

--Update patient details
UPDATE Patient
SET Phone = '9999999999'
WHERE PatientID = 1;

--Update billing status
UPDATE Billing
SET Status = 'Paid'
WHERE BillID = 1;

--Delete patient record
DELETE FROM Patient
WHERE PatientID = 4;

--Retrieve patients visited in a given month
SELECT
    P.PatientID,
    P.PatientName,
    V.VisitDate,
    V.Diagnosis
FROM Patient P
INNER JOIN Visit V
ON P.PatientID = V.PatientID
WHERE V.VisitDate >= '2026-11-01'
AND V.VisitDate < '2026-12-01';

--Retrieve doctors of a department using LIKE
SELECT
    D.DoctorID,
    D.DoctorName,
    H.DepartmentName,
    D.Specialization
FROM Doctor D
INNER JOIN HospitalDepartment H
ON D.DepartmentID = H.DepartmentID
WHERE H.DepartmentName LIKE '%Cardio%';



