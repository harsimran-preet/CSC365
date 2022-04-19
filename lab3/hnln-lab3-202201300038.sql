-- Lab 3
-- hnln
-- Jan 30, 2022

USE `hnln`;
-- BAKERY-1
-- Using a single SQL statement, reduce the prices of Lemon Cake and Napoleon Cake by $2.
update goods set Price = Price - 2 where (Flavor = "Lemon" and Food = "Cake") or (Flavor = "Napoleon" and Food = "Cake");


USE `hnln`;
-- BAKERY-2
-- Using a single SQL statement, increase by 15% the price of all Apricot or Chocolate flavored items with a current price below $5.95.
update goods set Price = Price*1.15 where (Flavor = "Chocolate" or Flavor = "Apricot") and Price < 5.95;


USE `hnln`;
-- BAKERY-3
-- Add the capability for the database to record payment information for each receipt in a new table named payments (see assignment PDF for task details)
drop table if exists payments;

create table payments(
    Receipt int,
    Amount numeric (10,2),
    PaymentSettled DATETIME,
    PaymentType varchar(50),
    foreign key (Receipt) references receipts (RNumber),
    primary key (Receipt, Amount, PaymentSettled, PaymentType)
    

);

USE `hnln`;
-- BAKERY-4
-- Create a database trigger to prevent the sale of Meringues (any flavor) and all Almond-flavored items on Saturdays and Sundays.
create trigger weekends before insert on items

for each row
    begin
    declare item_food varchar(100);
    declare item_flavor varchar(100);
    declare the_date date;
    
    select Food into item_food from goods where GId = new.Item;
    select Flavor into item_flavor from goods where GId = new.Item;
    select SaleDate into the_date from receipts where RNumber = new.Receipt;
    if  (
            ((dayname(the_date) = "Saturday") or (dayname(the_date) = "Sunday")) and (item_food = "Meringue" or item_flavor = "Almond")
        ) then

        signal sqlstate '45000'
        set message_text = "No meringues until Monday";

    end if;
    end;


USE `hnln`;
-- AIRLINES-1
-- Enforce the constraint that flights should never have the same airport as both source and destination (see assignment PDF)
create trigger checking before insert on flights

for each row
    begin
    declare fsource varchar(100);
    declare fdest varchar(100);
    
    set fsource = new.SourceAirport;
    set fdest = new.DestAirport;
    if  (
            fsource = fdest
        ) then

        signal sqlstate '45000'
        set message_text = "Source and Dest cannot be same";

    end if;
    end;


USE `hnln`;
-- AIRLINES-2
-- Add a "Partner" column to the airlines table to indicate optional corporate partnerships between airline companies (see assignment PDF)
-- drop trigger the_partner;
-- drop trigger already_exists;
-- drop trigger already_partner;
-- drop trigger flight_update;

-- alter table airlines add Partner varchar(100);

create trigger the_partner before insert on airlines

for each row
    begin
    declare a_abbreviation varchar(100);
    declare partnership varchar(100);
    
    set a_abbreviation = new.Abbreviation;
    set partnership = new.Partner;
    
    if  (
            a_abbreviation = partnership
        ) then

        signal sqlstate '45000'
        set message_text = "no self-partnership allowed";

    end if;
    end;
    


create trigger already_exists before insert on airlines

for each row
    begin
    declare if_exists int;
    
    if  (
            new.Partner is not null
        ) then
        select COUNT(*) from airlines where Abbreviation = new.Partner into if_exists;
        if(if_exists = 0)then
            signal sqlstate '45000'
            set message_text = "Partner not found";
        end if;
    end if;
    end;
    
create trigger already_partner before insert on airlines
for each row
    begin
    declare apartner varchar(100);
    if (
        new.Partner is not null) 
    then
        select Partner into apartner from airlines where Abbreviation = new.Partner;
        if (apartner is not null) then
            signal sqlstate '45000'
            set message_text = "Sorry, couldn't add partner";
        end if;
    end if;
    end;
    
create trigger flight_update before update on airlines
for each row
    begin
    declare a_airline varchar(100);
    declare a_abbreviation varchar(100);
    declare a_country varchar(100);
    declare a_partner varchar(100);
    declare a_id int;
    if(
        new.Partner is not null) then
        select Partner into a_partner from airlines where Abbreviation = new.Partner;
        if(
            a_partner <>new.Abbreviation and a_partner is not null) then
            signal sqlstate '45000'
            set message_text = "Sorry, couldn't update";
        end if;
    end if;
    end;

    
update airlines
set Partner = "Southwest" where Abbreviation = "JetBlue";


update airlines
set Partner = "JetBlue" where Abbreviation = "Southwest";



update airlines
set Partner = "JetBlue" where Abbreviation = "Southwest";


USE `hnln`;
-- KATZENJAMMER-1
-- Change the name of two instruments: 'bass balalaika' should become 'awesome bass balalaika', and 'guitar' should become 'acoustic guitar'. This will require several steps. You may need to change the length of the instrument name field to avoid data truncation. Make this change using a schema modification command, rather than a full DROP/CREATE of the table.
update Instruments set Instrument = "awesome bass balalaika" where Instrument = "bass balalaika";

update Instruments set Instrument = "acoustic guitar" where Instrument = "guitar";


USE `hnln`;
-- KATZENJAMMER-2
-- Keep in the Vocals table only those rows where Solveig (id 1 -- you may use this numeric value directly) sang, but did not sing lead.
delete from Vocals where (`Type` = "lead" or `BandMate` != 1);


