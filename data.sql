INSERT INTO Faculties (FacultyName)
VALUES ('Computer Science'),
       ('Engineering'),
       ('Economics');

INSERT INTO Groups (GroupName, FacultyId)
VALUES ('CS-101', 1),
       ('CS-102', 1),
       ('ENG-201', 2),
       ('ECON-301', 3);

INSERT INTO Students (FullName, GroupId)
VALUES ('Ali Hasanov', 1),
       ('Nigar Aliyeva', 1),
       ('Elvin Mammadov', 2),
       ('Aysel Karimova', 2),
       ('Murad Guliyev', 3),
       ('Lala Ibrahimova', 4);

INSERT INTO ExamResults (StudentId, Subject, Score)
VALUES (1, 'DS', 95),
       (2, 'DS', 88),
       (3, 'DS', 79),
       (4, 'DS', 91),
       (5, 'DS', 84),
       (6, 'DS', 73),

       (1, 'Math', 80),
       (2, 'Math', 90),
       (3, 'Math', 75),
       (4, 'Math', 60),
       (5, 'Math', 82),
       (6, 'Math', 70);

INSERT INTO Users (UserName, Password, FullName)
VALUES
   ('admin', '1234', 'System Admin'),
   ('elgun', 'pass123', 'Elgun Developer');

