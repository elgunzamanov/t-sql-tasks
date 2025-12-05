CREATE DATABASE UniversityDB;
USE UniversityDB;

CREATE TABLE Users
(
   Id INT IDENTITY PRIMARY KEY,
   UserName NVARCHAR(100) UNIQUE,
   Password NVARCHAR(100),
   FullName NVARCHAR(200)
);

CREATE TABLE UserLogs
(
   LogId INT IDENTITY PRIMARY KEY,
   UserId INT,
   Action NVARCHAR(200),
   ActionDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Faculties
(
   FacultyId INT IDENTITY PRIMARY KEY,
   FacultyName NVARCHAR(200)
);

CREATE TABLE Groups
(
   GroupId INT IDENTITY PRIMARY KEY,
   GroupName NVARCHAR(50),
   FacultyId INT REFERENCES Faculties(FacultyId)
);

CREATE TABLE Students
(
   StudentId INT IDENTITY PRIMARY KEY,
   FullName NVARCHAR(200),
   GroupId INT REFERENCES Groups(GroupId)
);

CREATE TABLE ExamResults
(
   ExamId INT IDENTITY PRIMARY KEY,
   StudentId INT REFERENCES Students(StudentId),
   Subject NVARCHAR(100),
   Score INT
);

