-- Lab 5
-- hnln
-- Feb 19, 2022

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
select source, name from flights join airports on airports.code = flights.source
group by source having count(*) = 17;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
select count(distinct f1.source) from flights as f1
join flights as f2
where f2.destination = "ANP" and f1.source != "ANP"and f1.destination = f2.source;


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
select count(distinct f1.source) from flights as f1
join flights as f2
where f1.destination = "ATE" or (f2.destination = "ATE" and f1.source != "ATE"and f1.destination = f2.source);


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
select name, count(distinct source) as airports from airlines
join flights on flights.airline = airlines.id
group by airlines.name
order by airports desc, name;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
select flavor, round(avg(price),2) , count(*) from goods
group by flavor having count(*) >3
order by avg(price);


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
select sum(price) from items join goods on goods.GId = items.item
join receipts on receipts.Rnumber = items.receipt
where SaleDate>= "2007-10-01" and food = "Eclair" and SaleDate <= "2007-10-31";


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
select Rnumber, saledate, count(8), round(sum(price), 2) from customers
join receipts on receipts.customer = customers.CId
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.item
where FirstName = "NATACHA" and LastName = "STENZ"
group by receipts.RNumber, SaleDate
order by round(sum(price), 2) desc;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
select dayname(SaleDate), Saledate, count(distinct Receipt), count(*), round(sum(Price), 2) from receipts
join items on items.Receipt = receipts.RNumber
join goods on goods.GId = items.item
where SaleDate < '2007-10-15' and SaleDate > '2007-10-07'
group by dayname(SaleDate), SaleDate
order by SaleDate;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
select SaleDate from receipts
join items on items.receipt = receipts.rnumber
join goods on goods.GId = items.item
where food = "Tart"
group by SaleDate having count(*) >= 11;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
select campus, sum(fee) from campuses 
join fees on CampusId = campuses.id 
where fees.year<2006 and fees.year >1999
group by campus having avg(fee) >2500
order by sum(fee);


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
select campus, avg(enrolled), min(Enrolled), max(enrolled) from campuses
join enrollments on campusId = Id
group by campus having count(enrollments.year) >60
order by max(enrolled);


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

select campus, sum(degrees) from campuses
join degrees on CampusId = id
where (degrees.year >1997 and (county = "Orange" or county= "Los Angeles") and degrees.year <2003)
group by campus
order by sum(degrees) desc;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
select campus, count(*) from campuses
join enrollments on enrollments.campusId = Id
join discEnr on discEnr.campusId = Id
where discEnr.Gr >0 and enrollments.year = 2004 and enrollments.enrolled > 20000 group by campuses.campus
order by campus;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November of calendar year 2010. Sort output in descending order by total revenue. Output full room names.
select roomname, sum(datediff(checkout, checkin)*rate), round(avg(datediff(checkout, checkin)* rate), 2) from rooms
join reservations on room = roomcode
where checkin<"2010-12-01" and checkin > "2010-08-31" 
group by roomname
order by sum(datediff(checkout, checkin)*rate) desc;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
select count(*), sum(rate*datediff(checkout, checkin)) from rooms
join reservations on room = roomcode where dayname(checkin) = "Friday";


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
select dayname(checkin) as Day, count(*), sum(datediff(checkout, checkin)*rate) from rooms
join reservations on room = roomcode 
group by dayname(checkin)
order by Field(Day, "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
select roomname, max(rate - baseprice), min(rate - baseprice) from rooms
join reservations on room = roomcode
group by roomname
order by max(rate - baseprice) desc, roomname;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
--;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
select firstname, count(*) from Vocals
join Band on id = bandmate where vocaltype = 'lead'
group by bandmate order by count(*) desc;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
select firstname, count(distinct Instrument) from Instruments 
join Band on id = bandmate
join Tracklists on Tracklists.song = Instruments.song
join Albums on Aid = album and Title = "Le Pop"
group by Firstname order by firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

select StagePosition, count(*) from Performance 
join Band on Id = bandmate
where firstname = "Turid"
group by StagePosition order by count(*);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

select Firstname, Count(*) from 

(select distinct Performance.Song, Firstname, Instrument from Performance
join Instruments on Performance.Song = Instruments.Song
join Band on Instruments.Bandmate = Id where Firstname != "Anne-Marit" and Instrument = "bass balalaika") tocheck
join
(select Performance.Song from Performance join Band on Bandmate = id 
where firstname = "Anne-Marit" and stagePosition = 'left') tocheck1
on tocheck.Song = tocheck1.Song
group by Firstname
order by Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
select distinct Instrument from Instruments
group by Instrument having count(distinct Bandmate) >= 3
order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
select Firstname, Count(*) from Band 
join 
(select Bandmate from Instruments group by Bandmate, Song
having count(Instrument) >1) tocheck
on Band.Id = Bandmate group by Id order by Firstname;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
select AgeGroup, Sex, count(*), min(place), max(place) from marathon
group by AgeGroup, sex order by agegroup;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
select count(*) from 
(select agegroup,sex,state from marathon
where groupplace = 1 or groupplace = 2
group by agegroup, sex, state
having count(state) = 2) findout;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
select minute(pace), count(*) from marathon
group by minute(pace);


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
select distinct state, count(*) over(partition by state) from marathon where groupplace < 11
order by count(*) over(partition by state) desc;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
select Town, round(avg(time_to_sec(runtime)), 1) from marathon
where state = "CT" group by Town having count(*) >2
order by round(avg(time_to_sec(runtime)), 1);


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
select last , first from teachers
join list on list.classroom = teachers.classroom
group by teachers.last, teachers.first having count(*) >6 and count(*) < 9
order by last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

select grade, count(distinct classroom), count(*) from list
group by grade order by count(distinct classroom) desc, grade;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
select classroom, count(*) from list
where grade = 0 group by classroom
order by count(*) desc;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
select classroom, max(lastname) from list
where grade = 4
group by classroom;


