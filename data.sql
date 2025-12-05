-- TODO: 1. Hər bir müştərinin ümumi sifariş sayını tapmaq
SELECT
   c.Id AS CustomerId,
   c.Name AS CustomerName,
   COUNT(o.Id) AS TotalOrders
FROM Customers c
        LEFT JOIN Orders o ON c.Id = o.CustomerId
GROUP BY c.Id, c.Name;

-- TODO: 2. Yalnız ümumi sifarişləri 5000-dən çox olan müştərilər
SELECT
   c.Id AS CustomerId,
   c.Name AS CustomerName,
   COUNT(o.Id) AS TotalOrders
FROM Customers c
        JOIN Orders o ON c.Id = o.CustomerId
GROUP BY c.Id, c.Name
HAVING COUNT(o.Id) > 5000;

-- TODO: 3. Hər sifariş üçün məhsulların ümumi qiyməti və TotalAmount müqayisəsi
SELECT
   o.Id AS OrderId,
   SUM(oi.Quantity * oi.UnitPrice) AS CalculatedTotal,
   o.TotalAmount,
   IIF(SUM(oi.Quantity * oi.UnitPrice) = o.TotalAmount, 1, 0) AS IsMatch
FROM Orders o
        JOIN OrderItems oi ON o.Id = oi.OrderId
GROUP BY o.Id, o.TotalAmount;

-- TODO: 4. Hər məhsul kateqoriyası üzrə satılan toplam məhsul sayı və toplam satış məbləği
SELECT
   cat.Id AS CategoryId,
   cat.Name AS CategoryName,
   SUM(oi.Quantity) AS TotalQuantitySold,
   SUM(oi.Quantity * oi.UnitPrice) AS TotalSalesAmount
FROM OrderItems oi
        JOIN Products p ON oi.ProductId = p.Id
        JOIN Categories cat ON p.CategoryId = cat.Id
GROUP BY cat.Id, cat.Name;

