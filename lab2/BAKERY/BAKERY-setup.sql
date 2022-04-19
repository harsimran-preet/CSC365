DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS goods;
DROP TABLE IF EXISTS customers;


CREATE TABLE IF NOT EXISTS customers (
    `CId` INT PRIMARY KEY,
    `LastName` VARCHAR(11) ,
    `FirstName` VARCHAR(9)
);
CREATE TABLE IF NOT EXISTS goods (
    `GId` VARCHAR(13) PRIMARY KEY,
    `Flavor` VARCHAR(10),
    `Food` VARCHAR(9),
    `Price` NUMERIC(4, 2),
    UNIQUE(`Flavor`, `Food`)
);


CREATE TABLE IF NOT EXISTS receipts (
    `RNumber` VARCHAR(50),
    `Customer` INT,
    `SaleDate` DATETIME,
    foreign key(`Customer`) references customers(`CId`)
    
);
CREATE TABLE IF NOT EXISTS items (
    `Receipt` VARCHAR(50),
    `Ordinal` INT,
    `Item` VARCHAR(50),
    PRIMARY KEY (`Receipt`, `Ordinal`)
    );

