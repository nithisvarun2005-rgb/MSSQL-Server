-- Creating Databse
CREATE DATABASE AirlineDB;
USE AirlineDB;

-- Creating Tables
CREATE TABLE Flights
(
    FlightID INT PRIMARY KEY,
    FlightNumber VARCHAR(20) NOT NULL UNIQUE,
    Source VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    DepartureTime DATETIME2 NOT NULL
);

CREATE TABLE Passengers
(
    PassengerID INT PRIMARY KEY,
    PassengerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15)
);

CREATE TABLE Seats
(
    SeatID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT NOT NULL,
    SeatNumber VARCHAR(5) NOT NULL,
    SeatStatus VARCHAR(20) DEFAULT 'AVAILABLE',

    FOREIGN KEY (FlightID)
        REFERENCES Flights(FlightID),

    CONSTRAINT UQ_Flight_Seat
        UNIQUE (FlightID, SeatNumber),

    CONSTRAINT CK_SeatStatus
        CHECK (SeatStatus IN ('AVAILABLE', 'BOOKED'))
);

CREATE TABLE Bookings
(
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT NOT NULL,
    SeatID INT NOT NULL,
    PassengerID INT NOT NULL,
    Fare DECIMAL(10,2) NOT NULL,
    BookingDate DATETIME2 DEFAULT SYSDATETIME(),

    FOREIGN KEY (FlightID)
        REFERENCES Flights(FlightID),

    FOREIGN KEY (SeatID)
        REFERENCES Seats(SeatID),

    FOREIGN KEY (PassengerID)
        REFERENCES Passengers(PassengerID),

    CONSTRAINT UQ_Booking_Seat UNIQUE (SeatID),

    CONSTRAINT CK_Booking_Fare CHECK (Fare > 0)
);

-- Inserting Values Into Tables
INSERT INTO Flights
(FlightID, FlightNumber, Source, Destination, DepartureTime)
VALUES
(201, 'AI201', 'Chennai', 'Mumbai', '2026-12-01 08:00:00'),
(202, 'AI202', 'Chennai', 'Delhi', '2026-12-01 10:00:00'),
(203, 'AI203', 'Bangalore', 'Hyderabad', '2026-12-02 09:00:00');

INSERT INTO Passengers
(PassengerID, PassengerName, Email, Phone)
VALUES
(1, 'Arun', 'arun@gmail.com', '9876543210'),
(2, 'Bala', 'bala@gmail.com', '9876543211'),
(3, 'Charan', 'charan@gmail.com', '9876543212'),
(4, 'Deepa', 'deepa@gmail.com', '9876543213'),
(5, 'Elango', 'elango@gmail.com', '9876543214'),
(6, 'Farah', 'farah@gmail.com', '9876543215');

INSERT INTO Seats
(FlightID, SeatNumber, SeatStatus)
VALUES
-- Flight 201
(201, '1A', 'AVAILABLE'),
(201, '1B', 'AVAILABLE'),
(201, '1C', 'AVAILABLE'),
(201, '1D', 'AVAILABLE'),
(201, '2A', 'AVAILABLE'),
(201, '2B', 'AVAILABLE'),

-- Flight 202
(202, '1A', 'AVAILABLE'),
(202, '1B', 'AVAILABLE'),
(202, '1C', 'AVAILABLE'),
(202, '1D', 'AVAILABLE'),
(202, '2A', 'AVAILABLE'),
(202, '2B', 'AVAILABLE'),

-- Flight 203
(203, '1A', 'AVAILABLE'),
(203, '1B', 'AVAILABLE'),
(203, '1C', 'AVAILABLE'),
(203, '1D', 'AVAILABLE'),
(203, '2A', 'AVAILABLE'),
(203, '2B', 'AVAILABLE');

INSERT INTO Bookings
(FlightID, SeatID, PassengerID, Fare)
SELECT
    V.FlightID,
    S.SeatID,
    V.PassengerID,
    V.Fare
FROM
(
    VALUES
    (201, '1A', 1, 5000.00),
    (201, '1B', 2, 5000.00),
    (201, '1C', 3, 4500.00),

    (202, '1A', 4, 7000.00),
    (202, '1B', 5, 6000.00),
    (202, '1C', 6, 6000.00)
) AS V(FlightID, SeatNumber, PassengerID, Fare)
INNER JOIN Seats S
    ON S.FlightID = V.FlightID
    AND S.SeatNumber = V.SeatNumber;

-- Question 1: Booking Transaction Using BEGIN TRAN, COMMIT and ROLLBACK
DECLARE @FlightID INT = 201;
DECLARE @PassengerID INT = 4;
DECLARE @SeatNumber VARCHAR(5) = '1D';
DECLARE @Fare DECIMAL(10,2) = 5500;
DECLARE @SeatID INT;

BEGIN TRY

    BEGIN TRAN;

    -- Check seat availability and lock the row
    SELECT @SeatID = SeatID
    FROM Seats WITH (UPDLOCK, HOLDLOCK)
    WHERE FlightID = @FlightID
      AND SeatNumber = @SeatNumber
      AND SeatStatus = 'AVAILABLE';

    -- Validate seat
    IF @SeatID IS NULL
        THROW 50001, 'Seat is not available', 1;

    -- Validate passenger
    IF NOT EXISTS
    (
        SELECT 1
        FROM Passengers
        WHERE PassengerID = @PassengerID
    )
        THROW 50002, 'Passenger does not exist', 1;

    -- Validate fare
    IF @Fare <= 0
        THROW 50003, 'Invalid fare amount', 1;

    -- Update seat status
    UPDATE Seats
    SET SeatStatus = 'BOOKED'
    WHERE SeatID = @SeatID
      AND SeatStatus = 'AVAILABLE';

    IF @@ROWCOUNT <> 1
        THROW 50004, 'Seat booking failed', 1;

    -- Insert booking record
    INSERT INTO Bookings
    (FlightID, SeatID, PassengerID, Fare)
    VALUES
    (@FlightID, @SeatID, @PassengerID, @Fare);

    COMMIT TRAN;

    PRINT 'Seat booked successfully';

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRAN;

    PRINT ERROR_MESSAGE();

END CATCH;

-- Question 2: Simulate Two Simultaneous Bookings
-- Part A: READ COMMITTED

-- Session 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;

SELECT SeatID, SeatStatus
FROM Seats
WHERE FlightID = 201
AND SeatNumber = '2A';

WAITFOR DELAY '00:00:15';

UPDATE Seats
SET SeatStatus = 'BOOKED'
WHERE FlightID = 201
AND SeatNumber = '2A';

COMMIT TRAN;

-- Session 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;

SELECT SeatID, SeatStatus
FROM Seats
WHERE FlightID = 201
AND SeatNumber = '2A';

UPDATE Seats
SET SeatStatus = 'BOOKED'
WHERE FlightID = 201
AND SeatNumber = '2A';

COMMIT TRAN;


-- Part B: SERIALIZABLE

-- Session 1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN;

SELECT SeatID, SeatStatus
FROM Seats
WHERE FlightID = 201
AND SeatNumber = '2A';

WAITFOR DELAY '00:00:15';

UPDATE Seats
SET SeatStatus = 'BOOKED'
WHERE FlightID = 201
AND SeatNumber = '2A'
AND SeatStatus = 'AVAILABLE';

COMMIT TRAN;

-- Session 2
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN;

SELECT SeatID, SeatStatus
FROM Seats
WHERE FlightID = 201
AND SeatNumber = '2A';

UPDATE Seats
SET SeatStatus = 'BOOKED'
WHERE FlightID = 201
AND SeatNumber = '2A'
AND SeatStatus = 'AVAILABLE';

IF @@ROWCOUNT = 0
BEGIN
    ROLLBACK TRAN;
    PRINT 'Seat is already booked';
END
ELSE
BEGIN
    COMMIT TRAN;
    PRINT 'Booking successful';
END;


-- Question 3: Passenger Ranking Using RANK() and DENSE_RANK()

SELECT
    F.FlightNumber,
    P.PassengerName,
    B.Fare,

    RANK() OVER
    (
        PARTITION BY B.FlightID
        ORDER BY B.Fare DESC
    ) AS FareRank,

    DENSE_RANK() OVER
    (
        PARTITION BY B.FlightID
        ORDER BY B.Fare DESC
    ) AS DenseFareRank

FROM Bookings B

INNER JOIN Flights F
    ON B.FlightID = F.FlightID

INNER JOIN Passengers P
    ON B.PassengerID = P.PassengerID

ORDER BY
    B.FlightID,
    B.Fare DESC;


-- Question 4: CTE and Running Total Using SUM() OVER

WITH FlightRevenue AS
(
    SELECT
        B.BookingID,
        B.FlightID,
        F.FlightNumber,
        P.PassengerName,
        B.Fare,
        B.BookingDate,

        RANK() OVER
        (
            PARTITION BY B.FlightID
            ORDER BY B.Fare DESC
        ) AS FareRank,

        DENSE_RANK() OVER
        (
            PARTITION BY B.FlightID
            ORDER BY B.Fare DESC
        ) AS DenseFareRank,

        SUM(B.Fare) OVER
        (
            PARTITION BY B.FlightID
            ORDER BY B.BookingDate, B.BookingID
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS RunningRevenue

    FROM Bookings B

    INNER JOIN Flights F
        ON B.FlightID = F.FlightID

    INNER JOIN Passengers P
        ON B.PassengerID = P.PassengerID
)

SELECT *
FROM FlightRevenue
ORDER BY FlightID, BookingDate, BookingID;

