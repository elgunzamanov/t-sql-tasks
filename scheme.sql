CREATE DATABASE FullStackCourse

USE FullStackCourse;

CREATE TABLE Telimci
(
   Id       INT IDENTITY (1,1) PRIMARY KEY,
   Ad       NVARCHAR(50) NOT NULL,
   Soyad    NVARCHAR(50) NOT NULL,
   AtaAdi   NVARCHAR(50),
   Fin      NVARCHAR(20),
   Tel      NVARCHAR(20),
   Tevellud DATE,
   Ixtisas  NVARCHAR(50),
   Staj     INT,
   Status   NVARCHAR(20)
);

CREATE TABLE Paketler
(
   Id     INT IDENTITY (1,1) PRIMARY KEY,
   Ad     NVARCHAR(100) NOT NULL,
   Qiymet DECIMAL(10, 2),
   Muddet INT
);

CREATE TABLE Bolme
(
   Id INT IDENTITY (1,1) PRIMARY KEY,
   Ad NVARCHAR(50) NOT NULL
);

CREATE TABLE Movzu
(
   Id INT IDENTITY (1,1) PRIMARY KEY,
   Ad NVARCHAR(100) NOT NULL
);

CREATE TABLE Telebe
(
   Id           INT IDENTITY (1,1) PRIMARY KEY,
   Ad           NVARCHAR(50) NOT NULL,
   Soyad        NVARCHAR(50) NOT NULL,
   AtaAdi       NVARCHAR(50),
   FinKod       NVARCHAR(20),
   Universitet  NVARCHAR(100),
   Ixtisas      NVARCHAR(50),
   Kurs         INT,
   Unvan        NVARCHAR(200),
   ElaqeNomresi NVARCHAR(20),
   Gmail        NVARCHAR(100)
);

CREATE TABLE Qeydiyyat
(
   Id            INT IDENTITY (1,1) PRIMARY KEY,
   TelebeId      INT NOT NULL FOREIGN KEY REFERENCES Telebe (Id),
   PaketId       INT NOT NULL FOREIGN KEY REFERENCES Paketler (Id),
   MuqavileTarix DATE,
   Endirim       DECIMAL(10, 2),
   Status        NVARCHAR(20),
   TelimciId     INT FOREIGN KEY REFERENCES Telimci (Id)
);

CREATE TABLE Odenis
(
   Id          INT IDENTITY (1,1) PRIMARY KEY,
   QeydiyyatId INT NOT NULL FOREIGN KEY REFERENCES Qeydiyyat (Id),
   Tarix       DATE,
   Mebleg      DECIMAL(10, 2)
);

CREATE TABLE VideoDers
(
   Id INT IDENTITY(1,1) PRIMARY KEY,
   PaketId INT NOT NULL FOREIGN KEY REFERENCES Paketler(Id),
   BolmeId INT NOT NULL FOREIGN KEY REFERENCES Bolme(Id),
   MovzuId INT NOT NULL FOREIGN KEY REFERENCES Movzu(Id),
   Ad NVARCHAR(100) NOT NULL
);

