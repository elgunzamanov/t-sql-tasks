-- TODO: 1. Bütün məhsulların siyahısı
SELECT * FROM Products;

-- TODO: 2. Bütün işçilərin siyahısı
SELECT * FROM Employees;

-- TODO: 3. Məhsulları kateqoriyaları ilə birlikdə
SELECT p.ProductName, c.CategoryName, p.Price
FROM Products p
        JOIN Categories c ON p.CategoryId = c.Id;

-- TODO: 4. Adı Murad olan işçi
SELECT *
FROM Employees
WHERE FirstName = 'Murad';

-- TODO: 5. Yaşı 25-dən kiçik olan işçilər
SELECT *
FROM Employees
WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) < 25;

-- TODO: 6. Hər modeldən neçə məhsul var
SELECT Model, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Model;

-- TODO: 7. Hər markada hər modelin sayı
SELECT Brand, Model, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Brand, Model;

-- TODO: 8. Hər filial üzrə aylıq satış məbləği
SELECT b.BranchName,
       SUM(p.Price * s.Quantity) AS MonthlyRevenue
FROM Sales s
        JOIN Products p ON s.ProductId = p.Id
        JOIN Branches b ON s.BranchId = b.Id
WHERE MONTH(SaleDate) = MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY b.BranchName;

-- TODO: 9. Ay ərzində ən çox satılan model
SELECT TOP 1 p.Model,
             SUM(s.Quantity) AS TotalSold
FROM Sales s
        JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate) = MONTH(GETDATE())
  AND YEAR(SaleDate) = YEAR(GETDATE())
GROUP BY p.Model
ORDER BY TotalSold DESC;

-- TODO: 10. Ayda ən az satış edən işçi
SELECT TOP 1 e.FirstName, e.LastName,
             SUM(s.Quantity) AS TotalSales
FROM Sales s
        JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate)=YEAR(GETDATE())
GROUP BY e.FirstName, e.LastName
ORDER BY TotalSales;

-- TODO: 11. Ayda 3000 AZN-dən çox satış edən işçilər
SELECT e.*, SUM(p.Price * s.Quantity) AS TotalAmount
FROM Sales s
        JOIN Products p ON s.ProductId = p.Id
        JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate)=YEAR(GETDATE())
GROUP BY e.Id, e.FirstName, e.LastName, e.FatherName, e.BirthDate, e.Salary
HAVING SUM(p.Price * s.Quantity) > 3000;

-- TODO: 12. Ad, soyad və ata adını bir sütunda göstər
SELECT CONCAT(FirstName, ' ', LastName, ' ', FatherName) AS FullName
FROM Employees;

-- TODO: 13. Məhsul adı və uzunluğunu göstər
SELECT ProductName, LEN(ProductName) AS NameLength
FROM Products;

-- TODO: 14. Ən bahalı məhsul
SELECT TOP 1 *
FROM Products
ORDER BY Price DESC;

-- TODO: 15. Ən bahalı və ən ucuz məhsul birlikdə
SELECT *
FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products)
   OR Price = (SELECT MIN(Price) FROM Products);

-- TODO: 16. Məhsulları qiymətinə görə kateqoriyaya bölün
SELECT ProductName, Price,
       CASE
          WHEN Price < 1000 THEN N'Münasib'
          WHEN Price BETWEEN 1000 AND 2500 THEN N'Orta qiymətli'
          WHEN Price > 2500 THEN 'Baha'
          END AS PriceCategory
FROM Products;

-- TODO: 17. Cari ayda bütün satışların cəmi
SELECT SUM(p.Price * s.Quantity) AS TotalMonthSales
FROM Sales s
        JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate)=YEAR(GETDATE());

-- TODO: 18. Cari ay ən çox qazanc gətirən işçi
SELECT TOP 1 e.*,
             SUM(p.Price * s.Quantity) AS TotalRevenue
FROM Sales s
        JOIN Products p ON s.ProductId = p.Id
        JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(SaleDate)=MONTH(GETDATE())
  AND YEAR(SaleDate)=YEAR(GETDATE())
GROUP BY e.Id, e.FirstName, e.LastName, e.FatherName, e.BirthDate, e.Salary
ORDER BY TotalRevenue DESC;

-- TODO: 19. Ən çox satış edən işçinin maaşını 50% artır
UPDATE Employees
SET Salary = Salary * 1.5
WHERE Id = (
   SELECT TOP 1 e.Id
   FROM Sales s
           JOIN Employees e ON s.EmployeeId = e.Id
   GROUP BY e.Id
   ORDER BY SUM(s.Quantity) DESC
);

