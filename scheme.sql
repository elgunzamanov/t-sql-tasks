-- TODO: Create Database
CREATE DATABASE EcommerceDB;

-- TODO: Use the Database
USE EcommerceDB;

-- TODO: Customers
CREATE TABLE Customers
(
   Id    INT IDENTITY (1,1) PRIMARY KEY,
   Name  NVARCHAR(100) NOT NULL,
   Email VARCHAR(150) UNIQUE,
   Phone VARCHAR(20)
);

-- TODO: Categories
CREATE TABLE Categories
(
   Id          INT IDENTITY (1,1) PRIMARY KEY,
   Name        NVARCHAR(150) NOT NULL,
   Description NVARCHAR(MAX)
);

-- TODO: Products
CREATE TABLE Products
(
   Id          INT IDENTITY (1,1) PRIMARY KEY,
   Name        NVARCHAR(150)  NOT NULL,
   Description NVARCHAR(MAX),
   Price       DECIMAL(10, 2) NOT NULL,
   CategoryId  INT            NULL,

   CONSTRAINT FK_Products_Categories
      FOREIGN KEY (CategoryId) REFERENCES Categories (Id)
);

-- TODO: Orders
CREATE TABLE Orders
(
   Id         INT IDENTITY (1,1) PRIMARY KEY,
   CustomerId INT NOT NULL,
   OrderDate  DATETIME DEFAULT GETDATE(),
   Status     NVARCHAR(50),

   CONSTRAINT FK_Orders_Customers
      FOREIGN KEY (CustomerId) REFERENCES Customers (Id)
);

-- TODO: OrderItems
CREATE TABLE OrderItems
(
   Id        INT IDENTITY (1,1) PRIMARY KEY,
   OrderId   INT            NOT NULL,
   ProductId INT            NOT NULL,
   Quantity  INT            NOT NULL,
   UnitPrice DECIMAL(10, 2) NOT NULL,

   CONSTRAINT FK_OrderItems_Orders
      FOREIGN KEY (OrderId) REFERENCES Orders (Id),

   CONSTRAINT FK_OrderItems_Products
      FOREIGN KEY (ProductId) REFERENCES Products (Id)
);

-- TODO: Suppliers
CREATE TABLE Suppliers
(
   Id          INT IDENTITY (1,1) PRIMARY KEY,
   Name        NVARCHAR(150) NOT NULL,
   ContactInfo NVARCHAR(MAX)
);

-- TODO: ProductSuppliers (Many-to-Many)
CREATE TABLE ProductSuppliers
(
   Id         INT IDENTITY (1,1) PRIMARY KEY,
   ProductId  INT NOT NULL,
   SupplierId INT NOT NULL,

   CONSTRAINT FK_ProductSuppliers_Products
      FOREIGN KEY (ProductId) REFERENCES Products (Id),

   CONSTRAINT FK_ProductSuppliers_Suppliers
      FOREIGN KEY (SupplierId) REFERENCES Suppliers (Id)
);

