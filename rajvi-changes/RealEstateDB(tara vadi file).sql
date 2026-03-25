-- Create Users Table
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(50) CHECK (Role IN ('Admin', 'Buyer', 'Seller', 'User'))
);

-- Create PropertyTypes Table FIRST (required before Properties)
CREATE TABLE PropertyTypes (
    PropertyTypeId INT PRIMARY KEY IDENTITY(1,1),
    PropertyType VARCHAR(50) UNIQUE NOT NULL
);

-- Create Properties Table (with Foreign Key to PropertyTypes)
CREATE TABLE Properties (
    PropertyId INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(150) NOT NULL,
    Description VARCHAR(MAX),
    PropertyTypeId INT NOT NULL,  -- Foreign Key to PropertyTypes table
    Category VARCHAR(50) CHECK (Category IN ('Buy', 'Rent', 'Sell')),
    Price DECIMAL(18,2) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Area FLOAT NOT NULL,
    Bedrooms INT,
    Bathrooms INT,
    Amenities VARCHAR(MAX),
    ListedDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(50) CHECK (Status IN ('Available', 'Sold', 'Pending')),
    ImageName VARCHAR(255),
    ImagePath VARCHAR(MAX),
    
    CONSTRAINT FK_Property_PropertyType FOREIGN KEY (PropertyTypeId) 
    REFERENCES PropertyTypes (PropertyTypeId) ON DELETE CASCADE
);

-- Create PropertyImages Table (with Foreign Key to Properties)
CREATE TABLE PropertyImages (
    ImageId INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT FOREIGN KEY REFERENCES Properties(PropertyId) ON DELETE CASCADE,
    ImageName VARCHAR(255),
    ImagePath VARCHAR(MAX),
    IsPrimary BIT DEFAULT 0,
    DisplayOrder INT
);

-- Create Agents Table
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

-- Create Appointments Table
CREATE TABLE Appointments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UserEmail NVARCHAR(255),
    AppointmentDate DATETIME,
    Status NVARCHAR(50) DEFAULT 'Pending' 
        CHECK (Status IN ('Pending', 'Confirmed', 'Canceled'))
);

-- Create Feedback Table
CREATE TABLE Feedback (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Feedback (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
);

ALTER TABLE Agents
ADD ProfilePicturePath VARCHAR(MAX);

Delete from PropertyImages

Select * from users

---- Create PropertyImages Table
--CREATE TABLE PropertyImages (
--    ImageId INT PRIMARY KEY IDENTITY(1,1),
--    PropertyId INT FOREIGN KEY REFERENCES Properties(PropertyId) ON DELETE CASCADE,
--    GroupId INT NOT NULL,
--    ImageName VARCHAR(255) NOT NULL,
--    Image VARCHAR(MAX),
--    UploadedDate DATETIME DEFAULT GETDATE()
--);

CREATE TABLE PropertyImages
(
    ImageId INT IDENTITY(1,1) PRIMARY KEY,
    PropertyId INT,
    ImageName VARCHAR(255),
    ImagePath VARCHAR(MAX),
    IsPrimary BIT,
    DisplayOrder INT
);

INSERT INTO Users (UserName, Email, Password, Role)
VALUES 
('Meet Parekh', 'vinodparekh83@gmail.com', 'meet029', 'User'),
('Rajvi Adesara', 'rajzad912@gmail.com', 'rajvi09', 'User')

Select * from Users


INSERT INTO Properties (Title, Description, PropertyType, Category, Price, Location, Area, Bedrooms, Bathrooms, Amenities, Status, ImageName, ImagePath)
VALUES 
('Luxury Apartment', 'Spacious 3 BHK in downtown', 'Apartment', 'Sell', 250000.00, 'Downtown City', 1500.0, 3, 2, 'Gym, Pool, Parking', 'Available','house1.jpg', '/img/house1.jpg'),
('Cozy House', '2 BHK house in the suburbs', 'House', 'Rent', 1500.00, 'Suburb Area', 1200.0, 2, 2, 'Garden, Garage', 'Available','house2.jpg', '/img/house2.jpg'),
('Commercial Office', '5000 sqft office space', 'Commercial', 'Buy', 1000000.00, 'Business District', 5000.0, NULL, NULL, 'Conference Room, Parking', 'Pending','house3.jpg', '/img/house3.jpg'),
('Modern Villa', '4 BHK villa with a swimming pool', 'House', 'Sell', 500000.00, 'Luxury Area', 3000.0, 4, 3, 'Swimming Pool, Garage', 'Available', 'house4.jpg', '/img/house4.jpg'),
('Penthouse Apartment', 'Luxury penthouse with a great view', 'Apartment', 'Sell', 750000.00, 'Uptown City', 2000.0, 3, 3, 'Roof Garden, Pool', 'Available', 'house5.jpg', '/img/house5.jpg'),
('Country House', 'Cozy 3 BHK house in the countryside', 'House', 'Rent', 2500.00, 'Countryside Area', 1800.0, 3, 2, 'Garden, Fireplace', 'Available', 'house6.jpg', '/img/house6.jpg'),
('Retail Space', '1000 sqft retail space in city center', 'Commercial', 'Rent', 1000.00, 'City Center', 1000.0, NULL, NULL, 'Parking, Security', 'Available', 'house7.jpg', '/img/house7.jpg'),
('Beach House', '5 BHK luxury house near the beach', 'House', 'Sell', 850000.00, 'Beach Area', 4000.0, 5, 4, 'Private Beach, Pool', 'Available', 'house8.jpg', '/img/house8.jpg'),
('Studio Apartment', 'Affordable studio apartment', 'Apartment', 'Rent', 800.00, 'Downtown City', 500.0, 1, 1, 'Security, Parking', 'Available', 'house9.jpg', '/img/house9.jpg');


INSERT INTO Properties 
(Title, Description, PropertyTypeId, Category, Price, Location, Area, Bedrooms, Bathrooms, Amenities, Status, ImageName, ImagePath)
VALUES 
('Luxury Apartment', 'Spacious 3 BHK in downtown', 1, 'Sell', 250000.00, 'Downtown City', 1500.0, 3, 2, 'Gym, Pool, Parking', 'Available','house1.jpg', '/img/house1.jpg'),
('Cozy House', '2 BHK house in the suburbs', 2, 'Rent', 1500.00, 'Suburb Area', 1200.0, 2, 2, 'Garden, Garage', 'Available','house2.jpg', '/img/house2.jpg'),
('Commercial Office', '5000 sqft office space', 3, 'Buy', 1000000.00, 'Business District', 5000.0, NULL, NULL, 'Conference Room, Parking', 'Pending','house3.jpg', '/img/house3.jpg'),
('Modern Villa', '4 BHK villa with a swimming pool', 2, 'Sell', 500000.00, 'Luxury Area', 3000.0, 4, 3, 'Swimming Pool, Garage', 'Available', 'house4.jpg', '/img/house4.jpg'),
('Penthouse Apartment', 'Luxury penthouse with a great view', 1, 'Sell', 750000.00, 'Uptown City', 2000.0, 3, 3, 'Roof Garden, Pool', 'Available', 'house5.jpg', '/img/house5.jpg'),
('Country House', 'Cozy 3 BHK house in the countryside', 2, 'Rent', 2500.00, 'Countryside Area', 1800.0, 3, 2, 'Garden, Fireplace', 'Available', 'house6.jpg', '/img/house6.jpg'),
('Retail Space', '1000 sqft retail space in city center', 3, 'Rent', 1000.00, 'City Center', 1000.0, NULL, NULL, 'Parking, Security', 'Available', 'house7.jpg', '/img/house7.jpg'),
('Beach House', '5 BHK luxury house near the beach', 2, 'Sell', 850000.00, 'Beach Area', 4000.0, 5, 4, 'Private Beach, Pool', 'Available', 'house8.jpg', '/img/house8.jpg'),
('Studio Apartment', 'Affordable studio apartment', 1, 'Rent', 800.00, 'Downtown City', 500.0, 1, 1, 'Security, Parking', 'Available', 'house9.jpg', '/img/house9.jpg');


INSERT INTO PropertyTypes (PropertyType) VALUES 
('Apartment'),
('House'),
('Commercial');

INSERT INTO Feedback (Name, Email, Message) VALUES
('John Doe', 'john.doe@example.com', 'Great service! I really appreciate the support.'),
('Jane Smith', 'jane.smith@example.com', 'The website is user-friendly, but I would love to see more features.'),
('Michael Johnson', 'michael.j@example.com', 'Had an issue with login, but customer service resolved it quickly.'),
('Emily Davis', 'emily.davis@example.com', 'Excellent platform! I would highly recommend it.'),
('Robert Brown', 'robert.brown@example.com', 'Good experience overall, but response time could be improved.');

Delete from PropertyImages

INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, IsPrimary, DisplayOrder) VALUES
-- Property 1
(1,'house.jpg','/img/house1.jpg',1,1),
(1,'hall.jpg','/img/hall1.jpg',0,2),
(1,'kitchen.jpg','/img/kitchen1.jpg',0,3),
(1,'bedroom.jpg','/img/bedroom1.jpg',0,4),

-- Property 2
(2,'house2.jpg','/img/house2.jpg',1,1),
(2,'hall2.jpg','/img/hall2.jpg',0,2),
(2,'kitchen2.jpg','/img/kitchen2.jpg',0,3),
(2,'bedroom2.jpg','/img/bedroom2.jpg',0,4),

-- Property 3
(3,'house3.jpg','/img/house3.jpg',1,1),
(3,'hall3.jpg','/img/hall3.jpg',0,2),
(3,'kitchen3.jpg','/img/kitchen3.jpg',0,3),
(3,'bedroom3.jpg','/img/bedroom3.jpg',0,4),

-- Property 4
(4,'house4.jpg','/img/house4.jpg',1,1),
(4,'hall4.jpg','/img/hall4.jpg',0,2),
(4,'kitchen4.jpg','/img/kitchen4.jpg',0,3),
(4,'bedroom4.jpg','/img/bedroom4.jpg',0,4),

-- Property 5
(5,'house5.jpg','/img/house5.jpg',1,1),
(5,'hall5.jpg','/img/hall5.jpg',0,2),
(5,'kitchen5.jpg','/img/kitchen5.jpg',0,3),
(5,'bedroom5.jpg','/img/bedroom5.jpg',0,4),

-- Property 6
(6,'house6.jpg','/img/house6.jpg',1,1),
(6,'hall6.jpg','/img/hall6.jpg',0,2),
(6,'kitchen6.jpg','/img/kitchen6.jpg',0,3),
(6,'bedroom6.jpg','/img/bedroom6.jpg',0,4);



INSERT INTO Agents (AgentName, LicenseNumber, ExperienceYears, ContactNumber, OfficeAddress, ProfilePicture, ProfilePicturePath, Status)
VALUES
('John Doe', 'LIC123456', 10, '9876543210', '123 Main St, New York, NY', 'agent1.jpg', '/img/agent1.jpg', 'Active'),
('Alice Smith', 'LIC789012', 5, '9876543211', '456 Elm St, Los Angeles, CA', 'agent2.jpg', '/img/agent2.jpg', 'Active'),
('Michael Johnson', 'LIC345678', 7, '9876543212', '789 Oak St, Chicago, IL', 'agent3.jpg', '/img/agent3.jpg', 'Inactive'),
('Emily Davis', 'LIC901234', 12, '9876543213', '101 Pine St, Houston, TX', 'agent4.jpg', '/img/agent4.jpg', 'Active'),
('David Brown', 'LIC567890', 3, '9876543214', '202 Cedar St, Phoenix, AZ', 'agent5.jpg', '/img/agent5.jpg', 'Suspended')

Delete from Agents
where AgentId = 17

Select * from Agents

Drop table Appointments

-------------------------- FEEDBACK SP -------------------------

--1.
CREATE OR ALTER PROCEDURE PR_Feedback_SelectAll
AS
BEGIN
    SELECT 
        Id,
        Name,
        Email,
        Message
    FROM Feedback
    ORDER BY Id DESC
END


--2.
CREATE PROCEDURE PR_Feedback_Insert
    @Name NVARCHAR(100),
    @Email NVARCHAR(255),
    @Message NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Feedback (Name, Email, Message)
    VALUES (@Name, @Email, @Message)
END



----------------------------------- APPOINTMENT SP ------------------------------

--1.
CREATE PROCEDURE PR_Appointment_SelectAll
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT Id, UserEmail, AppointmentDate, Status
    FROM Appointments;
END;

--2.
CREATE or ALTER PROCEDURE PR_Appointment_UpdateStatus
    @Id INT,
    @Status NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE Appointments
    SET Status = @Status
    WHERE Id = @Id;
END;

EXEC PR_Appointment_UpdateStatus @Id = 1, @Status = 'Approved';

--3.
CREATE PROCEDURE PR_Appointment_Insert
    @UserEmail NVARCHAR(255),
    @AppointmentDate DATETIME,
    @Status NVARCHAR(50)
AS
BEGIN
    INSERT INTO Appointments (UserEmail, AppointmentDate, Status)
    VALUES (@UserEmail, @AppointmentDate, @Status);
END;



--------------------------------------- USER SP ------------------------------------------

--1.
CREATE or ALTER PROCEDURE PR_User_SelectAll
AS
BEGIN
    SELECT 
        UserId,
        UserName,
        Email,
        Password,
        Role
    FROM Users
END

--2.
CREATE or ALTER PROCEDURE PR_User_SelectByPK 
    @UserId INT
AS
BEGIN
    SELECT 
        UserId,
        UserName,
        Email,
        Password,
        Role
    FROM Users
    WHERE UserId = @UserId
END

--3.
CREATE or ALTER PROCEDURE PR_User_Insert
    @UserName VARCHAR(100),
    @Email VARCHAR(100),
    @Password VARCHAR(255),
    @Role VARCHAR(50)
AS
BEGIN
    INSERT INTO Users (UserName, Email, Password, Role)
    VALUES (@UserName, @Email, @Password, @Role)
END

--4.
CREATE PROCEDURE PR_User_Update
    @UserId INT,
    @UserName VARCHAR(100),
    @Email VARCHAR(100),
    @Password VARCHAR(255),
    @Role VARCHAR(50)
AS
BEGIN
    UPDATE Users
    SET 
        UserName = @UserName,
        Email = @Email,
        Password = @Password,
        Role = @Role
    WHERE UserId = @UserId
END

--5.
CREATE PROCEDURE PR_User_Delete
    @UserId INT
AS
BEGIN
    DELETE FROM Users
    WHERE UserId = @UserId
END


----------------------------------------------------------------- PROPERTY SP --------------------------------------------------------

--1.
CREATE OR ALTER PROCEDURE PR_Property_SelectAll
AS
BEGIN
    SELECT 
        PropertyId,
        Title,
        Description,
        pt.PropertyType AS PropertyType,  -- Join PropertyTypes table for PropertyType
        Category,
        Price,
        Location,
        Area,
        Bedrooms,
        Bathrooms,
        Amenities,
        ListedDate,
        Status,
        ImageName,
        ImagePath
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId  -- Join with PropertyTypes table
    ORDER BY ListedDate DESC
END

--2.
CREATE OR ALTER PROCEDURE PR_Property_SelectByPK
    @PropertyId INT
AS
BEGIN
    SELECT 
        p.PropertyId,
        p.Title,
        p.Description,
        pt.PropertyType AS PropertyType,
        p.PropertyTypeId,
        p.Category,
        p.Price,
        p.Location,
        p.Area,
        p.Bedrooms,
        p.Bathrooms,
        p.Amenities,
        p.ListedDate,
        p.Status,
        i.ImageId,
        i.ImageName,
        i.ImagePath,
        i.IsPrimary,
        i.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt 
        ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages i 
        ON p.PropertyId = i.PropertyId
    WHERE p.PropertyId = @PropertyId
    ORDER BY i.DisplayOrder;
END

--3.
CREATE OR ALTER PROCEDURE PR_Property_Insert
    @Title VARCHAR(150),
    @Description VARCHAR(MAX),
    @PropertyTypeId INT, 
    @Category VARCHAR(50),
    @Price DECIMAL(18, 2),
    @Location VARCHAR(255),
    @Area FLOAT,
    @Bedrooms INT,
    @Bathrooms INT,
    @Amenities VARCHAR(MAX),
    @Status VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Properties
    (
        Title,
        Description,
        PropertyTypeId,
        Category,
        Price,
        Location,
        Area,
        Bedrooms,
        Bathrooms,
        Amenities,
        ListedDate,
        Status
    )
    VALUES
    (
        @Title,
        @Description,
        @PropertyTypeId,
        @Category,
        @Price,
        @Location,
        @Area,
        @Bedrooms,
        @Bathrooms,
        @Amenities,
        GETDATE(),
        @Status
    );
	    SELECT SCOPE_IDENTITY();
END


--4.
CREATE OR ALTER PROCEDURE PR_PropertyImage_Insert
(
    @PropertyId INT,
    @ImageName VARCHAR(255),
    @ImagePath VARCHAR(MAX),
    @DisplayOrder INT,
    @IsPrimary BIT = 0
)
AS
BEGIN
    INSERT INTO PropertyImages
    (
        PropertyId,
        ImageName,
        ImagePath,
        DisplayOrder,
        IsPrimary
    )
    VALUES
    (
        @PropertyId,
        @ImageName,
        @ImagePath,
        @DisplayOrder,
        @IsPrimary
    );
END


Select * from PropertyImages
Select * from Properties

--5.
CREATE or ALTER PROCEDURE PR_Property_Update
    @PropertyId INT,
    @Title VARCHAR(150),
    @Description VARCHAR(MAX),
    @PropertyTypeId INT,
    @Category VARCHAR(50),
    @Price DECIMAL(18, 2),
    @Location VARCHAR(255),
    @Area FLOAT,
    @Bedrooms INT,
    @Bathrooms INT,
    @Amenities VARCHAR(MAX),
    @Status VARCHAR(50),
    @ImageName VARCHAR(255),
    @ImagePath VARCHAR(MAX)
AS
BEGIN
    UPDATE Properties
    SET 
        Title = @Title,
        Description = @Description,
        PropertyTypeId = @PropertyTypeId,  -- Use PropertyTypeId here
        Category = @Category,
        Price = @Price,
        Location = @Location,
        Area = @Area,
        Bedrooms = @Bedrooms,
        Bathrooms = @Bathrooms,
        Amenities = @Amenities,
        Status = @Status,
        ImageName = @ImageName,
        ImagePath = @ImagePath
    WHERE PropertyId = @PropertyId
END

--6.
CREATE PROCEDURE PR_Property_Delete
    @PropertyId INT
AS
BEGIN
    DELETE FROM Properties
    WHERE PropertyId = @PropertyId
END

------------------------------------------ PROPERTY TYPE -----------------------------------------

--1.
CREATE or ALTER PROCEDURE PR_PropertyType_SelectAll
AS
BEGIN
    SELECT DISTINCT PropertyTypeId, PropertyType FROM PropertyTypes;
END;

Select * from propertytypes

--2.
CREATE or ALTER PROCEDURE PR_PropertyType_SelectByPK
    @PropertyTypeId INT
AS
BEGIN
    SELECT PropertyTypeId,PropertyType 
    FROM PropertyTypes
    WHERE PropertyTypeId = @PropertyTypeId;
END;


CREATE OR ALTER PROCEDURE PR_Property_SelectByType
    @PropertyType VARCHAR(50)
AS
BEGIN
    SELECT
        p.PropertyId,
        p.Title,
		p.ListedDate,
        p.Description,
        p.PropertyTypeId,
        pt.PropertyType,
        p.Category,
        p.Price,
        p.Location,
        p.Area,
        p.Bedrooms,
        p.Bathrooms,
        p.Amenities,
        p.Status,
        i.ImageId,
        i.ImageName,
        i.ImagePath,
        i.DisplayOrder,
        i.IsPrimary
    FROM Properties p
    JOIN PropertyTypes pt
        ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages i
        ON p.PropertyId = i.PropertyId
    WHERE LOWER(pt.PropertyType) = LOWER(@PropertyType)
    ORDER BY p.PropertyId, i.DisplayOrder
END


CREATE OR ALTER PROCEDURE PR_Property_SelectByCategoryAndType
    @Category VARCHAR(50),
    @PropertyType VARCHAR(50)
AS
BEGIN
    SELECT
        p.PropertyId,
        p.Title,
        p.Category,
        p.Price,
        p.Location,
        p.Area,
        p.Bedrooms,
        p.Bathrooms,
        pt.PropertyType,
        i.ImageId,
        i.ImagePath,
        i.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt
        ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages i
        ON p.PropertyId = i.PropertyId
    WHERE
        LOWER(p.Category) = LOWER(@Category)
        AND LOWER(pt.PropertyType) = LOWER(@PropertyType)
    ORDER BY p.PropertyId, i.DisplayOrder
END



--3.
CREATE PROCEDURE PR_PropertyType_Insert
    @PropertyType VARCHAR(50)
AS
BEGIN
    INSERT INTO PropertyType(PropertyType)
    VALUES (@PropertyType)
END


--4.
CREATE or ALTER PROCEDURE PR_PropertyType_Update 
    @PropertyTypeId INT,
    @PropertyType VARCHAR(50)
AS
BEGIN
    UPDATE PropertyTypes
    SET PropertyType = @PropertyType
    WHERE PropertyTypeId = @PropertyTypeId;
END;


--5.
CREATE or ALTER PROCEDURE PR_PropertyType_Delete
    @PropertyTypeId INT
AS
BEGIN
    DELETE FROM PropertyTypes
    WHERE PropertyTypeId = @PropertyTypeId;
END;

-------------------------------------------------------- SELL / RENT ---------------------------------------------------

--1.
CREATE or ALTER PROCEDURE PR_GetPropertiesForCategory
    @Category NVARCHAR(50)
AS
BEGIN
    SELECT 
        p.PropertyId,
        p.Title,
        p.Description,
		pt.PropertyTypeId,
        pt.PropertyType,
        p.Category,
        p.Price,
        p.Location,
        p.Area,
        p.Bedrooms,
        p.Bathrooms,
        p.Amenities,
        p.ListedDate,
        p.Status,
        i.ImageId,
        i.ImageName,
        i.ImagePath,
        i.IsPrimary,
        i.DisplayOrder
    FROM Properties p
    JOIN PropertyTypes pt 
        ON p.PropertyTypeId = pt.PropertyTypeId
    LEFT JOIN PropertyImages i 
        ON p.PropertyId = i.PropertyId
    WHERE p.Category = @Category
    ORDER BY i.DisplayOrder;
END

Select * from properties

Exec PR_GetPropertiesForCategory @category = 'rent'

--2.
CREATE or ALTER PROCEDURE PR_GetPropertiesByType 
    @PropertyType NVARCHAR(50)
AS
BEGIN
    SELECT 
        PropertyId,
        Title,
        Description,
        pt.PropertyType,
        Category,
        Price,
        Location,
        Area,
        Bedrooms,
        Bathrooms,
        Amenities,
        ListedDate,
        Status,
        ImageName,
        ImagePath
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId  -- Join with PropertyTypes table
    WHERE PropertyType = @PropertyType
    ORDER BY 
        ListedDate DESC; -- Order by the most recently listed properties
END

--3.
CREATE OR ALTER PROCEDURE PR_GetPropertiesByTypeAndCategory
    @PropertyType NVARCHAR(50),
    @Category NVARCHAR(50) = NULL  -- Optional parameter for filtering by category
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        PropertyId,
        Title,
        Description,
        pt.PropertyType,
        Category,
        Price,
        Location,
        Area,
        Bedrooms,
        Bathrooms,
        Amenities,
        ListedDate,
        Status,
        ImageName,
        ImagePath
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId  -- Join with PropertyTypes table
    WHERE 
        pt.PropertyType = @PropertyType
        AND (@Category IS NULL OR Category = @Category)  -- Apply category filter if provided
    ORDER BY 
        ListedDate DESC; -- Order by the most recently listed properties
END;

EXEC PR_GetPropertiesByTypeAndCategory @PropertyType = 'Apartment', @Category = 'Sell';


--------------------------------------------------------- AGENT SP -------------------------------------------------------
--1.
CREATE OR ALTER PROCEDURE PR_Agent_SelectAll
AS
BEGIN
    SELECT 
        AgentId,
        AgentName,
        LicenseNumber,
        ExperienceYears,
        ContactNumber,
        OfficeAddress,
        ProfilePicture,
        ProfilePicturePath,
        Status
    FROM Agents
END


-- 2. 
CREATE OR ALTER PROCEDURE PR_Agent_SelectByPK 
    @AgentId INT
AS
BEGIN
    SELECT 
        AgentId,
        AgentName,
        LicenseNumber,
        ExperienceYears,
        ContactNumber,
        OfficeAddress,
        ProfilePicture,
        ProfilePicturePath,
        Status
    FROM Agents
    WHERE AgentId = @AgentId
END


-- 3.
CREATE OR ALTER PROCEDURE PR_Agent_Insert
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
    VALUES (@AgentName, @LicenseNumber, @ExperienceYears, @ContactNumber, @OfficeAddress, @ProfilePicture, @ProfilePicturePath, @Status)
END

 


-- 4.
CREATE OR ALTER PROCEDURE PR_Agent_Update
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
    SET 
        AgentName = @AgentName,
        LicenseNumber = @LicenseNumber,
        ExperienceYears = @ExperienceYears,
        ContactNumber = @ContactNumber,
        OfficeAddress = @OfficeAddress,
        ProfilePicture = @ProfilePicture,
        ProfilePicturePath = @ProfilePicturePath,
        Status = @Status
    WHERE AgentId = @AgentId
END


--5.
CREATE OR ALTER PROCEDURE PR_Agent_Delete
    @AgentId INT
AS
BEGIN
    DELETE FROM Agents
    WHERE AgentId = @AgentId
END


----------------------------------------------------------- ADMIN -------------------------------------------------------

--1.
CREATE OR ALTER PROCEDURE PR_GetTotalUsers
AS
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM Users) AS TotalUsers
END;

--2.
CREATE OR ALTER PROCEDURE PR_GetTotalProperties
AS
BEGIN 
	SELECT
		(SELECT COUNT(*) FROM Properties) AS TotalProperties
END;

--3.
CREATE OR ALTER PROCEDURE PR_GetTotalAgents
AS
BEGIN 
	SELECT
		(SELECT COUNT(*) FROM Agents) AS TotalAgents
END;

--4.
CREATE PROCEDURE PR_GetTotalBuyProperties
AS
BEGIN    
    SELECT COUNT(*) AS TotalBuyProperties 
    FROM Properties 
    WHERE Category = 'Buy'
END;

--5.
CREATE or ALTER PROCEDURE PR_GetTotalSellProperties
AS
BEGIN    
    SELECT COUNT(*) AS TotalSellProperties 
    FROM Properties 
    WHERE Category = 'Sell'
END;

--6.
CREATE PROCEDURE PR_GetTotalRentProperties
AS
BEGIN    
    SELECT COUNT(*) AS TotalRentProperties 
    FROM Properties 
    WHERE Category = 'Rent'
END;

--7.
CREATE OR ALTER PROCEDURE PR_GetTotalActiveAgents
AS
BEGIN    
    SELECT COUNT(*) AS TotalActiveAgents 
    FROM Agents 
    WHERE Status = 'Active'
END;

-- 8.
CREATE OR ALTER PROCEDURE PR_GetTotalInactiveAgents
AS
BEGIN    
    SELECT COUNT(*) AS TotalInactiveAgents 
    FROM Agents 
    WHERE Status = 'Inactive'
END;

--9.
CREATE OR ALTER PROCEDURE PR_GetTotalSuspendedAgents
AS
BEGIN    
    SELECT COUNT(*) AS TotalSuspendedAgents 
    FROM Agents 
    WHERE Status = 'Suspended'
END;


--10.
CREATE OR ALTER PROCEDURE PR_Property_Dashboard
AS
BEGIN
    SELECT TOP 10
        PropertyId,
        Title,
        Description,
        pt.PropertyType AS PropertyType,  -- Join PropertyTypes table for PropertyType
        Category,
        Price,
        Location,
        Area,
        Bedrooms,
        Bathrooms,
        Amenities,
        ListedDate,
        Status,
        ImageName,
        ImagePath
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId 
	where p.category = 'Sell' 
	ORDER BY ListedDate DESC
END

--11.
CREATE OR ALTER PROCEDURE PR_GetTotalPropertiesByType
AS
BEGIN
    SELECT 
        pt.PropertyType, 
        COUNT(*) AS TotalCount
    FROM Properties p
    JOIN PropertyTypes pt ON p.PropertyTypeId = pt.PropertyTypeId 
    GROUP BY pt.PropertyType
END;

------------------------------------------------ AUTHENTICATION ------------------------------------

--1.
CREATE or Alter PROCEDURE [dbo].[PR_User_Login] 
    @Email NVARCHAR(50),
    @Password NVARCHAR(50)
AS
BEGIN
    SELECT 
        [dbo].[Users].[UserID], 
        [dbo].[Users].[UserName], 
        [dbo].[Users].[Email], 
        [dbo].[Users].[Password],
        [dbo].[Users].[Role]
    FROM 
        [dbo].[Users] 
    WHERE 
        [dbo].[Users].[Email] = @Email 
        AND [dbo].[Users].[Password] = @Password;
END

EXEC PR_User_Login @Email = 'john.doe@example.com', @Password = 'hashedpassword1'


select * from users


--1.
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
END
GO

-- ========================================================
-- SAMPLE DATA - USERS (5 Records)
-- ========================================================
INSERT INTO Users (UserName, Email, Password, Role) VALUES 
('Admin User', 'admin@dreamdwellings.com', 'admin123', 'Admin'),
('John Buyer', 'john.buyer@example.com', 'buyer123', 'Buyer'),
('Jane Seller', 'jane.seller@example.com', 'seller123', 'Seller'),
('Mike User', 'mike.user@example.com', 'user123', 'User'),
('Sarah Buyer', 'sarah.buyer@example.com', 'buyer456', 'Buyer');
GO

-- ========================================================
-- SAMPLE DATA - AGENTS (6 Records)
-- ========================================================
INSERT INTO Agents (AgentName, LicenseNumber, ExperienceYears, ContactNumber, OfficeAddress, ProfilePicturePath, Status) VALUES 
('Robert Wilson', 'LIC-001234', 10, '555-0101', '123 Main Street, New York, NY', '/images/agent1.jpg', 'Active'),
('Emily Chen', 'LIC-002345', 8, '555-0102', '456 Oak Avenue, Los Angeles, CA', '/images/agent2.jpg', 'Active'),
('Michael Brown', 'LIC-003456', 15, '555-0103', '789 Pine Road, Chicago, IL', '/images/agent3.jpg', 'Active'),
('Sarah Davis', 'LIC-004567', 5, '555-0104', '321 Maple Lane, Houston, TX', '/images/agent4.jpg', 'Active'),
('David Martinez', 'LIC-005678', 12, '555-0105', '654 Cedar Blvd, Phoenix, AZ', '/images/agent5.jpg', 'Active'),
('Lisa Anderson', 'LIC-006789', 3, '555-0106', '987 Birch Way, Philadelphia, PA', '/images/agent6.jpg', 'Inactive');
GO

-- ========================================================
-- SAMPLE DATA - PROPERTIES (10 Records)
-- ========================================================
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

-- ========================================================
-- SAMPLE DATA - PROPERTY IMAGES (2-3 per property)
-- ========================================================
-- Property 1 (Downtown Apartment)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(1, 'apt1-main.jpg', '/images/property/apt1-main.jpg', 1, 1),
(1, 'apt1-living.jpg', '/images/property/apt1-living.jpg', 2, 0),
(1, 'apt1-bedroom.jpg', '/images/property/apt1-bedroom.jpg', 3, 0);
GO

-- Property 2 (Family House)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(2, 'house1-main.jpg', '/images/property/house1-main.jpg', 1, 1),
(2, 'house1-garden.jpg', '/images/property/house1-garden.jpg', 2, 0),
(2, 'house1-kitchen.jpg', '/images/property/house1-kitchen.jpg', 3, 0);
GO

-- Property 3 (Suburban Home)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(3, 'house2-main.jpg', '/images/property/house2-main.jpg', 1, 1),
(3, 'house2-front.jpg', '/images/property/house2-front.jpg', 2, 0),
(3, 'house2-backyard.jpg', '/images/property/house2-backyard.jpg', 3, 0);
GO

-- Property 4 (Penthouse)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(4, 'penthouse1.jpg', '/images/property/penthouse1.jpg', 1, 1),
(4, 'penthouse2.jpg', '/images/property/penthouse2.jpg', 2, 0),
(4, 'penthouse3.jpg', '/images/property/penthouse3.jpg', 3, 0);
GO

-- Property 5 (Commercial Office)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(5, 'office1-main.jpg', '/images/property/office1-main.jpg', 1, 1),
(5, 'office1-inside.jpg', '/images/property/office1-inside.jpg', 2, 0);
GO

-- Property 6 (Ranch)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(6, 'ranch1-main.jpg', '/images/property/ranch1-main.jpg', 1, 1),
(6, 'ranch1-land.jpg', '/images/property/ranch1-land.jpg', 2, 0),
(6, 'ranch1-house.jpg', '/images/property/ranch1-house.jpg', 3, 0);
GO

-- Property 7 (Studio)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(7, 'studio1.jpg', '/images/property/studio1.jpg', 1, 1),
(7, 'studio2.jpg', '/images/property/studio2.jpg', 2, 0);
GO

-- Property 8 (Beachfront Villa)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(8, 'villa1-main.jpg', '/images/property/villa1-main.jpg', 1, 1),
(8, 'villa1-beach.jpg', '/images/property/villa1-beach.jpg', 2, 0),
(8, 'villa1-pool.jpg', '/images/property/villa1-pool.jpg', 3, 0);
GO

-- Property 9 (City Office)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(9, 'office2-main.jpg', '/images/property/office2-main.jpg', 1, 1),
(9, 'office2-desk.jpg', '/images/property/office2-desk.jpg', 2, 0);
GO

-- Property 10 (Townhouse)
INSERT INTO PropertyImages (PropertyId, ImageName, ImagePath, DisplayOrder, IsPrimary) VALUES 
(10, 'townhouse1.jpg', '/images/property/townhouse1.jpg', 1, 1),
(10, 'townhouse2.jpg', '/images/property/townhouse2.jpg', 2, 0),
(10, 'townhouse3.jpg', '/images/property/townhouse3.jpg', 3, 0);
GO

-- ========================================================
-- SAMPLE DATA - APPOINTMENTS (5 Records)
-- ========================================================
INSERT INTO Appointments (UserEmail, AppointmentDate, Status) VALUES 
('john.buyer@example.com', '2026-04-01 10:00:00', 'Pending'),
('sarah.buyer@example.com', '2026-04-02 14:00:00', 'Confirmed'),
('mike.user@example.com', '2026-04-03 11:00:00', 'Pending'),
('john.buyer@example.com', '2026-04-05 09:00:00', 'Confirmed'),
('jane.seller@example.com', '2026-04-06 15:00:00', 'Canceled');
GO

-- ========================================================
-- SAMPLE DATA - FEEDBACK (5 Records)
-- ========================================================
INSERT INTO Feedback (Name, Email, Message) VALUES 
('John Smith', 'johnsmith@email.com', 'Great properties! Very helpful staff.'),
('Emma Wilson', 'emmawilson@email.com', 'Found my dream home through this platform.'),
('Michael Brown', 'michaelb@email.com', 'Excellent service and quick response.'),
('Sophia Davis', 'sophiad@email.com', ' Loved the property recommendations.'),
('James Johnson', 'jamesj@email.com', ' Will definitely recommend to friends.');
GO

-- ========================================================
-- VERIFY ALL DATA
-- ========================================================
SELECT '=== Users ===' AS Info;
SELECT * FROM Users;

SELECT '=== PropertyTypes ===' AS Info;
SELECT * FROM PropertyTypes;

SELECT '=== Agents ===' AS Info;
SELECT AgentName, ContactNumber, Status FROM Agents;

SELECT '=== Properties ===' AS Info;
SELECT Title, Price, Location, Category, Status FROM Properties;

SELECT '=== PropertyImages (count per property) ===' AS Info;
SELECT PropertyId, COUNT(*) AS ImageCount FROM PropertyImages GROUP BY PropertyId;

SELECT '=== Appointments ===' AS Info;
SELECT * FROM Appointments;

SELECT '=== Feedback ===' AS Info;
SELECT * FROM Feedback;

PRINT '✅ All sample data inserted successfully!';
GO
