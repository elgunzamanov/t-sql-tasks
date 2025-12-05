INSERT INTO Students (FullName, Age, Email, Score)
VALUES
('Ali Hasanov', 15, 'ali@example.com', 78),
('Nigar Mammadova', 18, 'nigar@example.com', 92),
('Rashad Aliyev', 12, 'rashad@example.com', 56),
('Kamran Suleymanov', 20, 'kamran@example.com', 99),
('Lala Valiyeva', 10, 'lala@example.com', 34);

UPDATE Students
SET Email = CONCAT('updated_', Email)
WHERE Score > 90;

DELETE FROM Students
WHERE Age < 10;

INSERT INTO TopStudents (Id, FullName, Score)
SELECT Id, FullName, Score
FROM Students
WHERE Score > 90;

