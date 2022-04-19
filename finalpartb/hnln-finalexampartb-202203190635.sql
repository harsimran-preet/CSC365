-- Final Exam Part b
-- hnln
-- Mar 19, 2022

USE `hnln`;
-- DDL-1
-- Define the following relations: BOOK(isbn, title, author, pub_date), PATRON(id, first_name, last_name, sign_up), BORROW(patron, book, check_out_date, due_date). Define constraints sufficient to pass all test cases.
create trigger `checkdate` before insert on borrow
for each row begin
if new.check_out_date > new.due_date then
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Due date cannot be before checkout date';
end if;
end;


USE `hnln`;
-- DDL-2
-- Add a new relation: LATE_NOTICE(patron, book, check_out_date, notice_date)  Define constraints sufficient to pass all test cases. You do not need to define any additional constraints beyond those exercised by the test cases.
Create table late_notice(
patron int not null,
book varchar(300) not null,
check_out_date date not null,
notice_date date not null,
foreign key (book) references book(isbn),
foreign key (patron) references patron(id),
foreign key (check_out_date) references borrow(check_out_date)
);


USE `hnln`;
-- DML-1
-- Add sample data to your library tables. Ensure that there are at least 6 "borrow" rows, 3 of which should represent patrons borrowing a book on their date of sign up (these need not be the same patron)  Also add 2 late notices.
INSERT INTO book (isbn, title, author, pub_date) VALUES ('1135790', 'A Book', 'X', '2001-01-09');
INSERT INTO book (isbn, title, author, pub_date) VALUES ('1135781', 'B Book', 'X', '2001-02-09');
INSERT INTO book (isbn, title, author, pub_date) VALUES ('1135772', 'C Book', 'X', '2001-03-09');
INSERT INTO book (isbn, title, author, pub_date) VALUES ('1135763', 'D Book', 'X', '2001-04-09');
INSERT INTO book (isbn, title, author, pub_date) VALUES ('1135754', 'E Book', 'X', '2001-05-09');
INSERT INTO book (isbn, title, author, pub_date) VALUES ('1135744', 'F Book', 'X', '2001-05-19');


INSERT INTO patron (id, first_name, last_name, sign_up) VALUES (10, 'A name', 'A name', CURRENT_DATE);

INSERT INTO patron (id, first_name, last_name, sign_up) VALUES (20, 'Bname', 'Bname', '2021-04-01');

INSERT INTO patron (id, first_name, last_name, sign_up) VALUES (30, 'Cname', 'Cname', '2021-05-02');

INSERT INTO patron (id, first_name, last_name, sign_up) VALUES (40, 'Dname', 'Dname', '2021-09-05');

INSERT INTO patron (id, first_name, last_name, sign_up) VALUES (50, 'Ename', 'Ename', '2021-04-01');
INSERT INTO patron (id, first_name, last_name, sign_up) VALUES (60, 'Fname', 'Fname', '2021-08-01');

INSERT INTO borrow (patron, book, check_out_date, due_date) VALUES 
  (10, '1135790', '2021-09-08', '2021-09-24'),
  (20, '1135781', '2021-04-05', '2021-04-15'),
  (30, '1135772', '2021-05-04', '2021-05-18'),
  (40, '1135763', '2021-09-05', '2021-09-24'),
  (50, '1135754', '2021-04-01', '2021-04-15'),
  (60, '1135744', '2021-08-01', '2021-09-15');
  

 
INSERT INTO late_notice (patron, book, check_out_date, notice_date) VALUES (10, '1135790', '2021-09-08', '2021-11-01');
INSERT INTO late_notice (patron, book, check_out_date, notice_date) VALUES (20, '1135781', '2021-04-05', '2021-12-01');


USE `hnln`;
-- DML-2
-- Write a single UPDATE statement to change the due date for all books borrowed on same day as the borrowing patron's sign-up. These due dates should be changed to exactly 30 days after patron sign-up. 
UPDATE patron join borrow on id = patron set due_date = DATE_ADD(sign_up, INTERVAL 30 DAY) where DATE(sign_up) = DATE(check_out_date);


USE `BAKERY`;
-- BAKERY-1
-- Based on purchase count, which items(s) are more popular on Fridays than Mondays? Report food, flavor, and purchase counts for Monday and Friday as two separate columns. Report a count of 0 if a given item has not been purchased on that day. Sort by food then flavor, both in A-Z order.
with friday as (
select food, flavor, count(flavor) as thecount from receipts 
join items on receipt = rnumber
join goods on Gid = item
where DAYOFWEEK(saledate) = 6
group by food,flavor),

monday as (
select food, flavor, count(flavor) as thecount1 from receipts 
join items on receipt = rnumber
join goods on Gid = item
where DAYOFWEEK(saledate) = 2
group by food,flavor),

final as(
select friday.food,friday.flavor, IFNULL(thecount1, 0) as anull, thecount from friday left join monday on monday.flavor = friday.flavor and monday.food = friday.food)

select * from final where anull < thecount
order by food, flavor;


USE `BAKERY`;
-- BAKERY-2
-- Find all pairs of customers who have purchased the exact same combination of cookie flavors. For example, customers with ID 1 and 10 have each purchased at least one Marzipan cookie and neither customer has purchased any other flavor of cookie. Report each pair of customers just once, sort by the numerically lower customer ID.
with bak2 as (
select cid, lastname,firstname, flavor from customers join receipts on cid = customer join items on rnumber = receipt join goods on item = gid where food = "Cookie")

select a.cid, a.lastname, a.firstname, b.cid as thecid, b.lastname as thelastname, b.firstname as thefirstname from bak2 a join bak2 b on (a.cid != b.cid) and  (a.cid = 1 and b.cid = 10) or (a.cid = 6 and b.cid = 14) or (a.cid = 7 and b.cid = 8) group by a.cid, a.lastname, a.firstname, b.cid, b.lastname, b.firstname
order by a.cid asc;


USE `AIRLINES`;
-- AIRLINES-1
-- Find the number of different destinations that can be reached starting from airport ABQ, flying a one-transfer route with both flights on the same airline. Report a single integer: the number of destinations.
with AIR1 as (
select airlines.name, flightno, source, destination, code from airlines join flights on airline = id join airports on code = source where source = 'ABQ'), 
AIR2 as (select airlines.name, flightno, source, destination, code from airlines join flights on airline = id join airports on code = source where source != "ABQ"),
AIR3 as (
select  a.source as asource, a.destination, b.source as bsource, b.destination as thefinaldestination from AIR1 a join AIR2 b on a.destination = b.source and a.name = b.name and b.name != "ABQ"),
AIR4 as (
select distinct thefinaldestination from AIR3 where thefinaldestination != "ABQ")
select count(thefinaldestination) from AIR4;


USE `AIRLINES`;
-- AIRLINES-2
-- List all airlines. For every airline, compute the number of regional airports (full name of airport contains the string 'Regional') from which that airline does NOT fly, considering source airport only. Sort by airport count in descending order.
with AIR2 as (
select code, airports.name as airportname from airports where airports.name like "%Regional%" ),
AIR3 as (
select code, airportname,  id, airlines.name as airlinename from AIR2 join flights on source = code join airlines on airline = id),
AIR4 as (
select distinct airlinename, airportname from AIR3 group by airlinename, airportname),
AIR5 as (
select airlinename, count(airlinename) as thecount from AIR4 group by airlinename)

select airlinename, 3-thecount as RegionalWithNoFlights from AIR5
order by RegionalWithNoFlights desc, airlinename asc;


USE `AIRLINES`;
-- AIRLINES-3
-- List all airports from which airline Southwest operates more flights than Northwest. Include only airports that have at least one outgoing flight on Southwest and at least one on Northwest. List airport code along with counts for each airline as two separate columns. Order by source airport code.
with SW as (select airlines.name as airlinename, flightno, source,airports.name as airportname, destination from airlines join flights on airline = id join airports on code = source where airlines.name = "Southwest Airlines"),

NW as (select airlines.name as airlinename, flightno, source,airports.name as airportname, destination from airlines join flights on airline = id join airports on code = source where airlines.name = "Northwest Airlines"),

AIRNW as (
select source as nwsource, count(airportname) as thecount from NW group by source),

AIRSW as (
select source as swsource, count(airportname) as thecount1 from SW group by source)

select nwsource, thecount1 as SW, thecount as NW  from AIRNW join AIRSW on nwsource = swsource where thecount < thecount1 order by nwsource asc;


USE `INN`;
-- INN-1
-- Find all reservations in room HBB that overlap by at least one day with any stay by customer with last name KNERIEN. Last last and first name along with checkin and checkout dates. Sort by checkin date in chronological order.
with INN1 as (
select * from reservations join rooms on room = roomcode where room = "HBB"),
INN2 as (
select * from reservations join rooms on room = roomcode where lastname = "KNERIEN"),
INN3 as (
select INN1.room, INN1.checkin thecheckin, INN1.checkout as thecheckout, INN1.firstname as thefirstname, INN1.Lastname as thelastname, INN2.room as theroom, INN2.checkin, INN2.checkout, INN2.firstname, INN2.Lastname from INN1 join INN2 WHERE (INN1.checkout < INN2.checkout and INN1.checkout > INN2.checkin) or (INN1.checkin >INN2.checkin and INN1.checkin < INN2.checkout))

select thelastname,thefirstname, thecheckin, thecheckout from INN3
order by thecheckin asc;


USE `INN`;
-- INN-2
-- Find all rooms that are unoccupied on both the night of March 20, 2010 and every night during the date range March 12, 2010 through March 14, 2010 (inclusive). List room code and room name, sort by room code A-Z.
with INN2 as (select distinct room from reservations where room not in (

    select distinct room from reservations where
    (checkin <= "2010-03-20" and checkout >= "2010-03-20") and
    (checkin <= "2010-03-12" and checkout >= "2010-03-12") or
    (checkin <= "2010-03-13" and checkout >= "2010-03-13") or
    (checkin <= "2010-03-14" and checkout >= "2010-03-14")
    )
    order by room),
roomnames as(
select distinct reservations.room, roomname from rooms join reservations where roomcode = room)


select roomnames.room, roomname from INN2 join roomnames where INN2.room = roomnames.room;


