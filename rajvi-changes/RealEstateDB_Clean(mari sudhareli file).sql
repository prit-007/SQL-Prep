-- ========================================================
-- DREAM DWELLINGS REAL ESTATE - CLEAN DATABASE SCRIPT
-- ========================================================
-- Server: PRIT-LEGION
-- Database: RealEstate
-- ========================================================

USE RealEstate;
GO

-- ========================================================
-- DROP EXISTING OBJECTS (FOR CLEAN RERUN)
-- ========================================================
IF OBJECT_ID('PR_PropertyImage_Insert', 'P') IS NOT NULL DROP PROCEDURE PR_PropertyImage_Insert;
IF OBJECT_ID('PR_PropertyImage_Delete', 'P') IS NOT NULL DROP PROCEDURE PR_PropertyImage_Delete;
IF OBJECT_ID('PR_Property_Insert', 'P') IS NOT NULL DROP PROCEDURE PR_Property_Insert;
IF OBJECT_ID('PR_Property_SelectAll', 'P') IS NOT NULL DROP PROCEDURE PR_Property_SelectAll;
IF OBJECT_ID('PR_Property_SelectByPK', 'P') IS NOT NULL DROP PROCEDURE PR_Property_SelectByPK;
IF OBJECT_ID('PR_Property_SelectByType', 'P') IS NOT NULL DROP PROCEDURE PR_Property_SelectByType;
IF OBJECT_ID('PR_GetPropertiesForCategory', 'P') IS NOT NULL DROP PROCEDURE PR_GetPropertiesForCategory;
IF OBJECT_ID('PR_GetPropertiesByTypeAndCategory', 'P') IS NOT NULL DROP PROCEDURE PR_GetPropertiesByTypeAndCategory;
IF OBJECT_ID('PR_User_Login', 'P') IS NOT NULL DROP PROCEDURE PR_User_Login;
IF OBJECT_ID('PR_User_SelectAll', 'P') IS NOT NULL DROP PROCEDURE PR_User_SelectAll;
IF OBJECT_ID('PR_User_Insert', 'P') IS NOT NULL DROP PROCEDURE PR_User_Insert;
IF OBJECT_ID('PR_Agent_SelectAll', 'P') IS NOT NULL DROP PROCEDURE PR_Agent_SelectAll;
IF OBJECT_ID('PR_Agent_SelectByPK', 'P') IS NOT NULL DROP PROCEDURE PR_Agent_SelectByPK;
IF OBJECT_ID('PR_Agent_Insert', 'P') IS NOT NULL DROP PROCEDURE PR_Agent_Insert;
IF OBJECT_ID('PR_Agent_Update', 'P') IS NOT NULL DROP PROCEDURE PR_Agent_Update;
IF OBJECT_ID('PR_Agent_Delete', 'P') IS NOT NULL DROP PROCEDURE PR_Agent_Delete;
IF OBJECT_ID('PR_Feedback_SelectAll', 'P') IS NOT NULL DROP PROCEDURE PR_Feedback_SelectAll;
IF OBJECT_ID('PR_Feedback_Insert', 'P') IS NOT NULL DROP PROCEDURE PR_Feedback_Insert;
IF OBJECT_ID('PR_Appointment_SelectAll', 'P') IS NOT NULL DROP PROCEDURE PR_Appointment_SelectAll;
IF OBJECT_ID('PR_Appointment_UpdateStatus', 'P') IS NOT NULL DROP PROCEDURE PR_Appointment_UpdateStatus;
IF OBJECT_ID('PR_Appointment_Insert', 'P') IS NOT NULL DROP PROCEDURE PR_Appointment_Insert;
IF OBJECT_ID('PR_PropertyType_SelectAll', 'P') IS NOT NULL DROP PROCEDURE PR_PropertyType_SelectAll;
IF OBJECT_ID('PR_PropertyType_Insert', 'P') IS NOT NULL DROP PROCEDURE PR_PropertyType_Insert;
IF OBJECT_ID('PR_GetTotalUsers', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalUsers;
IF OBJECT_ID('PR_GetTotalProperties', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalProperties;
IF OBJECT_ID('PR_GetTotalAgents', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalAgents;
IF OBJECT_ID('PR_GetTotalBuyProperties', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalBuyProperties;
IF OBJECT_ID('PR_GetTotalSellProperties', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalSellProperties;
IF OBJECT_ID('PR_GetTotalRentProperties', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalRentProperties;
IF OBJECT_ID('PR_GetTotalActiveAgents', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalActiveAgents;
IF OBJECT_ID('PR_GetTotalInactiveAgents', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalInactiveAgents;
IF OBJECT_ID('PR_GetTotalSuspendedAgents', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalSuspendedAgents;
IF OBJECT_ID('PR_GetTotalPropertiesByType', 'P') IS NOT NULL DROP PROCEDURE PR_GetTotalPropertiesByType;
IF OBJECT_ID('PR_Property_Dashboard', 'P') IS NOT NULL DROP PROCEDURE PR_Property_Dashboard;
IF OBJECT_ID('PR_Property_Delete', 'P') IS NOT NULL DROP PROCEDURE PR_Property_Delete;
IF OBJECT_ID('PR_Property_Filter', 'P') IS NOT NULL DROP PROCEDURE PR_Property_Filter;

IF OBJECT_ID('PropertyImages', 'U') IS NOT NULL DROP TABLE PropertyImages;
IF OBJECT_ID('Properties', 'U') IS NOT NULL DROP TABLE Properties;
IF OBJECT_ID('PropertyTypes', 'U') IS NOT NULL DROP TABLE PropertyTypes;
IF OBJECT_ID('Appointments', 'U') IS NOT NULL DROP TABLE Appointments;
IF OBJECT_ID('Feedback', 'U') IS NOT NULL DROP TABLE Feedback;
IF OBJECT_ID('Agents', 'U') IS NOT NULL DROP TABLE Agents;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- ========================================================
-- CREATE TABLES (IN CORRECT ORDER)
-- ========================================================

-- 1. Users Table
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(50) CHECK (Role IN ('Admin', 'Buyer', 'Seller', 'User'))
);
GO

-- 2. PropertyTypes Table (must be before Properties)
CREATE TABLE PropertyTypes (
    PropertyTypeId INT PRIMARY KEY IDENTITY(1,1),
    PropertyType VARCHAR(50) UNIQUE NOT NULL
);
GO

-- 3. Properties Table
CREATE TABLE Properties (
    PropertyId INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(150) NOT NULL,
    Description VARCHAR(MAX),
    PropertyTypeId INT NOT NULL,
    Category VARCHAR(50) CHECK (Category IN ('Buy', 'Rent', 'Sell')),
    Price DECIMAL(18,2) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Area FLOAT NOT NULL,
    Bedrooms INT,
    Bathrooms INT,
    Amenities VARCHAR(MAX),
    ListedDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(50) CHECK (Status IN ('Available', 'Sold', 'Pending', 'UnderOffer', 'Rented', 'Active')),
    ImageName VARCHAR(255),
    ImagePath VARCHAR(MAX),
    CONSTRAINT FK_Property_PropertyType FOREIGN KEY (PropertyTypeId) 
        REFERENCES PropertyTypes (PropertyTypeId) ON DELETE CASCADE
);
GO

-- 4. PropertyImages Table
CREATE TABLE PropertyImages (
    ImageId INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT FOREIGN KEY REFERENCES Properties(PropertyId) ON DELETE CASCADE,
    ImageName VARCHAR(255),
    ImagePath VARCHAR(MAX),
    IsPrimary BIT DEFAULT 0,
    DisplayOrder INT
);
GO

-- 5. Agents Table
CREATE TABLE Agents (
    AgentId INT PRIMARY KEY IDENTITY(1,1),
    AgentName VARCHAR(100) UNIQUE, 
    LicenseNumber VARCHAR(50) NOT NULL UNIQUE,
    ExperienceYears INT NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    OfficeAddress VARCHAR(255),
    ProfilePicture VARCHAR(MAX),
    ProfilePicturePath VARCHAR(MAX),
    Status VARCHAR(50) CHECK (Status IN ('Active', 'Inactive', 'Suspended'))
);
GO

-- 6. Appointments Table
CREATE TABLE Appointments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserEmail NVARCHAR(255),
    AppointmentDate DATETIME,
    Status NVARCHAR(50) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Confirmed', 'Canceled'))
);
GO

-- 7. Feedback Table
CREATE TABLE Feedback (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- ========================================================
-- SEED DATA - PROPERTY TYPES
-- ========================================================
INSERT INTO PropertyTypes (PropertyType) VALUES ('House');
INSERT INTO PropertyTypes (PropertyType) VALUES ('Apartment');
INSERT INTO PropertyTypes (PropertyType) VALUES ('Commercial');
GO

-- ========================================================
-- SEED DATA - SAMPLE USER
-- ========================================================
INSERT INTO Users (UserName, Email, Password, Role) VALUES 
('Admin', 'admin@dreamdwellings.com', 'admin123', 'Admin');
GO

-- ========================================================
-- STORED PROCEDURES - USERS
-- ========================================================

CREATE PROCEDURE PR_User_SelectAll
AS
BEGIN
    SELECT UserId, UserName, Email, Password, Role FROM Users;
END;
GO

CREATE PROCEDURE PR_User_Login
    @Email NVARCHAR(50),
    @Password NVARCHAR(50)
AS
BEGIN
    SELECT UserId, UserName, Email, Password, Role 
    FROM Users 
    WHERE Email = @Email AND Password = @Password;
END;
GO

CREATE PROCEDURE PR_User_Insert
    @UserName VARCHAR(100),
    @Email VARCHAR(100),
    @Password VARCHAR(255),
    @Role VARCHAR(50)
AS
BEGIN
    INSERT INTO Users (UserName, Email, Password, Role)
    VALUES (@UserName, @Email, @Password, @Role);
END;
GO

-- ========================================================
-- STORED PROCEDURES - PROPERTY TYPES
-- ========================================================

CREATE PROCEDURE PR_PropertyType_SelectAll
AS
BEGIN
    SELECT PropertyTypeId, PropertyType FROM PropertyTypes;
END;
GO

CREATE PROCEDURE PR_PropertyType_Insert
    @PropertyType VARCHAR(50)
AS
BEGIN
    INSERT INTO PropertyTypes (PropertyType) VALUES (@PropertyType);
END;
GO

-- ========================================================
-- STORED PROCEDURES - PROPERTIES
-- ========================================================

CREATE PROCEDURE PR_Property_SelectAll
AS
BEGIN
    SELECT 
        p.PropertyId, p.Title, p.Description, p.ListedDate,
        p.PropertyTypeId, pt.PropertyType,
        p.Category, p.Price, p.Location, p.Area,
        p.Bedrooms, p.Bathrooms, p.Amenities, p.Status,
        pi.ImageId, pi.ImageName, pi.ImagePath, pi.IsPrimary, pi.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages pi ON p.PropertyId = pi.PropertyId
    ORDER BY p.PropertyId;
END;
GO

CREATE PROCEDURE PR_Property_SelectByPK
    @PropertyId INT
AS
BEGIN
    SELECT 
        p.PropertyId, p.Title, p.Description, p.ListedDate,
        p.PropertyTypeId, pt.PropertyType,
        p.Category, p.Price, p.Location, p.Area,
        p.Bedrooms, p.Bathrooms, p.Amenities, p.Status,
        pi.ImageId, pi.ImageName, pi.ImagePath, pi.IsPrimary, pi.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages pi ON p.PropertyId = pi.PropertyId
    WHERE p.PropertyId = @PropertyId;
END;
GO

CREATE PROCEDURE PR_Property_Insert
    @Title VARCHAR(150),
    @Description VARCHAR(MAX),
    @PropertyTypeId INT,
    @Category VARCHAR(50),
    @Price DECIMAL(18,2),
    @Location VARCHAR(255),
    @Area FLOAT,
    @Bedrooms INT,
    @Bathrooms INT,
    @Amenities VARCHAR(MAX),
    @Status VARCHAR(50)
AS
BEGIN
    INSERT INTO Properties (Title, Description, PropertyTypeId, Category, Price, Location, Area, Bedrooms, Bathrooms, Amenities, Status)
    VALUES (@Title, @Description, @PropertyTypeId, @Category, @Price, @Location, @Area, @Bedrooms, @Bathrooms, @Amenities, @Status);
    
    SELECT SCOPE_IDENTITY() AS PropertyId;
END;
GO

CREATE PROCEDURE PR_GetPropertiesForCategory
    @Category VARCHAR(50)
AS
BEGIN
    SELECT 
        p.PropertyId, p.Title, p.Description, p.ListedDate,
        p.PropertyTypeId, pt.PropertyType,
        p.Category, p.Price, p.Location, p.Area,
        p.Bedrooms, p.Bathrooms, p.Amenities, p.Status,
        pi.ImageId, pi.ImageName, pi.ImagePath, pi.IsPrimary, pi.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages pi ON p.PropertyId = pi.PropertyId
    WHERE p.Category = @Category
    ORDER BY p.ListedDate DESC;
END;
GO

CREATE PROCEDURE PR_GetPropertiesByTypeAndCategory
    @PropertyType VARCHAR(50),
    @Category VARCHAR(50) = NULL
AS
BEGIN
    SELECT 
        p.PropertyId, p.Title, p.Description, p.ListedDate,
        p.PropertyTypeId, pt.PropertyType,
        p.Category, p.Price, p.Location, p.Area,
        p.Bedrooms, p.Bathrooms, p.Amenities, p.Status,
        pi.ImageId, pi.ImageName, pi.ImagePath, pi.IsPrimary, pi.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages pi ON p.PropertyId = pi.PropertyId
    WHERE pt.PropertyType = @PropertyType
      AND (@Category IS NULL OR p.Category = @Category)
    ORDER BY p.ListedDate DESC;
END;
GO

CREATE PROCEDURE PR_Property_SelectByType
    @PropertyType VARCHAR(50)
AS
BEGIN
    SELECT 
        p.PropertyId, p.Title, p.Description, p.ListedDate,
        p.PropertyTypeId, pt.PropertyType,
        p.Category, p.Price, p.Location, p.Area,
        p.Bedrooms, p.Bathrooms, p.Amenities, p.Status,
        pi.ImageId, pi.ImageName, pi.ImagePath, pi.IsPrimary, pi.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages pi ON p.PropertyId = pi.PropertyId
    WHERE pt.PropertyType = @PropertyType
    ORDER BY p.ListedDate DESC;
END;
GO

-- ========================================================
-- STORED PROCEDURES - PROPERTY IMAGES
-- ========================================================

CREATE PROCEDURE PR_PropertyImage_Insert
    @PropertyId INT,
    @ImageName VARCHAR(255),
    @ImagePath VARCHAR(MAX),
    @DisplayOrder INT,
    @IsPrimary BIT = 0
AS
BEGIN
    INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary)
    VALUES (@PropertyId, @ImageName, @ImagePath, @DisplayOrder, @IsPrimary);
END;
GO

CREATE PROCEDURE PR_PropertyImage_Delete
    @ImageId INT
AS
BEGIN
    DELETE FROM PropertyImages WHERE ImageId = @ImageId;
END;
GO

-- ========================================================
-- STORED PROCEDURES - DELETE
-- ========================================================

CREATE PROCEDURE PR_Property_Delete
    @PropertyId INT
AS
BEGIN
    DELETE FROM PropertyImages WHERE PropertyId = @PropertyId;
    DELETE FROM Properties WHERE PropertyId = @PropertyId;
END;
GO

-- ========================================================
-- STORED PROCEDURES - AGENTS
-- ========================================================

CREATE PROCEDURE PR_Agent_SelectAll
AS
BEGIN
    SELECT AgentId, AgentName, LicenseNumber, ExperienceYears, ContactNumber, OfficeAddress, ProfilePicture, ProfilePicturePath, Status
    FROM Agents;
END;
GO

CREATE PROCEDURE PR_Agent_SelectByPK
    @AgentId INT
AS
BEGIN
    SELECT AgentId, AgentName, LicenseNumber, ExperienceYears, ContactNumber, OfficeAddress, ProfilePicture, ProfilePicturePath, Status
    FROM Agents
    WHERE AgentId = @AgentId;
END;
GO

CREATE PROCEDURE PR_Agent_Insert
    @AgentName VARCHAR(100),
    @LicenseNumber VARCHAR(50),
    @ExperienceYears INT,
    @ContactNumber VARCHAR(15),
    @OfficeAddress VARCHAR(255),
    @ProfilePicture VARCHAR(MAX),
    @ProfilePicturePath VARCHAR(MAX),
    @Status VARCHAR(50)
AS
BEGIN
    INSERT INTO Agents (AgentName, LicenseNumber, ExperienceYears, ContactNumber, OfficeAddress, ProfilePicture, ProfilePicturePath, Status)
    VALUES (@AgentName, @LicenseNumber, @ExperienceYears, @ContactNumber, @OfficeAddress, @ProfilePicture, @ProfilePicturePath, @Status);
END;
GO

CREATE PROCEDURE PR_Agent_Update
    @AgentId INT,
    @AgentName VARCHAR(100),
    @LicenseNumber VARCHAR(50),
    @ExperienceYears INT,
    @ContactNumber VARCHAR(15),
    @OfficeAddress VARCHAR(255),
    @ProfilePicture VARCHAR(MAX),
    @ProfilePicturePath VARCHAR(MAX),
    @Status VARCHAR(50)
AS
BEGIN
    UPDATE Agents
    SET AgentName = @AgentName, LicenseNumber = @LicenseNumber, ExperienceYears = @ExperienceYears,
        ContactNumber = @ContactNumber, OfficeAddress = @OfficeAddress, ProfilePicture = @ProfilePicture,
        ProfilePicturePath = @ProfilePicturePath, Status = @Status
    WHERE AgentId = @AgentId;
END;
GO

CREATE PROCEDURE PR_Agent_Delete
    @AgentId INT
AS
BEGIN
    DELETE FROM Agents WHERE AgentId = @AgentId;
END;
GO

-- ========================================================
-- STORED PROCEDURES - APPOINTMENTS
-- ========================================================

CREATE PROCEDURE PR_Appointment_SelectAll
AS
BEGIN
    SELECT Id, UserEmail, AppointmentDate, Status FROM Appointments;
END;
GO

CREATE PROCEDURE PR_Appointment_Insert
    @UserEmail NVARCHAR(255),
    @AppointmentDate DATETIME,
    @Status NVARCHAR(50) = 'Pending'
AS
BEGIN
    INSERT INTO Appointments (UserEmail, AppointmentDate, Status)
    VALUES (@UserEmail, @AppointmentDate, @Status);
END;
GO

CREATE PROCEDURE PR_Appointment_UpdateStatus
    @Id INT,
    @Status NVARCHAR(50)
AS
BEGIN
    UPDATE Appointments SET Status = @Status WHERE Id = @Id;
END;
GO

-- ========================================================
-- STORED PROCEDURES - FEEDBACK
-- ========================================================

CREATE PROCEDURE PR_Feedback_SelectAll
AS
BEGIN
    SELECT Id, Name, Email, Message, CreatedDate FROM Feedback ORDER BY Id DESC;
END;
GO

CREATE PROCEDURE PR_Feedback_Insert
    @Name NVARCHAR(100),
    @Email NVARCHAR(255),
    @Message NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Feedback (Name, Email, Message) VALUES (@Name, @Email, @Message);
END;
GO

-- ========================================================
-- STORED PROCEDURES - DASHBOARD
-- ========================================================

CREATE PROCEDURE PR_GetTotalUsers
AS
BEGIN
    SELECT COUNT(*) AS TotalUsers FROM Users;
END;
GO

CREATE PROCEDURE PR_GetTotalProperties
AS
BEGIN
    SELECT COUNT(*) AS TotalProperties FROM Properties;
END;
GO

CREATE PROCEDURE PR_GetTotalAgents
AS
BEGIN
    SELECT COUNT(*) AS TotalAgents FROM Agents;
END;
GO

CREATE PROCEDURE PR_GetTotalBuyProperties
AS
BEGIN
    SELECT COUNT(*) AS TotalBuyProperties FROM Properties WHERE Category = 'Sell';
END;
GO

CREATE PROCEDURE PR_GetTotalSellProperties
AS
BEGIN
    SELECT COUNT(*) AS TotalSellProperties FROM Properties WHERE Category = 'Sell';
END;
GO

CREATE PROCEDURE PR_GetTotalRentProperties
AS
BEGIN
    SELECT COUNT(*) AS TotalRentProperties FROM Properties WHERE Category = 'Rent';
END;
GO

CREATE PROCEDURE PR_GetTotalActiveAgents
AS
BEGIN
    SELECT COUNT(*) AS TotalActiveAgents FROM Agents WHERE Status = 'Active';
END;
GO

CREATE PROCEDURE PR_GetTotalInactiveAgents
AS
BEGIN
    SELECT COUNT(*) AS TotalInactiveAgents FROM Agents WHERE Status = 'Inactive';
END;
GO

CREATE PROCEDURE PR_GetTotalSuspendedAgents
AS
BEGIN
    SELECT COUNT(*) AS TotalSuspendedAgents FROM Agents WHERE Status = 'Suspended';
END;
GO

CREATE PROCEDURE PR_GetTotalPropertiesByType
AS
BEGIN
    SELECT pt.PropertyType, COUNT(p.PropertyId) AS TotalCount
    FROM Properties p
    RIGHT JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId
    GROUP BY pt.PropertyType;
END;
GO

CREATE PROCEDURE PR_Property_Dashboard
AS
BEGIN
    SELECT TOP 10 p.PropertyId, p.Title, p.Description, pt.PropertyType, p.Category, p.Price, p.Location, p.Area,
           p.Bedrooms, p.Bathrooms, p.Amenities, p.ListedDate, p.Status, pi.ImageName, pi.ImagePath
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages pi ON p.PropertyId = pi.PropertyId AND pi.IsPrimary = 1
    WHERE p.Category = 'Sell'
    ORDER BY p.ListedDate DESC;
END;
GO

CREATE PROCEDURE PR_Property_Filter     
    @MinPrice INT = NULL,
    @MaxPrice INT = NULL,
    @Bedrooms INT = NULL,
    @Bathrooms INT = NULL
AS
BEGIN
    SELECT * FROM Properties
    WHERE (@MinPrice IS NULL OR Price >= @MinPrice)
      AND (@MaxPrice IS NULL OR Price <= @MaxPrice)
      AND (@Bedrooms IS NULL OR Bedrooms = @Bedrooms)
      AND (@Bathrooms IS NULL OR Bathrooms = @Bathrooms)
END;
GO

-- ========================================================
-- SAMPLE DATA (10-20 RECORDS EACH TABLE)
-- ========================================================

-- Sample Users
INSERT INTO Users (UserName, Email, Password, Role) VALUES 
('Admin User', 'admin@dreamdwellings.com', 'admin123', 'Admin'),
('John Buyer', 'john.buyer@example.com', 'buyer123', 'Buyer'),
('Jane Seller', 'jane.seller@example.com', 'seller123', 'Seller'),
('Mike User', 'mike.user@example.com', 'user123', 'User'),
('Sarah Buyer', 'sarah.buyer@example.com', 'buyer456', 'Buyer');
GO

-- Sample Agents (6 Records)
INSERT INTO Agents (AgentName, LicenseNumber, ExperienceYears, ContactNumber, OfficeAddress, ProfilePicturePath, Status) VALUES 
('Robert Wilson', 'LIC-001234', 10, '555-0101', '123 Main Street, New York, NY', '/images/agent1.jpg', 'Active'),
('Emily Chen', 'LIC-002345', 8, '555-0102', '456 Oak Avenue, Los Angeles, CA', '/images/agent2.jpg', 'Active'),
('Michael Brown', 'LIC-003456', 15, '555-0103', '789 Pine Road, Chicago, IL', '/images/agent3.jpg', 'Active'),
('Sarah Davis', 'LIC-004567', 5, '555-0104', '321 Maple Lane, Houston, TX', '/images/agent4.jpg', 'Active'),
('David Martinez', 'LIC-005678', 12, '555-0105', '654 Cedar Blvd, Phoenix, AZ', '/images/agent5.jpg', 'Active'),
('Lisa Anderson', 'LIC-006789', 3, '555-0106', '987 Birch Way, Philadelphia, PA', '/images/agent6.jpg', 'Inactive');
GO

-- Sample Properties (10 Records)
INSERT INTO Properties (Title, Description, PropertyTypeId, Category, Price, Location, Area, Bedrooms, Bathrooms, Amenities, Status) VALUES 
('Modern Downtown Apartment', 'Beautiful 2BHK apartment with city views', 2, 'Sell', 250000, 'New York, NY', 1200, 2, 2, 'Gym,Pool,Parking', 'Available'),
('Spacious Family House', '4BHK house in quiet residential area', 1, 'Sell', 550000, 'Los Angeles, CA', 2500, 4, 3, 'Garden,Garage,Pool', 'Available'),
('Cozy Suburban Home', '3BHK perfect for small families', 1, 'Sell', 425000, 'Chicago, IL', 1800, 3, 2, 'Garden,Parking', 'Available'),
('Luxury Penthouse Suite', 'Penthouse with ocean views', 2, 'Rent', 5500, 'Miami, FL', 3000, 3, 3, 'Gym,Pool,Concierge', 'Available'),
('Commercial Office Space', 'Prime location office building', 3, 'Sell', 1200000, 'San Francisco, CA', 5000, 0, 4, 'Parking,Security,Reception', 'Available'),
('Ranch Style Property', 'Wide open land with ranch house', 1, 'Sell', 750000, 'Austin, TX', 10000, 4, 3, 'Pool,Stables,Lake', 'Available'),
('Studio Apartment', 'Affordable studio in downtown', 2, 'Rent', 1200, 'Seattle, WA', 600, 0, 1, 'Gym,Laundry', 'Available'),
('Beachfront Villa', 'Luxury beachfront property', 1, 'Sell', 2500000, 'San Diego, CA', 4500, 5, 4, 'Pool,BeachAccess,SmartHome', 'Available'),
('City Center Office', 'Modern office in business district', 3, 'Rent', 8500, 'Boston, MA', 2500, 0, 2, 'ConferenceRoom,Parking', 'Available'),
('Suburban Townhouse', '3BHK townhouse with garage', 1, 'Sell', 375000, 'Denver, CO', 1650, 3, 2, 'Garage,Garden,ClubHouse', 'Available');
GO

-- Sample Property Images (2-3 per property)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(1, 'apt1-main.jpg', '/images/property/apt1-main.jpg', 1, 1),
(1, 'apt1-living.jpg', '/images/property/apt1-living.jpg', 2, 0),
(2, 'house1-main.jpg', '/images/property/house1-main.jpg', 1, 1),
(2, 'house1-garden.jpg', '/images/property/house1-garden.jpg', 2, 0),
(3, 'house2-main.jpg', '/images/property/house2-main.jpg', 1, 1),
(3, 'house2-front.jpg', '/images/property/house2-front.jpg', 2, 0),
(4, 'penthouse1.jpg', '/images/property/penthouse1.jpg', 1, 1),
(4, 'penthouse2.jpg', '/images/property/penthouse2.jpg', 2, 0),
(5, 'office1-main.jpg', '/images/property/office1-main.jpg', 1, 1),
(5, 'office1-inside.jpg', '/images/property/office1-inside.jpg', 2, 0),
(6, 'ranch1-main.jpg', '/images/property/ranch1-main.jpg', 1, 1),
(6, 'ranch1-land.jpg', '/images/property/ranch1-land.jpg', 2, 0),
(7, 'studio1.jpg', '/images/property/studio1.jpg', 1, 1),
(7, 'studio2.jpg', '/images/property/studio2.jpg', 2, 0),
(8, 'villa1-main.jpg', '/images/property/villa1-main.jpg', 1, 1),
(8, 'villa1-beach.jpg', '/images/property/villa1-beach.jpg', 2, 0),
(9, 'office2-main.jpg', '/images/property/office2-main.jpg', 1, 1),
(9, 'office2-desk.jpg', '/images/property/office2-desk.jpg', 2, 0),
(10, 'townhouse1.jpg', '/images/property/townhouse1.jpg', 1, 1),
(10, 'townhouse2.jpg', '/images/property/townhouse2.jpg', 2, 0);
GO

-- Sample Appointments (5 Records)
INSERT INTO Appointments (UserEmail, AppointmentDate, Status) VALUES 
('john.buyer@example.com', '2026-04-01 10:00:00', 'Pending'),
('sarah.buyer@example.com', '2026-04-02 14:00:00', 'Confirmed'),
('mike.user@example.com', '2026-04-03 11:00:00', 'Pending'),
('john.buyer@example.com', '2026-04-05 09:00:00', 'Confirmed'),
('jane.seller@example.com', '2026-04-06 15:00:00', 'Canceled');
GO

-- Sample Feedback (5 Records)
INSERT INTO Feedback (Name, Email, Message) VALUES 
('John Smith', 'johnsmith@email.com', 'Great properties! Very helpful staff.'),
('Emma Wilson', 'emmawilson@email.com', 'Found my dream home through this platform.'),
('Michael Brown', 'michaelb@email.com', 'Excellent service and quick response.'),
('Sophia Davis', 'sophiad@email.com', 'Loved the property recommendations.'),
('James Johnson', 'jamesj@email.com', 'Will definitely recommend to friends.');
GO

-- ========================================================
-- VERIFY ALL DATA
-- ========================================================
SELECT '=== Users ===' AS Info;
SELECT * FROM Users;

SELECT '=== PropertyTypes ===' AS Info;
SELECT * FROM PropertyTypes;

SELECT '=== Properties (count) ===' AS Info;
SELECT COUNT(*) AS TotalProperties FROM Properties;

SELECT '=== Agents (count) ===' AS Info;
SELECT COUNT(*) AS TotalAgents FROM Agents;

SELECT '=== Appointments ===' AS Info;
SELECT * FROM Appointments;

SELECT '=== Feedback ===' AS Info;
SELECT * FROM Feedback;

PRINT '✅ Database setup completed successfully with all sample data!';
GO