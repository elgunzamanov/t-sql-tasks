-- TODO: 1) Login üçün procedure (Username & Password yoxlanması)
CREATE PROCEDURE sp_UserLogin
   @UserName NVARCHAR(100),
   @Password NVARCHAR(100)
AS
BEGIN
   SET NOCOUNT ON;

   IF NOT EXISTS (SELECT 1 FROM Users WHERE UserName = @UserName)
      BEGIN
         PRINT 'User not found!';
         RETURN;
      END

   IF EXISTS (SELECT 1 FROM Users WHERE UserName = @UserName AND Password = @Password)
      BEGIN
         PRINT 'Login successful!';
      END
   ELSE
      BEGIN
         PRINT 'Invalid password!';
      END
END

-- NOTE: Qeyd: Username unikal etmək üçün Users cədvəlində UNIQUE constraint olmalıdır:
ALTER TABLE Users ADD CONSTRAINT UQ_User_UserName UNIQUE(UserName);

-- TODO: 2) Password Reset procedure
CREATE PROCEDURE sp_ResetPassword
   @UserName NVARCHAR(100),
   @NewPassword NVARCHAR(100)
AS
BEGIN
   SET NOCOUNT ON;

   IF NOT EXISTS (SELECT 1 FROM Users WHERE UserName = @UserName)
      BEGIN
         PRINT 'User does not exist!';
         RETURN;
      END

   UPDATE Users
   SET Password = @NewPassword
   WHERE UserName = @UserName;

   PRINT 'Password reset successfully.';
END

-- TODO: 3) Tələbənin imtahan nəticəsinin yoxlanılması
CREATE PROCEDURE sp_CheckStudentExamResult
@StudentId INT
AS
BEGIN
   SELECT s.FullName, e.Subject, e.Score
   FROM Students s
      JOIN ExamResults e ON s.StudentId = e.StudentId
   WHERE s.StudentId = @StudentId;
END

-- TODO: 4) User cədvəli üçün log cədvəlinin yaradılması
CREATE TABLE UserLogs
(
   LogId INT IDENTITY PRIMARY KEY,
   UserId INT,
   Action NVARCHAR(200),
   ActionDate DATETIME DEFAULT GETDATE()
);

-- NOTE: Trigger (INSERT zamanı log yazmaq):
CREATE TRIGGER trg_User_Insert ON Users
AFTER INSERT
AS
BEGIN
   INSERT INTO UserLogs(UserId, Action)
   SELECT Id, 'User created'
   FROM inserted;
END

-- TODO: 5) CONCAT funksiyasının alternativi
CREATE FUNCTION fn_MyConcat(@A NVARCHAR(MAX), @B NVARCHAR(MAX))
   RETURNS NVARCHAR(MAX)
AS
BEGIN
   RETURN (@A + @B);
END

-- TODO: 6) Maaşa görə vergi hesablayan funksiya
CREATE FUNCTION fn_CalcTax(@Salary DECIMAL(10,2))
   RETURNS DECIMAL(10,2)
AS
BEGIN
   DECLARE @Tax DECIMAL(10,2);

   IF @Salary <= 1000 SET @Tax = @Salary * 0.05;
   ELSE IF @Salary <= 2000 SET @Tax = @Salary * 0.10;
   ELSE SET @Tax = @Salary * 0.15;

   RETURN @Tax;
END

-- TODO: 7) Ən yüksək bal toplayan 3-cü tələbənin məlumatı
SELECT TOP 1 *
FROM (
   SELECT
      s.StudentId,
      s.FullName,
      e.Score,
      ROW_NUMBER() OVER (ORDER BY e.Score DESC) AS rn
   FROM Students s
           JOIN ExamResults e ON s.StudentId = e.StudentId
   WHERE e.Subject = 'DS'
) AS X
WHERE rn = 3;

-- TODO: 8) Hər fakültədən ən yüksək bal toplayan 3-cü tələbə
SELECT *
FROM (
   SELECT
      f.FacultyId,
      f.FacultyName,
      s.StudentId,
      s.FullName,
      e.Score,
      ROW_NUMBER() OVER (
        PARTITION BY f.FacultyId
        ORDER BY e.Score DESC
      ) AS rn
   FROM Students s
      JOIN Groups g ON s.GroupId = g.GroupId
      JOIN Faculties f ON g.FacultyId = f.FacultyId
      JOIN ExamResults e ON s.StudentId = e.StudentId
   WHERE e.Subject = 'DS'
) AS X
WHERE rn = 3;

-- TODO: 9) DS oxuyan tələbələrin sayına görə təqaüd alanların tapılması
WITH DS_Count AS (
SELECT
   g.GroupId,
   COUNT(*) AS ScholarshipCount
FROM Students s
   JOIN ExamResults e ON s.StudentId = e.StudentId
   JOIN Groups g ON s.GroupId = g.GroupId
WHERE e.Subject = 'DS'
GROUP BY g.GroupId
),
   Ranked AS (
      SELECT
         s.StudentId,
         s.FullName,
         g.GroupId,
         e.Score,
         ROW_NUMBER() OVER (
            PARTITION BY g.GroupId
            ORDER BY e.Score DESC
            ) AS rn
      FROM Students s
         JOIN ExamResults e ON s.StudentId = e.StudentId
         JOIN Groups g ON s.GroupId = g.GroupId
      WHERE e.Subject = 'DS'
)
SELECT r.*
FROM Ranked r
   JOIN DS_Count d ON r.GroupId = d.GroupId
WHERE r.rn <= d.ScholarshipCount;

