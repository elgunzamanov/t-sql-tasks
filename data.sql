USE ComputerStore;

-- TODO: Categories
INSERT INTO Categories (CategoryName)
VALUES
   ('Laptop'),
   ('Desktop'),
   ('Monitor'),
   ('Accessories'),
   ('Printer');

-- TODO: Products
INSERT INTO Products (ProductName, Brand, Model, Price, CategoryId)
VALUES
   ('Lenovo IdeaPad 5', 'Lenovo', 'IdeaPad 5', 1450, 1),
   ('Lenovo Legion 7', 'Lenovo', 'Legion 7', 3200, 1),
   ('HP Pavilion 15', 'HP', 'Pavilion 15', 1350, 1),
   ('Dell XPS 13', 'Dell', 'XPS 13', 2800, 1),

   ('Dell Inspiron Desktop', 'Dell', 'Inspiron', 1600, 2),
   ('HP Omen Desktop', 'HP', 'Omen', 2500, 2),

   ('Samsung 24 Curved', 'Samsung', 'C24F390', 320, 3),
   ('LG UltraWide 34', 'LG', '34WN80C', 850, 3),

   ('Logitech MX Master 3', 'Logitech', 'MX Master 3', 120, 4),
   ('Razer BlackWidow', 'Razer', 'BlackWidow', 180, 4),

   ('HP LaserJet Pro', 'HP', 'M404dn', 520, 5);

-- TODO: Employees
INSERT INTO Employees (FirstName, LastName, FatherName, BirthDate, Salary)
VALUES
   ('Murad', 'Aliyev', 'Rasim', '1998-04-10', 900),
   ('Aysel', 'Mammadova', 'Eldar', '1999-09-21', 850),
   ('Rauf', 'Huseynov', 'Mahmud', '2003-01-15', 700),
   ('Elvin', 'Karimov', 'Nazim', '1995-06-05', 1000),
   ('Leyla', 'Hasanova', 'Vaqif', '2001-03-22', 920);

-- TODO: Branches
INSERT INTO Branches (BranchName)
VALUES
   ('Nizami'),
   ('28 May'),
   ('Ganjlik');

-- TODO: Sales Data
INSERT INTO Sales (ProductId, EmployeeId, BranchId, Quantity, SaleDate)
VALUES
(1, 1, 1, 3, DATEADD(DAY, -2, GETDATE())),
(7, 1, 1, 5, DATEADD(DAY, -1, GETDATE())),

(2, 2, 2, 1, DATEADD(DAY, -3, GETDATE())),
(9, 2, 2, 4, GETDATE()),

(10, 3, 3, 2, DATEADD(DAY, -4, GETDATE())),
(6, 3, 3, 1, GETDATE()),

(4, 4, 1, 2, DATEADD(DAY, -1, GETDATE())),
(8, 4, 2, 1, GETDATE()),

(3, 5, 3, 3, DATEADD(DAY, -5, GETDATE())),
(11, 5, 3, 1, GETDATE());

