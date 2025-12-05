CREATE DATABASE Library;

USE Library;

-- TODO: Tables yaratmaq üçün SQL
CREATE TABLE Authors
(
   Id      INT IDENTITY PRIMARY KEY,
   Name    NVARCHAR(50) NOT NULL,
   Surname NVARCHAR(50) NOT NULL
);

CREATE TABLE Books
(
   Id        INT IDENTITY PRIMARY KEY,
   AuthorId  INT           NOT NULL,
   Name      NVARCHAR(100) NOT NULL CHECK (LEN(Name) BETWEEN 2 AND 100),
   PageCount INT           NOT NULL CHECK (PageCount >= 10),
   FOREIGN KEY (AuthorId) REFERENCES Authors (Id)
);

CREATE TABLE DeletedBooks
(
   Id        INT,
   AuthorId  INT,
   Name      NVARCHAR(100),
   PageCount INT
);

-- TODO: VIEW — Id, Name, PageCount, AuthorFullName
CREATE VIEW vw_BookList
AS
SELECT b.Id,
       b.Name,
       b.PageCount,
       a.Name + ' ' + a.Surname AS AuthorFullName
FROM Books b
        JOIN Authors a ON a.Id = b.AuthorId;

-- TODO: Search Procedure (Book.Name və ya Author.Name ilə filtr)
CREATE PROCEDURE sp_SearchBooks @search NVARCHAR(100)
AS
BEGIN
   SELECT b.Id,
          b.Name,
          b.PageCount,
          a.Name + ' ' + a.Surname AS AuthorFullName
   FROM Books b
           JOIN Authors a ON a.Id = b.AuthorId
   WHERE b.Name LIKE '%' + @search + '%'
      OR a.Name LIKE '%' + @search + '%'
      OR a.Surname LIKE '%' + @search + '%';
END;

-- TODO: Function – MinPageCount parametri, default 10
CREATE FUNCTION fn_BookCountByPageCount(
   @MinPageCount INT = 10
)
   RETURNS INT
AS
BEGIN
   DECLARE @result INT;

   SELECT @result = COUNT(*)
   FROM Books
   WHERE PageCount > @MinPageCount;

   RETURN @result;
END;

-- TODO: Trigger – Books-dan silinən kitab DeletedBooks-ə düşsün
CREATE TRIGGER trg_BookDelete
   ON Books
   AFTER DELETE
   AS
BEGIN
   INSERT INTO DeletedBooks (Id, AuthorId, Name, PageCount)
   SELECT Id, AuthorId, Name, PageCount
   FROM deleted;
END;

