DROP TABLE IF EXISTS Tracklists;
DROP TABLE IF EXISTS Vocals;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Band;
DROP TABLE IF EXISTS Songs;
DROP TABLE IF EXISTS Albums;


CREATE TABLE IF NOT EXISTS Albums (
    `AId` INT PRIMARY KEY,
    `Title` VARCHAR(37) CHARACTER SET utf8,
    `Year` INT,
    `Label` VARCHAR(21) CHARACTER SET utf8,
    `Type` VARCHAR(6) CHARACTER SET utf8
);

CREATE TABLE IF NOT EXISTS Band (
    `Id` INT PRIMARY KEY,
    `Firstname` VARCHAR(10) CHARACTER SET utf8,
    `Lastname` VARCHAR(9) CHARACTER SET utf8
);
CREATE TABLE IF NOT EXISTS Songs (
    `SongId` INT PRIMARY KEY,
    `Title` VARCHAR(31) CHARACTER SET utf8,
    `Column_3` VARCHAR(6) CHARACTER SET utf8
);

CREATE TABLE IF NOT EXISTS Instruments (
    `SongId` INT,
    `BandmateId` INT,
    `Instrument` VARCHAR(14) CHARACTER SET utf8,
    PRIMARY KEY (SongId, BandmateId, Instrument),
    foreign key (SongId) references Songs(SongId),
    foreign key (BandmateId) references Band(Id)
);

CREATE TABLE IF NOT EXISTS Performance (
    `SongId` INT,
    `Bandmate` INT,
    `StagePosition` VARCHAR(6) CHARACTER SET utf8,
    PRIMARY KEY (SongId, Bandmate),
    foreign key (SongId) references Songs(SongId),
    foreign key (Bandmate) references Band(Id)
);



CREATE TABLE IF NOT EXISTS Tracklists (
    `AlbumId` INT,
    `Position` INT,
    `SongId` INT,
    foreign key (AlbumId) references Albums(AId),
    foreign key (SongId) references Songs(SongId)
);
CREATE TABLE IF NOT EXISTS Vocals (
    `SongId` INT,
    `Bandmate` INT,
    `Type` VARCHAR(6) CHARACTER SET utf8,
    foreign key (SongId) references Songs(SongId),
    foreign key (Bandmate) references Band(Id)
);

