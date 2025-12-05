-- TODO: 1. Full stack paketi üçün qeydiyyatdan keçən tələbələrin ümumi sayı
SELECT COUNT(*) AS TelebeSayi
FROM Qeydiyyat q
        JOIN Paketler p ON q.PaketId = p.Id
WHERE p.Ad = 'Full Stack';

-- TODO: 2. Kursun aylıq dövriyəsini hesablayın
SELECT
   YEAR(o.Tarix) AS Il,
   MONTH(o.Tarix) AS Ay,
   SUM(o.Mebleg) AS AyliqDovriye
FROM Odenis o
GROUP BY YEAR(o.Tarix), MONTH(o.Tarix)
ORDER BY Il, Ay;

-- TODO: 3. Ödəniş vaxtına 3 gün qalan tələbələrin siyahısı
SELECT t.Id, t.Ad, t.Soyad, o.Tarix AS OdenisTarixi
FROM Telebe t
        JOIN Qeydiyyat q ON t.Id = q.TelebeId
        JOIN Odenis o ON q.Id = o.QeydiyyatId
WHERE DATEDIFF(DAY, GETDATE(), o.Tarix) = 3;

-- TODO: 4. Ödəniş vaxtından keçən tələbələrin siyahısı
SELECT t.Id, t.Ad, t.Soyad, o.Tarix AS OdenisTarixi
FROM Telebe t
        JOIN Qeydiyyat q ON t.Id = q.TelebeId
        JOIN Odenis o ON q.Id = o.QeydiyyatId
WHERE o.Tarix < GETDATE();

-- TODO: 5. Təlimçilərin kursdan aldığı maaş
SELECT t.Id AS TelimciId, t.Ad, t.Soyad,
       SUM(o.Mebleg * 0.5) AS Maas
FROM Telimci t
        JOIN Qeydiyyat q ON t.Id = q.TelimciId
        JOIN Odenis o ON q.Id = o.QeydiyyatId
GROUP BY t.Id, t.Ad, t.Soyad;

-- TODO: 6. Son 1 aylıq ödənişi qalan tələbələrin siyahısı
SELECT t.Id, t.Ad, t.Soyad, o.Tarix AS OdenisTarixi
FROM Telebe t
        JOIN Qeydiyyat q ON t.Id = q.TelebeId
        JOIN Odenis o ON q.Id = o.QeydiyyatId
WHERE o.Tarix BETWEEN DATEADD(MONTH, -1, GETDATE()) AND GETDATE();

-- TODO: 7. Hal-hazırda kursun neçə tələbəsi var
SELECT COUNT(*) AS AktivTelebeSayi
FROM Qeydiyyat
WHERE Status = 'Aktiv';

-- TODO: 8. Hər paket üzrə hər təlimçinin dərs keçdiyi tələbə sayı
SELECT t.Id AS TelimciId, t.Ad AS TelimciAd, t.Soyad AS TelimciSoyad,
       p.Id AS PaketId, p.Ad AS PaketAd,
       COUNT(DISTINCT q.TelebeId) AS TelebeSayi
FROM Telimci t
        JOIN Qeydiyyat q ON t.Id = q.TelimciId
        JOIN Paketler p ON q.PaketId = p.Id
GROUP BY t.Id, t.Ad, t.Soyad, p.Id, p.Ad
ORDER BY t.Id, p.Id;

-- TODO: 9. Hər paket üzrə hər bölmənin hər mövzusu üzrə neçə video dərslik var
SELECT p.Ad AS Paket, b.Ad AS Bolme, m.Ad AS Movzu, COUNT(v.Id) AS VideoSay
FROM VideoDers v
        JOIN Paketler p ON v.PaketId = p.Id
        JOIN Bolme b ON v.BolmeId = b.Id
        JOIN Movzu m ON v.MovzuId = m.Id
GROUP BY p.Ad, b.Ad, m.Ad
ORDER BY p.Ad, b.Ad, m.Ad;

-- TODO: 10. Yalnız ödəniş edən tələbələrə video dərslər üçün icazə verilsin
SELECT v.*
FROM VideoDers v
        JOIN Qeydiyyat q ON v.PaketId = q.PaketId
WHERE q.Id IN (
   SELECT DISTINCT QeydiyyatId
   FROM Odenis
);

