DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;
-- AIRLINES
CREATE TABLE IF NOT EXISTS airlines (
    `Id` INT PRIMARY KEY,
    `Airline` VARCHAR(20) CHARACTER SET utf8,
    `Abbreviation` VARCHAR(11) CHARACTER SET utf8,
    `Country` VARCHAR(3) CHARACTER SET utf8,
    UNIQUE(Abbreviation)
);
-- AIRPORTS
CREATE TABLE IF NOT EXISTS airports (
    `City` VARCHAR(15) CHARACTER SET utf8,
    `AirportCode` VARCHAR(3) CHARACTER SET utf8 PRIMARY KEY,
    `AirportName` VARCHAR(32) CHARACTER SET utf8,
    `Country` VARCHAR(13) CHARACTER SET utf8,
    `CountryAbbrev` VARCHAR(3) CHARACTER SET utf8,
    UNIQUE(AirportCode)
);
-- FLIGHTS
CREATE TABLE IF NOT EXISTS flights (
    `Airline` INT,
    `FlightNo` INT,
    `SourceAirport` VARCHAR(4) CHARACTER SET utf8 NOT NULL,
    `DestAirport` VARCHAR(4) CHARACTER SET utf8 NOT NULL,
    PRIMARY KEY(Airline, FlightNo),
    foreign key(Airline) references airlines(Id),
    foreign key(SourceAirport) references airports(AirportCode),
    foreign key(DestAirport) references airports(AirportCode)
);

