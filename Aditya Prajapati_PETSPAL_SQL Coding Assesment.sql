-- 1.Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetsPal”
IF DB_ID('PetPals') IS NOT NULL
BEGIN
    DROP DATABASE PetPals;
END

CREATE DATABASE PetsPal;
USE PetsPal;

-- 2. Create tables for pets, shelters, donations, adoption events, and participants. &
-- 3. Define appropriate primary keys, foreign keys, and constraints &
-- 4. Ensure the script handles potential errors, such as if the database or tables already exist.
--Pets Table
IF OBJECT_ID('Pets', 'U') IS NOT NULL
BEGIN
    DROP TABLE Pets;
END

CREATE TABLE Pets (
    PetID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Breed VARCHAR(100),
    Type VARCHAR(50),
    AvailableForAdoption BIT
);

IF OBJECT_ID('Shelters', 'U') IS NOT NULL
BEGIN
    DROP TABLE Shelters;
END

-- Shelters
CREATE TABLE Shelters (
    ShelterID INT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(255)
);

IF OBJECT_ID('Donations', 'U') IS NOT NULL
BEGIN
    DROP TABLE Donations;
END

-- Donations
CREATE TABLE Donations (
    DonationID INT PRIMARY KEY,
    DonorName VARCHAR(100),
    DonationType VARCHAR(50),
    DonationAmount DECIMAL(10, 2) NULL, -- Applicable for cash donations
    DonationItem VARCHAR(100) NULL,     -- Applicable for item donations
    DonationDate DATETIME
);

IF OBJECT_ID('AdoptionEvents', 'U') IS NOT NULL
BEGIN
    DROP TABLE AdoptionEvents;
END
-- Adoption Events
CREATE TABLE AdoptionEvents (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(100),
    EventDate DATETIME,
    Location VARCHAR(255)
);

IF OBJECT_ID('Participants', 'U') IS NOT NULL
BEGIN
    DROP TABLE Participants;
END

-- Participants Table 
CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY,
    ParticipantName VARCHAR(100),
    ParticipantType VARCHAR(50),
    EventID INT, 
    FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID)
);


-- INSERTING DATA IN TABLES

-- Pets Table Data
INSERT INTO Pets (PetID, Name, Age, Breed, Type, AvailableForAdoption)
VALUES
(1, 'Tommy', 3, 'Labrador', 'Dog', 1),
(2, 'Milo', 2, 'Beagle', 'Dog', 1),
(3, 'Simba', 1, 'Persian', 'Cat', 1),
(4, 'Sheru', 5, 'Golden Retriever', 'Dog', 0),
(5, 'Chintu', 4, 'Parrot', 'Bird', 1),
(6, 'Billi', 3, 'Siamese', 'Cat', 0),
(7, 'Rocky', 2, 'Pug', 'Dog', 1),
(8, 'Tuffy', 6, 'German Shepherd', 'Dog', 0),
(9, 'Snowy', 1, 'Siberian Husky', 'Dog', 1),
(10, 'Minnie', 2, 'Rabbit', 'Animal', 1);

-- Shelters Table Data
INSERT INTO Shelters (ShelterID, Name, Location)
VALUES
(1, 'Paws and Whiskers Shelter', 'Mumbai, Maharashtra'),
(2, 'Care for Animals', 'Delhi, Delhi'),
(3, 'Happy Tails Shelter', 'Chennai, Tamil Nadu'),
(4, 'Animal Care Center', 'Bengaluru, Karnataka'),
(5, 'Pet Haven', 'Hyderabad, Telangana');

-- Donations Table Data
INSERT INTO Donations (DonationID, DonorName, DonationType, DonationAmount, DonationItem, DonationDate)
VALUES
(1, 'Rahul Mehta', 'Cash', 5000.00, NULL, '2024-09-10 10:30:00'),
(2, 'Neha Verma', 'Item', NULL, 'Dog Food', '2024-09-15 12:00:00'),
(3, 'Amit Singh', 'Cash', 10000.00, NULL, '2024-09-20 09:00:00'),
(4, 'Pooja Iyer', 'Item', NULL, 'Pet Toys', '2024-09-22 11:15:00'),
(5, 'Siddharth Rao', 'Cash', 7500.00, NULL, '2024-09-25 14:45:00');

-- Adoptions Event Data
INSERT INTO AdoptionEvents (EventID, EventName, EventDate, Location)
VALUES
(1, 'Adoptathon Mumbai 2024', '2024-10-05 10:00:00', 'Mumbai, Maharashtra'),
(2, 'Delhi Pet Adoption Drive', '2024-11-01 11:00:00', 'Delhi, Delhi'),
(3, 'Chennai Pet Fest', '2024-12-15 09:00:00', 'Chennai, Tamil Nadu'),
(4, 'Bangalore Rescue Fair', '2024-10-18 12:00:00', 'Bengaluru, Karnataka'),
(5, 'Hyderabad Stray Adoption Event', '2024-11-30 13:30:00', 'Hyderabad, Telangana');

-- Participants Table Data
INSERT INTO Participants (ParticipantID, ParticipantName, ParticipantType, EventID)
VALUES
(1, 'Paws and Whiskers Shelter', 'Shelter', 1),
(2, 'Care for Animals', 'Shelter', 2),
(3, 'Happy Tails Shelter', 'Shelter', 3),
(4, 'Animal Care Center', 'Shelter', 4),
(5, 'Pet Haven', 'Shelter', 5),
(6, 'Rahul Mehta', 'Adopter', 1),
(7, 'Neha Verma', 'Adopter', 2),
(8, 'Amit Singh', 'Adopter', 3),
(9, 'Pooja Iyer', 'Adopter', 4),
(10, 'Siddharth Rao', 'Adopter', 5);

--5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption) from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure that
--   the query filters out pets that are not available for adoption
SELECT Name, Age, Breed, Type FROM Pets WHERE AvailableForAdoption = 1;

--6. Write an SQL query that retrieves the names of participants (shelters and adopters) registered for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query
--   joins the necessary tables to retrieve the participant names and types.
DECLARE @EventID INT;
SET @EventID = 1;
SELECT p.ParticipantName, p.ParticipantType FROM Participants p INNER JOIN AdoptionEvents ae ON p.EventID = ae.EventID 
WHERE p.EventID = @EventID; -- @EventID is the parameter

--7. Create a stored procedure in SQL that allows a shelter to update its information (name and location) in the "Shelters" table. Use parameters to pass the shelter ID and the new information.
--   Ensure that the procedure performs the update and handles potential errors, such as an invalid shelter ID.
GO
CREATE PROCEDURE UpdateShelterInfo
    @ShelterID INT,
    @NewName VARCHAR(100),
    @NewLocation VARCHAR(255)
AS
BEGIN
    -- Check if the shelter exists
    IF EXISTS (SELECT 1 FROM Shelters WHERE ShelterID = @ShelterID)
    BEGIN
        -- Update the shelter's information
        UPDATE Shelters
        SET Name = @NewName,
            Location = @NewLocation
        WHERE ShelterID = @ShelterID;
        
        PRINT 'Shelter information updated successfully.';
    END
    ELSE
    BEGIN
        -- Handle the error case where the shelter ID is invalid
        PRINT 'Error: Shelter ID not found.';
    END
END;
GO

--8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) from the "Donations" table. The result should include the shelter name and the
--total donation amount. Ensure that the query handles cases where a shelter has received no donations
SELECT S.Name AS ShelterName, 
       SUM(D.DonationAmount) AS TotalDonationAmount
FROM Shelters S
LEFT JOIN Donations D ON S.ShelterID = D.DonationID -- Assuming Donations are linked by ShelterID
GROUP BY S.Name;

--9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the resultset.SELECT Name, Age, Breed, Type
FROM Pets
WHERE AvailableForAdoption = 1;

--10.Write an SQL query that retrieves the total donation amount for each month and year (e.g.,January 2023) from the "Donations" table. The result should include the month-year and the
--corresponding total donation amount. Ensure that the query handles cases where no donations
--were made in a specific month-year.
SELECT FORMAT(DonationDate, 'MMMM yyyy') AS MonthYear,
       SUM(DonationAmount) AS TotalDonationAmount
FROM Donations
GROUP BY YEAR(DonationDate), MONTH(DonationDate), FORMAT(DonationDate, 'MMMM yyyy')
ORDER BY YEAR(DonationDate), MONTH(DonationDate);

--11.Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
SELECT DISTINCT Breed
FROM Pets
WHERE (Age BETWEEN 1 AND 3) OR Age > 5;

--12.Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.
SELECT P.Name AS PetName, 
       P.Age, 
       P.Breed, 
       P.Type, 
       S.Name AS ShelterName, 
       S.Location
FROM Pets P
JOIN Participants PT ON PT.EventID IN (
    SELECT AE.EventID 
    FROM AdoptionEvents AE
    WHERE AE.EventID = PT.EventID
)
JOIN Shelters S ON PT.ParticipantID = S.ShelterID WHERE P.AvailableForAdoption = 1;

--13.Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai
SELECT COUNT(DISTINCT PT.ParticipantID) AS TotalParticipants
FROM Participants PT
JOIN AdoptionEvents AE ON PT.EventID = AE.EventID
JOIN Participants S ON S.EventID = AE.EventID
WHERE S.ParticipantType = 'Shelter' -- Ensure we are considering only shelters
AND S.ParticipantID IN (SELECT ShelterID FROM Shelters WHERE Location = 'Chennai');

--14.Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 5;

--15.Find the pets that have not been adopted by selecting their information from the 'Pet' table.
SELECT Name, Age, Breed, Type
FROM Pets
WHERE AvailableForAdoption = 1;

--16.Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
SELECT P.Name AS PetName, 
       PT.ParticipantName AS AdopterName
FROM Pets P
JOIN AdoptionEvents AE ON AE.EventID IN (
    SELECT EventID 
    FROM Participants 
    WHERE ParticipantType = 'Adopter'
)
JOIN Participants PT ON AE.EventID = PT.EventID 
WHERE PT.ParticipantType = 'Adopter';

--17.Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.
SELECT S.Name AS ShelterName, 
       COUNT(P.PetID) AS AvailablePetsCount
FROM Shelters S
LEFT JOIN Participants PT ON PT.ParticipantID IN (
    SELECT ParticipantID 
    FROM Participants 
    WHERE ParticipantType = 'Shelter'
)
LEFT JOIN AdoptionEvents AE ON PT.EventID = AE.EventID
LEFT JOIN Pets P ON P.AvailableForAdoption = 1 
WHERE PT.ParticipantType = 'Shelter'
GROUP BY S.Name;

--18. Find pairs of pets from the same shelter that have the same breed.
SELECT A.Name AS Pet1, 
       B.Name AS Pet2, 
       S.Name AS ShelterName
FROM Pets A
JOIN Participants PT1 ON PT1.EventID IN (
    SELECT EventID 
    FROM Participants 
    WHERE ParticipantType = 'Shelter'
)
JOIN AdoptionEvents AE1 ON PT1.EventID = AE1.EventID
JOIN Pets B ON A.Breed = B.Breed AND A.PetID <> B.PetID
JOIN Participants PT2 ON PT2.EventID = AE1.EventID
JOIN Shelters S ON PT1.ParticipantID = S.ShelterID
WHERE A.AvailableForAdoption = 1 
AND B.AvailableForAdoption = 1
AND PT1.ParticipantType = 'Shelter';

--19. . List all possible combinations of shelters and adoption events.
SELECT S.Name AS ShelterName, AE.EventName
FROM Shelters S
CROSS JOIN AdoptionEvents AE;

--20. Determine the shelter that has the highest number of adopted.
SELECT TOP 1 S.Name AS ShelterName, 
              COUNT(P.PetID) AS AdoptedPetsCount
FROM Shelters S
JOIN Participants PT ON PT.ParticipantID IN (
    SELECT ParticipantID 
    FROM Participants 
    WHERE ParticipantType = 'Shelter'
)
JOIN AdoptionEvents AE ON PT.EventID = AE.EventID
JOIN Pets P ON P.AvailableForAdoption = 0 
WHERE PT.ParticipantType = 'Shelter'
GROUP BY S.Name
ORDER BY COUNT(P.PetID) DESC; 
