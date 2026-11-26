use hospitaldb

--Creating Tables
CREATE TABLE Wards
(
    WardID INT PRIMARY KEY,
    WardName VARCHAR(100),
    Capacity INT
);


CREATE TABLE Admissions
(
    AdmissionID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    WardID INT,
    AdmissionDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,

    FOREIGN KEY (WardID) REFERENCES Wards(WardID)
);


--Inserting Values into Tables
INSERT INTO Wards VALUES
(1, 'General Ward', 3),
(2, 'ICU', 2),
(3, 'Maternity Ward', 4);
GO

INSERT INTO Admissions
    (AdmissionID, PatientName, WardID)
VALUES
    (101, 'Arun', 1),
    (102, 'Priya', 1),
    (103, 'Kavin', 1),
    (104, 'Meena', 2);
GO

-- Task 1 : After insert Trigger 
CREATE OR ALTER TRIGGER trg_CheckWardCapacity
ON Admissions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS
    (
        SELECT 1
        FROM Wards w
        INNER JOIN Admissions a
            ON w.WardID = a.WardID
        WHERE a.IsActive = 1
          AND w.Capacity <
          (
              SELECT COUNT(*)
              FROM Admissions a2
              WHERE a2.WardID = w.WardID
                AND a2.IsActive = 1
          )
          AND EXISTS
          (
              SELECT 1
              FROM inserted i
              WHERE i.WardID = w.WardID
                AND i.IsActive = 1
          )
    )
    BEGIN
        THROW 50010,
              'Admission rejected: ward bed capacity is full.',
              1;
    END;
END;
GO


INSERT INTO Admissions
    (AdmissionID, PatientName, WardID)
VALUES
    (105, 'Ravi', 1);
SELECT * FROM Admissions;
INSERT INTO Admissions
    (AdmissionID, PatientName, WardID)
VALUES
    (106, 'Divya', 2);


--Task 2 : After insert/update/delete Trigger 
CREATE TABLE admission_audit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    AdmissionID INT,
    ActionType VARCHAR(20),

    OldPatientName VARCHAR(100),
    NewPatientName VARCHAR(100),

    OldWardID INT,
    NewWardID INT,

    OldIsActive BIT,
    NewIsActive BIT,

    ChangedBy VARCHAR(100),
    ChangedAt DATETIME DEFAULT GETDATE()
);
GO


CREATE OR ALTER TRIGGER trg_AdmissionAudit
ON Admissions
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO admission_audit
    (
        AdmissionID,
        ActionType,
        OldPatientName,
        NewPatientName,
        OldWardID,
        NewWardID,
        OldIsActive,
        NewIsActive,
        ChangedBy,
        ChangedAt
    )
    SELECT
        COALESCE(i.AdmissionID, d.AdmissionID),

        CASE
            WHEN d.AdmissionID IS NULL THEN 'INSERT'
            WHEN i.AdmissionID IS NULL THEN 'DELETE'
            ELSE 'UPDATE'
        END,

        d.PatientName,
        i.PatientName,

        d.WardID,
        i.WardID,

        d.IsActive,
        i.IsActive,

        SUSER_SNAME(),
        GETDATE()

    FROM inserted i
    FULL OUTER JOIN deleted d
        ON i.AdmissionID = d.AdmissionID;
END;
GO


--Inserting Values into Tables 
INSERT INTO Admissions
    (AdmissionID, PatientName, WardID)
VALUES
    (107, 'Suresh', 3);


UPDATE Admissions
SET WardID = 2
WHERE AdmissionID = 107;


DELETE FROM Admissions
WHERE AdmissionID = 107;

SELECT * FROM admission_audit ORDER BY AuditID;


-- Task 3 : Batch insert 
INSERT INTO Admissions
    (AdmissionID, PatientName, WardID)
VALUES
    (201, 'Patient A', 3),
    (202, 'Patient B', 3),
    (203, 'Patient C', 3);
GO
INSERT INTO Admissions
    (AdmissionID, PatientName, WardID)
VALUES
    (204, 'Patient D', 3),
    (205, 'Patient E', 3);
GO

SELECT * FROM Admissions WHERE AdmissionID IN (204, 205);
