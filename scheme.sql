CREATE DATABASE ComputerStore;

USE ComputerStore;

CREATE TABLE Categories
(
   Id           INT PRIMARY KEY IDENTITY,
   CategoryName NVARCHAR(100)
);

CREATE TABLE Products
(
   Id          INT PRIMARY KEY IDENTITY,
   ProductName NVARCHAR(200),
   Brand       NVARCHAR(100),
   Model       NVARCHAR(100),
   Price       DECIMAL(10, 2),
   CategoryId  INT REFERENCES Categories (Id)
);

CREATE TABLE Employees
(
   Id         INT PRIMARY KEY IDENTITY,
   FirstName  NVARCHAR(100),
   LastName   NVARCHAR(100),
   FatherName NVARCHAR(100),
   BirthDate  DATE,
   Salary     DECIMAL(10, 2)
);

CREATE TABLE Branches
(
   Id         INT PRIMARY KEY IDENTITY,
   BranchName NVARCHAR(100)
);

CREATE TABLE Sales
(
   Id         INT PRIMARY KEY IDENTITY,
   ProductId  INT REFERENCES Products (Id),
   EmployeeId INT REFERENCES Employees (Id),
   BranchId   INT REFERENCES Branches (Id),
   Quantity   INT,
   SaleDate   DATE
);

