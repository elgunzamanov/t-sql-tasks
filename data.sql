-- TODO: Users + Phones (Operator testləri üçün)
INSERT INTO Users (FullName)
VALUES ('Elgun Ismayilov'), ('Nicat Aliyev'), ('Aynur Karimova');

INSERT INTO UserPhones (UserId, PhoneNumber, Operator)
VALUES
   (1, '050-555-12-34', 'Bakcel'),
   (1, '0707778899', 'Azercel'),
   (1, '+994558887744', 'Nar'),

   (2, '0554443322', 'Bakcel'),
   (2, '0773332211', 'Azercel'),

   (3, '+99470 123 45 67', 'Azercel');

-- TODO: Students + Lesson Records
INSERT INTO Students (FullName)
VALUES ('Ali Mammadov'), ('Gunel Rehimli');

INSERT INTO LessonRecords (StudentId, LessonId, Note)
VALUES
   (1, 101, 'Home task done'),
   (1, 102, 'Late to lesson'),
   (2, 101, 'No issues');

-- TODO: Employees (Contract testləri üçün)
INSERT INTO Employees (FullName, Salary, ContractStartDate, ContractEndDate)
VALUES
   ('Elgun Manager', 1200, '2022-01-01', '2024-12-01'),
   ('Kamran Developer', 1500, '2023-05-10', DATEADD(month, 1, GETDATE())),
   ('Nigar HR', 1400, '2023-06-01', '2025-06-01');

-- TODO: Products (Stock + expiry tests)
INSERT INTO Products (ProductName, Quantity, UnitPrice, ExpiryDate)
VALUES
   ('iPhone 15', 10, 2500, '2026-01-01'),
   ('Samsung A54', 5, 1200, '2025-12-01'),
   ('Xiaomi 12', 0, 900, '2023-01-01');

-- TODO: Sales (trigger + commission tests)
INSERT INTO Sales (ProductId, Quantity, UnitPrice, EmployeeId)
VALUES
   (1, 1, 2500, 1),
   (2, 2, 1200, 2);

-- TODO: ExampleTable
INSERT INTO dbo.ExampleTable (ColA, ColB, ColC)
VALUES
('A1', 100, 12.50),
('B1', 200, 25.75),
('C1', 300, 30.00),
('A1', 100, 12.50),
('B1', 200, 25.75),
('D1', 400, 45.00);

