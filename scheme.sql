CREATE DATABASE MixedDB;
USE MixedDB;

-- TODO: USERS & PHONES (Task 1, 2)
CREATE TABLE Users
(
   UserId   INT IDENTITY PRIMARY KEY,
   FullName NVARCHAR(100) NOT NULL
);

CREATE TABLE UserPhones
(
   PhoneId     INT IDENTITY PRIMARY KEY,
   UserId      INT NOT NULL,
   PhoneNumber VARCHAR(50),
   Operator    VARCHAR(20),
   FOREIGN KEY (UserId) REFERENCES Users (UserId)
);

-- TODO: STUDENTS & LESSON RECORDS (Task 3)
CREATE TABLE Students
(
   StudentId INT IDENTITY PRIMARY KEY,
   FullName  NVARCHAR(100)
);

CREATE TABLE LessonRecords
(
   RecordId  INT IDENTITY PRIMARY KEY,
   StudentId INT NOT NULL,
   LessonId  INT NOT NULL,
   Note      NVARCHAR(500),
   CreatedAt DATETIME DEFAULT GETDATE(),
   FOREIGN KEY (StudentId) REFERENCES Students (StudentId)
);

-- TODO: PRODUCTS & SALES & EMPLOYEES (Task 4,5,6,8)
CREATE TABLE Employees
(
   EmployeeId        INT IDENTITY PRIMARY KEY,
   FullName          NVARCHAR(100),
   Salary            DECIMAL(10, 2),
   MotivationBonus   DECIMAL(10, 2) DEFAULT 0,
   ContractStartDate DATE,
   ContractEndDate   DATE
);

CREATE TABLE Products
(
   ProductId   INT IDENTITY PRIMARY KEY,
   ProductName NVARCHAR(100),
   Quantity    INT NOT NULL,
   UnitPrice   DECIMAL(10, 2),
   ExpiryDate  DATE,
   IsActive    BIT DEFAULT 1
);

CREATE TABLE Sales
(
   SaleId     INT IDENTITY PRIMARY KEY,
   ProductId  INT NOT NULL,
   Quantity   INT NOT NULL,
   UnitPrice  DECIMAL(10, 2),
   EmployeeId INT NOT NULL,
   SaleDate   DATETIME DEFAULT GETDATE(),
   FOREIGN KEY (ProductId) REFERENCES Products (ProductId),
   FOREIGN KEY (EmployeeId) REFERENCES Employees (EmployeeId)
);

CREATE TABLE ExampleTable
(
   Id        INT IDENTITY (1,1) PRIMARY KEY,
   ColA      NVARCHAR(255)  NOT NULL,
   ColB      INT            NULL,
   ColC      DECIMAL(10, 2) NULL,
   CreatedAt DATETIME2      NOT NULL DEFAULT SYSDATETIME()
);

