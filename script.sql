-- TODO: 1) Bütün operatorlardan (Azercel, Bakcel, Nar) nömrəsi olan istifadəçilərin siyahısı
SELECT u.UserId, u.FullName
FROM Users u
        JOIN UserPhones p ON p.UserId = u.UserId
WHERE p.Operator IN ('Azercel','Bakcel','Nar')
GROUP BY u.UserId, u.FullName
HAVING COUNT(DISTINCT p.Operator) = 3;

-- TODO: 2) Cədvələ qarışıq formatda yazılmış nömrələrin eyni formatda göstərilməsi
CREATE FUNCTION dbo.NormalizePhone(@raw varchar(100))
   RETURNS varchar(20)
AS
BEGIN
   DECLARE @s varchar(100) = ISNULL(@raw,'');
   WHILE PATINDEX('%[^0-9]%', @s) > 0
      SET @s = STUFF(@s, PATINDEX('%[^0-9]%', @s), 1, '');

   IF LEN(@s) = 10 AND LEFT(@s,1) = '0'
      SET @s = '994' + SUBSTRING(@s,2,9);

   IF LEN(@s) = 9
      SET @s = '994' + @s;

   IF LEN(@s) = 13 AND LEFT(@s,2) = '00'
      SET @s = SUBSTRING(@s,3, LEN(@s)-2);

   IF LEFT(@s,3) = '994'
      SET @s = '+' + @s;

   RETURN @s;
END;

SELECT PhoneNumber, dbo.NormalizePhone(PhoneNumber) AS NormalizedPhone
FROM UserPhones;

-- TODO: 3) Tələbələrə dərs recordları üçün icazələrin verilməsi
CREATE ROLE student_role;

CREATE LOGIN student_john WITH PASSWORD = '@FooBar()';

USE MixedDB;
CREATE USER student_john FOR LOGIN student_john;

ALTER ROLE student_role ADD MEMBER student_john;

GRANT SELECT, INSERT, UPDATE ON dbo.LessonRecords TO student_role;

CREATE PROCEDURE dbo.InsertLessonRecord
   @StudentId INT,
   @LessonId INT,
   @Note NVARCHAR(4000)
AS
BEGIN
   SET NOCOUNT ON;
   INSERT INTO dbo.LessonRecords (StudentId, LessonId, Note, CreatedAt)
   VALUES (@StudentId, @LessonId, @Note, GETDATE());
END;
   GRANT EXECUTE ON dbo.InsertLessonRecord TO student_role;

GRANT EXECUTE ON dbo.InsertLessonRecord TO student_role;

-- TODO: 4) Dublikat olan məlumatların silinməsi
WITH CTE AS (
   SELECT *,
          ROW_NUMBER() OVER (PARTITION BY ColA, ColB, ColC ORDER BY CreatedAt, Id) AS rn
   FROM dbo.ExampleTable
)
DELETE FROM CTE WHERE rn > 1;

SELECT * FROM (
   SELECT *, ROW_NUMBER() OVER (PARTITION BY ColA, ColB, ColC ORDER BY CreatedAt) rn
   FROM dbo.ExampleTable
) t WHERE rn > 1;

/* TODO: 5) Hər məhsul satıldıqca satışı edən işçiyə həmin məhsulun
      2%-i qədər motivasiya maaşı əlavə olunması */
CREATE PROCEDURE dbo.AddMotivation
   @EmployeeId INT,
   @Amount DECIMAL(18,2)
AS
BEGIN
   UPDATE Employees
   SET MotivationBonus = ISNULL(MotivationBonus,0) + @Amount
   WHERE EmployeeId = @EmployeeId;
END;

CREATE TRIGGER trg_Sales_AfterInsert
   ON dbo.Sales
   AFTER INSERT
   AS
BEGIN
   SET NOCOUNT ON;

   UPDATE e
   SET e.MotivationBonus = ISNULL(e.MotivationBonus,0) + calc.TotalCommission
   FROM Employees e
           JOIN (
      SELECT i.EmployeeId,
             SUM(i.UnitPrice * i.Quantity * 0.02) AS TotalCommission
      FROM inserted i
      GROUP BY i.EmployeeId
   ) calc ON e.EmployeeId = calc.EmployeeId;
END;

/* TODO: 6) Məhsul satıldıqca, məhsul cədvəlindən sayı satış sayı qədər azalsın,
      əgər qeyd olunan sayda məhsul yoxdursa, bu zaman istifadəçiyə bildiriş çıxarılması */
CREATE PROCEDURE dbo.DoSale
   @ProductId INT,
   @Quantity INT,
   @EmployeeId INT,
   @UnitPrice DECIMAL(18,2)
AS
BEGIN
   SET NOCOUNT ON;
   BEGIN TRAN;

   DECLARE @CurrentQty INT;
   SELECT @CurrentQty = Quantity
   FROM dbo.Products WITH (UPDLOCK, HOLDLOCK)
   WHERE ProductId = @ProductId;

   IF @CurrentQty IS NULL
      BEGIN
         ROLLBACK;
         THROW 50001, N'Product not found.', 1;
      END

   IF @CurrentQty < @Quantity
      BEGIN
         ROLLBACK;
         DECLARE @Msg NVARCHAR(200);
         SET @Msg = N'Insufficient stock. Available: '
            + CAST(@CurrentQty AS NVARCHAR(10))
            + N', Requested: '
            + CAST(@Quantity AS NVARCHAR(10));
         THROW 50002, @Msg, 1;
      END

   UPDATE dbo.Products
   SET Quantity = Quantity - @Quantity
   WHERE ProductId = @ProductId;

   INSERT INTO dbo.Sales (ProductId, Quantity, UnitPrice, EmployeeId, SaleDate)
   VALUES (@ProductId, @Quantity, @UnitPrice, @EmployeeId, GETDATE());

   COMMIT;

   SELECT 'Sale completed' AS Message;
END;

/* TODO: 7) Müqavilə vaxtı bitən və bitməyinə 1 ay qalan işçilər
      haqqında bildiriş çıxaran view yaradılması */
USE MixedDB;
CREATE OR ALTER VIEW dbo.vw_ExpiringContracts
AS
SELECT
   EmployeeId,
   FullName,
   ContractStartDate,
   ContractEndDate,
   DATEDIFF(day, GETDATE(), ContractEndDate) AS DaysUntilEnd,
   CASE
      WHEN ContractEndDate < GETDATE() THEN 'Expired'
      WHEN ContractEndDate BETWEEN GETDATE() AND DATEADD(month,1,GETDATE()) THEN 'ExpiresWithin1Month'
      ELSE 'Active'
      END AS Status
FROM dbo.Employees
WHERE ContractEndDate IS NOT NULL
  AND (ContractEndDate < GETDATE() OR ContractEndDate <= DATEADD(month,1,GETDATE()));

SELECT * FROM dbo.vw_ExpiringContracts;

-- TODO: 8) Son istifadə müddəti bitən məhsulların aktivlik statusunun dəyişdirilməsi
CREATE TRIGGER trg_Products_InsertUpdate
   ON dbo.Products
   AFTER INSERT, UPDATE
   AS
BEGIN
   SET NOCOUNT ON;

   UPDATE p
   SET IsActive = 0
   FROM dbo.Products p
           JOIN inserted i ON p.ProductId = i.ProductId
   WHERE i.ExpiryDate IS NOT NULL AND i.ExpiryDate < GETDATE();

   UPDATE p
   SET IsActive = 1
   FROM dbo.Products p
           JOIN inserted i ON p.ProductId = i.ProductId
   WHERE i.ExpiryDate IS NULL OR i.ExpiryDate >= GETDATE();
END;

