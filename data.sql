USE Library;

INSERT INTO Authors (Name, Surname)
VALUES
   ('George', 'Orwell'),
   ('Fyodor', 'Dostoevsky'),
   ('Jane', 'Austen');

INSERT INTO Books (AuthorId, Name, PageCount)
VALUES
   (1, '1984', 328),
   (1, 'Animal Farm', 112),
   (2, 'Crime and Punishment', 671),
   (3, 'Pride and Prejudice', 432);

-- TODO: VIEW istifadəsi
SELECT * FROM vw_BookList;

-- TODO: PROCEDURE istifadəsi
EXEC sp_SearchBooks 'George';

-- TODO: FUNCTION istifadəsi
SELECT dbo.fn_BookCountByPageCount(300);

-- TODO: TRIGGER test etmək
DELETE FROM Books WHERE Name = '1984';
SELECT * FROM DeletedBooks;

