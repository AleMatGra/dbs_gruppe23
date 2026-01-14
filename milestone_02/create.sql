-- Meilenstein 2
-- Datenbanksysteme
-- Gruppe: Boiko Bohdana, Alexander Grath
-- Fahrplansystem Wien Praterstern

CREATE TABLE Fahrzeug (
  FahrzeugID INTEGER,
  Baujahr    SMALLINT NOT NULL,
  Kapazitaet INTEGER,
  -- PK: primary key
  CONSTRAINT PK_Fahrzeug PRIMARY KEY (FahrzeugID),
  -- CC: check constraint
  CONSTRAINT CC_Fahrzeug_Kapazitaet CHECK (Kapazitaet > 0)
);

CREATE TABLE Bus (
  FahrzeugID  INTEGER,
  Kennzeichen VARCHAR2(20) NOT NULL,
  Niederflur  CHAR(1) DEFAULT 'N',
  CONSTRAINT PK_Bus PRIMARY KEY (FahrzeugID),
  -- UQ: unique constraint
  CONSTRAINT UQ_Bus_Kennzeichen UNIQUE (Kennzeichen),
  -- FK: foreign key
  CONSTRAINT FK_Bus_Fahrzeug FOREIGN KEY (FahrzeugID)
    REFERENCES Fahrzeug(FahrzeugID)
    ON DELETE CASCADE,
  CONSTRAINT CC_Bus_Niederflur CHECK (Niederflur IN ('J','N'))
);

CREATE TABLE Zug (
  FahrzeugID  INTEGER,
  Baureihe    VARCHAR2(30) NOT NULL,
  Wagonanzahl INTEGER,
  CONSTRAINT PK_Zug PRIMARY KEY (FahrzeugID),
  CONSTRAINT FK_Zug_Fahrzeug FOREIGN KEY (FahrzeugID)
    REFERENCES Fahrzeug(FahrzeugID)
    ON DELETE CASCADE,
  CONSTRAINT CC_Zug_Wagon CHECK (Wagonanzahl > 0)
);

CREATE TABLE Strassenbahn (
  FahrzeugID  INTEGER,
  Spurweite   INTEGER NOT NULL,
  Stromsystem VARCHAR2(30) NOT NULL,
  CONSTRAINT PK_Strassenbahn PRIMARY KEY (FahrzeugID),
  CONSTRAINT FK_Strassenbahn_Fahrzeug FOREIGN KEY (FahrzeugID)
    REFERENCES Fahrzeug(FahrzeugID)
    ON DELETE CASCADE
);

CREATE TABLE Wartung (
  WartungID  INTEGER,
  Datum      DATE NOT NULL,
  Kosten     NUMERIC(10,2),
  Art        VARCHAR2(50) NOT NULL,
  FahrzeugID INTEGER NOT NULL,
  CONSTRAINT PK_Wartung PRIMARY KEY (WartungID),
  -- defaults to NO ACTION, can't delete Fahrzeug with Wartung
  CONSTRAINT FK_Wartung_Fahrzeug FOREIGN KEY (FahrzeugID)
    REFERENCES Fahrzeug(FahrzeugID),
  CONSTRAINT CC_Wartung_Kosten CHECK (Kosten >= 0)
);

CREATE TABLE Personal (
  PersonalNr       INTEGER,
  Name             VARCHAR2(50) NOT NULL,
  Gehalt           NUMERIC(10,2),
  Einstellungsdatum DATE NOT NULL,
  CONSTRAINT PK_Personal PRIMARY KEY (PersonalNr),
  CONSTRAINT CC_Personal_Gehalt CHECK (Gehalt > 0)
);

CREATE TABLE Fahrer (
  PersonalNr         INTEGER,
  Fuehrerscheinklasse VARCHAR2(10) NOT NULL,
  MentorNr           INTEGER,
  CONSTRAINT PK_Fahrer PRIMARY KEY (PersonalNr),
  CONSTRAINT FK_Fahrer_Personal FOREIGN KEY (PersonalNr)
    REFERENCES Personal(PersonalNr)
    ON DELETE CASCADE,
  CONSTRAINT FK_Fahrer_Mentor FOREIGN KEY (MentorNr)
    REFERENCES Fahrer(PersonalNr)
    ON DELETE SET NULL
);

CREATE TABLE Kontrolleur (
  PersonalNr          INTEGER,
  Zustaendigkeitsbereich VARCHAR2(50) NOT NULL,
  CONSTRAINT PK_Kontrolleur PRIMARY KEY (PersonalNr),
  CONSTRAINT FK_Kontrolleur_Personal FOREIGN KEY (PersonalNr)
    REFERENCES Personal(PersonalNr)
    ON DELETE CASCADE
);

CREATE TABLE Haltestelle (
  HaltestellenID INTEGER,
  Name           VARCHAR2(50) NOT NULL,
  Barrierefrei   CHAR(1) DEFAULT 'N',
  CONSTRAINT PK_Haltestelle PRIMARY KEY (HaltestellenID),
  -- UQ: unique constraint
  CONSTRAINT UQ_Haltestelle_Name UNIQUE (Name),
  CONSTRAINT CC_Haltestelle_Barrierefrei CHECK (Barrierefrei IN ('J','N'))
);

CREATE TABLE Linie (
  LinienNr      INTEGER,
  Taktung       INTEGER,
  Betriebsbeginn TIME NOT NULL,
  Betriebsende   TIME NOT NULL,
  CONSTRAINT PK_Linie PRIMARY KEY (LinienNr),
  CONSTRAINT CC_Linie_Taktung CHECK (Taktung > 0)
);

CREATE TABLE Linie_Haltestelle (
  LinienNr       INTEGER,
  HaltestellenID INTEGER,
  Reihenfolge    INTEGER,
  CONSTRAINT PK_Linie_Haltestelle PRIMARY KEY (LinienNr, HaltestellenID),
  CONSTRAINT FK_Linie_Haltestelle_Linie FOREIGN KEY (LinienNr)
    REFERENCES Linie(LinienNr)
    ON DELETE CASCADE,
  CONSTRAINT FK_Linie_Haltestelle_Haltestelle FOREIGN KEY (HaltestellenID)
    REFERENCES Haltestelle(HaltestellenID)
    ON DELETE CASCADE,
  CONSTRAINT CC_LH_Reihenfolge CHECK (Reihenfolge > 0)
);

CREATE TABLE Kunde (
  KundenID INTEGER,
  Name     VARCHAR2(50) NOT NULL,
  Email    VARCHAR2(100) NOT NULL,
  Adresse  VARCHAR2(100),
  CONSTRAINT PK_Kunde PRIMARY KEY (KundenID),
  CONSTRAINT UQ_Kunde_Email UNIQUE (Email)
);

CREATE TABLE Ticket (
  TicketID   INTEGER,
  Kaufdatum  DATE NOT NULL,
  Preis      NUMERIC(8,2),
  GueltigVon DATE NOT NULL,
  GueltigBis DATE NOT NULL,
  KundenID   INTEGER NOT NULL,
  CONSTRAINT PK_Ticket PRIMARY KEY (TicketID),
  CONSTRAINT FK_Ticket_Kunde FOREIGN KEY (KundenID)
    REFERENCES Kunde(KundenID)    
  CONSTRAINT CC_Ticket_Preis CHECK (Preis > 0),
  CONSTRAINT CC_Ticket_Datum CHECK (GueltigBis >= GueltigVon)
);

CREATE TABLE Ticket_Linie (
  TicketID INTEGER,
  LinienNr INTEGER,
  CONSTRAINT PK_Ticket_Linie PRIMARY KEY (TicketID, LinienNr),
  CONSTRAINT FK_Ticket_Line_Ticket FOREIGN KEY (TicketID)
    REFERENCES Ticket(TicketID)
    ON DELETE CASCADE,
  CONSTRAINT FK_Ticket_Line_Linie FOREIGN KEY (LinienNr)
    REFERENCES Linie(LinienNr)
    ON DELETE CASCADE
);