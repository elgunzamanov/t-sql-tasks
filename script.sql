USE ComputerStore;

-- TODO: 1. Hər filialdakı işçi sayını tapın
SELECT b.BranchName,
       COUNT(DISTINCT s.EmployeeId) AS EmployeeCount
FROM Branches b
        LEFT JOIN Sales s ON b.Id = s.BranchId
GROUP BY b.BranchName;

-- TODO: 2. Hər filialda mövcud olan məhsul sayını tapın
SELECT b.BranchName,
       COUNT(DISTINCT s.ProductId) AS ProductsAvailable
FROM Branches b
        LEFT JOIN Sales s ON b.Id = s.BranchId
GROUP BY b.BranchName;

-- TODO: 3. Hər işçinin cari ayda satdığı məhsulların yekun qiymətini tapın
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName,
       SUM(p.Price * s.Quantity)      AS TotalSalesAmount
FROM Employees e
        JOIN Sales s ON e.Id = s.EmployeeId
        JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(s.SaleDate) = MONTH(GETDATE())
  AND YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY e.FirstName, e.LastName;

-- TODO: 4. Cari ayda hər satıcının maaşı
SELECT
   e.FirstName + ' ' + e.LastName AS EmployeeName,
   350  + ISNULL(SUM(p.Price * s.Quantity), 0) * 0.01 AS MonthlySalary
FROM Employees e
   LEFT JOIN Sales s
      ON e.Id = s.EmployeeId
         AND MONTH(s.SaleDate) = MONTH(GETDATE())
         AND YEAR(s.SaleDate) = YEAR(GETDATE())
   LEFT JOIN Products p ON p.Id = s.ProductId
GROUP BY e.FirstName, e.LastName;

-- TODO: 5. Hər filial üzrə cari aydakı qazanc
SELECT b.BranchName,
       SUM(p.Price * s.Quantity) * 0.01 AS MonthlyProfit
FROM Branches b
   JOIN Sales s
      ON b.Id = s.BranchId
         AND MONTH(s.SaleDate) = MONTH(GETDATE())
         AND YEAR(s.SaleDate) = YEAR(GETDATE())
   JOIN Products p ON p.Id = s.ProductId
GROUP BY b.BranchName;

-- TODO: 6. Cari ay üzrə tam aylıq hesabat (filial → işçi → satış → əməkhaqqı → qazanc)
SELECT
   b.BranchName,
   e.FirstName + ' ' + e.LastName AS EmployeeName,
   ISNULL(SUM(p.Price * s.Quantity), 0) AS TotalSales,
   350 + ISNULL(SUM(p.Price * s.Quantity), 0) * 0.01 AS Salary,
   ISNULL(SUM(p.Price * s.Quantity), 0) * 0.01 AS Profit
FROM Branches b
   JOIN Sales s
      ON b.Id = s.BranchId
         AND MONTH(s.SaleDate) = MONTH(GETDATE())
         AND YEAR(s.SaleDate) = YEAR(GETDATE())
   JOIN Employees e ON e.Id = s.EmployeeId
   JOIN Products p ON p.Id = s.ProductId
GROUP BY
   b.BranchName,
   e.FirstName,
   e.LastName
ORDER BY
   b.BranchName,
   EmployeeName;

