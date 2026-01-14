-- Meilenstein 2
-- Datenbanksysteme
-- Gruppe: Boiko Bohdana, Alexander Grath
-- Fahrplansystem Wien Praterstern

INSERT INTO Fahrzeug VALUES (1, 2018, 80);
INSERT INTO Fahrzeug VALUES (2, 2020, 200);
INSERT INTO Fahrzeug VALUES (3, 2015, 150);

INSERT INTO Bus VALUES (1, 'W-1234AB', 'J');
INSERT INTO Zug VALUES (2, 'Railjet', 6);
INSERT INTO Strassenbahn VALUES (3, 1435, 'DC 600V');

INSERT INTO Wartung VALUES (1, DATE '2025-01-10', 500.00, 'Inspektion', 1);

INSERT INTO Personal VALUES (1, 'Max Fahrer', 2500, DATE '2020-03-23');
INSERT INTO Personal VALUES (2, 'Anna Fahrerin', 2300, DATE '2022-07-19');
INSERT INTO Personal VALUES (3, 'Karl Kontrolle', 2200, DATE '2021-01-15');

INSERT INTO Fahrer VALUES (1, 'B', NULL);
INSERT INTO Fahrer VALUES (2, 'B', 1);

INSERT INTO Kontrolleur VALUES (3, 'Linie 15');

INSERT INTO Haltestelle VALUES (1, 'Praterstern', 'J');
INSERT INTO Haltestelle VALUES (2, 'Karlsplatz', 'N');

INSERT INTO Linie VALUES (1, 5, TIME '05:00:00', TIME '23:30:00');

INSERT INTO Linie_Haltestelle VALUES (1, 1, 1);
INSERT INTO Linie_Haltestelle VALUES (1, 2, 2);

INSERT INTO Kunde VALUES (1, 'Lisa Kunde', 'lisa@beispiel.com', 'Wien');

INSERT INTO Ticket VALUES (1, DATE '2025-02-01', 45.00, DATE '2025-02-01', DATE '2025-02-28', 1);

INSERT INTO Ticket_Linie VALUES (1, 1);


-- Primary Key Test:
INSERT INTO Personal VALUES (1, 'Zwilling Fahrer', 2000, DATE '2023-01-01'); -- PersonalNr already exists
-- Foreign Key Test:
INSERT INTO Bus VALUES (99, 'W-1235AB', 'N'); -- there is no FahrzeugID 99
-- Deletion Rule Tests
-- 1) NO ACTION
DELETE FROM Fahrzeug WHERE FahrzeugID = 1; -- can't be deleted is is part of Wartung 1
-- 2) CASCADE and SET NULL
DELETE FROM Personal WHERE PersonalNr = 1; -- Fahrer 1 will be deleted (CASCADE), Fahrer 2's Mentor will be deleted (SET NULL)


CREATE VIEW Ticket_Uebersicht AS
SELECT
  k.Name AS Kunde,
  t.TicketID,
  t.Preis,
  l.LinienNr
FROM Kunde k
JOIN Ticket t ON k.KundenID = t.KundenID
JOIN Ticket_Linie tl ON t.TicketID = tl.TicketID
JOIN Linie l ON tl.LinienNr = l.LinienNr;

SELECT * FROM Ticket_Uebersicht;