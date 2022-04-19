DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS goods;
DROP TABLE IF EXISTS customers;


CREATE TABLE IF NOT EXISTS customers (
    `CId` INT PRIMARY KEY,
    `LastName` VARCHAR(50) ,
    `FirstName` VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS goods (
    `GId` VARCHAR(50) PRIMARY KEY,
    `Flavor` VARCHAR(50),
    `Food` VARCHAR(50),
    `Price` DECIMAL(7, 2),
    UNIQUE(`Flavor`, `Food`)
);


CREATE TABLE IF NOT EXISTS receipts (
    `RNumber` VARCHAR(50),
    `Customer` INT,
    `SaleDate` DATE
);
CREATE TABLE IF NOT EXISTS items (
    `Receipt` VARCHAR(50),
    `Ordinal` INT,
    `Item` VARCHAR(50),
    PRIMARY KEY (`Receipt`, `Ordinal`)
    );
