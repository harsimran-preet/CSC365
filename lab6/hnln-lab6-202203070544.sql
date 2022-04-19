-- Lab 6
-- hnln
-- Mar 7, 2022

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select firstname, lastname from (
select distinct customer from receipts where customer not in (
select distinct customer from receipts 
where (saledate <= "2007-10-11") and (saledate>='2007-10-05') order by customer)) as thelist
join customers on customers.cid = thelist.customer
order by lastname;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
with BAK2 as (
    select customer, firstname, lastname, sum(goods.price) as thesum from receipts
    join items on receipt = rnumber
    join goods on gid = item
    join customers on cid = customer
    where (saledate <='2007-10-31' and saledate >= '2007-10-01')
    group by customer
    )
select firstname, lastname, round(thesum, 2) from BAK2 
where thesum = (select max(thesum) from BAK2);


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

with BAK3 as
(
    select * from receipts 
    join items on receipt = RNumber
    join goods on GId = Item
    join customers on CId = Customer
    where (SaleDate <= '2007-10-31') and (SaleDate>= '2007-10-01')
)


select distinct BAK3.FirstName,BAK3.LastName from BAK3
where BAK3.Customer not in (
    select distinct BAK3.Customer from BAK3
    where BAK3.Food = 'Twist'
    )
order by BAK3.Lastname;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
with BAK4 as (

    select Food, flavor, sum(Price) as thesum from receipts 
    join items on receipt = Rnumber
    join goods on GId = item
    group by food, flavor
    )
select flavor, Food from BAK4 where
thesum = (select max(thesum) from BAK4);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
with BAK5 as (
    select food, flavor, count(*) as thecount from receipts
    join items on items.receipt = rnumber
    join goods on Gid = item
    group by food, flavor
)
select flavor, food, thecount from BAK5 
where BAK5.thecount = (select max(thecount) from BAK5);


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
with BAK6 as (
    select saledate, sum(price) as thesum from receipts
    join items on receipt = rnumber 
    join goods on Gid = item
    where (saledate<='2007-10-31') and (saledate >= '2007-10-01') 
    group by saledate
)
select saledate from BAK6 
where thesum = (select max(thesum) from BAK6);


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
with BAK7a as (
    select saledate, sum(price) as thesum from receipts
    join items on receipt = rnumber 
    join goods on Gid = item
    where (saledate<='2007-10-31') and (saledate >= '2007-10-01') 
    group by saledate
),

BAK7b as (
    select Saledate, food, flavor, count(*) as thecount
    from receipts
    join items on receipt = rnumber
    join goods on Gid = item
    group by food, flavor, saledate
    ),
    
BAK7c as (
    select Food, flavor, thecount from BAK7b where
    saledate = (
        select Saledate from BAK7a 
        where thesum = (select max(thesum) from BAK7a))
)
select flavor, food, thecount from BAK7c
where thecount = (select max(thecount) from BAK7c);


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
with BAK8 as (
                select customer, firstname, lastname, flavor, food, count(*) as thecount from receipts
                join items on receipt = rnumber
                join goods on Gid = item
                join customers on Cid = customer
                where food = 'Cake' and saledate <= '2007-10-31' and saledate >= '2007-10-01'
                group by customer, flavor, food
                )
                
select flavor, food, firstname, lastname, thecount from BAK8 as a
where a.thecount = (select max(b.thecount) from BAK8 as b
                    where a.flavor = b.flavor)
order by a.thecount desc, lastname, flavor;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

with BAK9a as (
    select max(saledate) as themax, customer, firstname, lastname from receipts
    join items on receipt = rnumber
    join goods on gid = item
    join customers on cid = customer
    group by customer
    ),

BAK9b as (
    select min(saledate) as themin, customer from receipts
    join items on receipt = rnumber
    join goods on gid = item
    join customers on cid = customer
    group by customer
    )

select BAK9a.lastname, BAK9a.firstname, BAK9b.themin from receipts
join BAK9a on (themax = saledate) and (receipts.customer = BAK9a.customer)
join BAK9b on receipts.customer = BAK9b.customer
group by receipts.customer having count(rnumber)>1
order by themin, BAK9a.lastname;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

with BAK10a as (
    select sum(Price) as thesum from receipts
    join items on receipt = rnumber
    join goods on Gid = item
    where flavor = 'Chocolate'
    ),
BAK10b as (
    select sum(Price) as thesum1 from receipts
    join items on receipt = rnumber
    join goods on Gid = item
    where flavor = 'Croissant'
    )
select case when thesum > thesum1 then 'Croissant'
else 'Chocolate' end
from BAK10a join BAK10b;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

with INN1 as (

    select room, roomname, count(code) as thecodes from reservations
    join rooms on roomcode = room 
    group by room)
    
select roomname, room, thecodes from INN1
where thecodes = (select max(thecodes) from INN1);


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
with INN2a as(

    select room, roomname, DateDiff(checkout, checkin) as stay from reservations
    join rooms on roomcode = room
    group by room, checkin, checkout),
    
INN2b as(
    select room, roomname, sum(stay) as thesum from INN2a 
    group by Room)
select roomname, room, thesum from INN2b
where thesum = (select max(thesum) from INN2b);


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
with INN3a as (
    select code, checkin,checkout,lastname, rate, room, roomname, DateDiff(checkout, checkin) * rate as price from reservations
    join rooms on roomcode = room
    group by code ),

INN3b as (
    select code, roomname, room, max(cost) as maximumcost from INN3a 
    group by code)
    
select RoomName, checkin, checkout, lastname, rate, price from INN3a as i1 where
    price = (select max(i2.price) from INN3a as i2
    where i1.room = i2.room)
    order by i1.price desc;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
with INN4a as (

    select roomname, room, 
    Case when (checkout >'2010-07-04' and checkin < '2010-07-05') then 'Occupied'
    else 
        'Empty'
    end as checking1
    from reservations
    join rooms on roomcode = room
    ),
    
INN4b as (
    select Roomname, room , count(*) as thecount1 from INN4a
    group by Room),
    
INN4c as (
    select Roomname, room, count(*) as thecount2 from INN4a
    where checking1 != 'Occupied'
    group by room)
select INN4b.roomname, INN4b.room, Case
when INN4b.room = 'SAY' or thecount1 != thecount2 then 'Occupied'
else 'Empty'
end as checking2

from INN4c right join INN4b on INN4c.Room = INN4b.Room
order by INN4b.room;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
with INN5a as (
    select checkin, checkout, datediff(checkout, checkin) * rate as thediff
    from reservations),
INN5b as (
    select month(INN5a.Checkin) as themonth, sum(thediff) as thesum, count(*) as thecount
    from INN5a
    group by month(INN5a.checkin)
    )
select monthname(str_to_date(INN5b.themonth, "%m")) as Monthname, thecount, thesum from INN5b 
where thesum = (select max(thesum) from INN5b)
order by themonth;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

with STD1 as (
select last, first, count(*) as thecount from teachers 
join list on list.classroom = teachers.classroom
group by last, first)

select * from STD1 where
STD1.thecount = (select max(STD1.thecount) from STD1);


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
with STD2 as (
    select list.grade, count(*) as thecount from teachers
    join list on list.classroom = teachers.classroom
    where 
        list.lastname like "C%" or
        list.lastname like "B%" or
        list.lastname like "A%"
        group by list.grade
        )
        
select * from STD2 
where thecount = (select max(thecount) from STD2);


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
with STD3 as
(
    select teachers.classroom, count(*) as thecount from teachers
    join list on list.classroom = teachers.classroom 
    group by teachers.classroom
    )
select * from STD3 where thecount < (
    select avg(thecount) from STD3);


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
with STD4a as (
select teachers.classroom, count(*) as thecount from teachers
join list on list.classroom = teachers.classroom
group by teachers.classroom),

STD4b as (
    select a.classroom as x, b.classroom as y, a.thecount
    from STD4a as a join STD4a as b on b.classroom>a.classroom 
    and a.thecount = b.thecount 
    order by a.thecount)
    
select * from STD4b;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teaches the classroom with the largest number of students in the grade. Output results in ascending order by grade.
with STD5a as (

    select grade, count(distinct teachers.classroom) as thecount from teachers
    join list on list.classroom = teachers.classroom
    group by list.grade),
    
STD5b as (
    select list.grade, teachers.last, teachers.first, count(*) as thecount1 from teachers
    join list on list.classroom = teachers.classroom
    group by teachers.Last, first, list.grade),
STD5c as (
    select * from STD5b where STD5b.grade in (
        select grade from STD5a where thecount>1))
        
select a.grade, a.last as Name from STD5c as a where a.thecount1 = (
    select max(b.thecount1) from STD5c as b
    where b.grade = a.grade)
order by a.grade;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

select campuses.campus, enrolled from enrollments 
join campuses on campuses.Id = campusId
where enrollments.year = 2000 and enrolled = (
    select max(enrolled) from enrollments
    where year = 2000);


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

with CSU2 as (
    select campusid, campus, sum(degrees.degrees) as thesum from degrees
    join campuses on id = campusid group by campusId)
    
select campus from CSU2 where thesum = (
    select max(thesum) from CSU2);


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
with CSU3 as (
    select campus, (enrollments.FTE/faculty.FTE) as col from campuses
    join faculty on faculty.campusid = id
    join enrollments on (faculty.year = enrollments.year) and (enrollments.campusid = id) 
    where enrollments.year = 2003
    )

select CSU3.campus, round(col, 1) from CSU3
where col = (select min(col) from CSU3);


USE `CSU`;
-- CSU-4
-- Among undergraduates studying 'Computer and Info. Sciences' in the year 2004, find the university with the highest percentage of these students (base percentages on the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
with CSU4 as (
    select campus, (discEnr.ug/enrollments.enrolled) as col from campuses
    join discEnr on discEnr.campusid = campuses.id
    join enrollments on enrollments.campusid = campuses.id
    join disciplines on disciplines.id = discEnr.discipline
    where disciplines.name = "Computer and Info. Sciences" and discEnr.year = 2004 and enrollments.year = 2004)
    
select CSU4.campus, round(col *100, 1) from CSU4
where col = (select max(col) from CSU4);


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
with CSU5 as (
    select enrollments.year, campuses.campus, (degrees/enrollments.enrolled) as ratio from degrees
    join campuses on id = campusid
    join enrollments on (enrollments.year = degrees.year) and (enrollments.campusid = id)
    where (enrollments.year >=1997 and enrollments.year<=2003 ) and (degrees.year <=2003 and degrees.year >=1997)
    )

select * from CSU5 as a 
where a.ratio = (select max(b.ratio) from CSU5 b where a.year = b.year)
order by a.year;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
with CSU6 as (
    select campus, enrollments.year, max(enrollments.FTE/faculty.FTE) as col from campuses
    join faculty on campusid = id
    join enrollments on (faculty.year = enrollments.year) and (enrollments.campusid = id)
    group by enrollments.year, campus
    )
    
select a.campus, a.year, round(a.col, 2) from CSU6 as a
where a.col = (select max(b.col) from CSU6 as b where a.campus = b.campus)
order by a.campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

with CSU7 as (
    select campus, enrollments.year, max(enrollments.FTE / faculty.FTE) as themax from campuses
    join faculty on Campusid = id
    join enrollments on (faculty.year = enrollments.year) and campuses.id = enrollments.campusid
    group by enrollments.year, campuses.campus
    )

select (a.year +1) as x, count(*) from CSU7 as a 
where a.themax < (select max(b.themax) from CSU7 as b
where (b.year = a.year +1) and (a.campus = b.campus)
)
group by x
order by x;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

with M1 as (
    select state, count(*) as thecount from marathon
    group by state
    )
select state from M1 where thecount = (select max(thecount) from M1)
order by state;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

with M2a as(
    select town, count(*) as thecount from marathon
    where state = "RI" and sex = "F"
    group by town),
    
M2b as (
    select town, count(*) as thecount1 from marathon
    where state = "RI" and Sex= "M"
    group by town)
    
select M2a.town from M2a join 
M2b on M2b.town = M2a.town
where thecount > thecount1
order by M2a.town;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
with M3 as (
    select state, sex, agegroup, count(*) as thecount from marathon
    group by state, sex, agegroup
    )

select a.state, a.agegroup, a.sex, a.thecount from M3 as a
where a.thecount = (select max(b.thecount) from M3 as b
                    where a.state = b.state)
and a.thecount >=2
order by a.state, a.agegroup, a.sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
select a.place, a.firstname, a.lastname from marathon as a
where a.sex = "F" and (select count(*) from marathon as b
                        where a.place >b.place and sex = 'F') = 29
group by a.place;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

with M5a as (
    select town, count(*) as thecount from marathon 
    where State = 'CT' group by town
    ),
M5b as (
    select Town, count(*) as thecount1 from marathon
    where state = 'CT' and sex= 'F'
    group by town
    )

select M5a.town, case when M5b.thecount1 is NULL then M5a.thecount else M5a.thecount - M5b.thecount1 end as malecount, case when M5b.thecount1 is NULL then 0 else M5b.thecount1 end as femalecount
from M5a left join M5b on M5b.town = M5a.town
order by M5a.thecount desc, M5a.town;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

select firstname from Band 
where id not in (select distinct bandmate from Instruments
                    where Instrument = 'accordion');


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

select title from Songs where Songid not in 
    (select distinct song from Vocals)
order by Songs.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
with KAT3 as (
    select songid, title, count(Instruments.instrument) as thecount from Songs
    join Instruments on Song = songid
    group by song)

select title from KAT3
where KAT3.thecount = (select max(thecount) from KAT3);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

with KAT4 as (
    select firstname, id, instrument, count(*) as thecount from Band
    join Instruments on bandmate = id
    group by id, instrument
    )
select a.firstname, a.instrument, a.thecount from KAT4 as a
where a.thecount = (
                    select max(b.thecount) from KAT4 as b 
                    where a.id = b.id)
order by a.firstname, a.instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
with KAT5 as (
                select distinct Instruments.Instrument from Band
                join Instruments on bandmate = id
                where Band.firstname = 'Anne-Marit')
                
select * from KAT5 where Instrument not in 
                (select distinct Instruments.Instrument from Band
                join Instruments on bandmate = id
                where Band.firstname <> 'Anne-Marit')
order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

with KAT6 as (
select firstname, id, count(distinct Instruments.instrument) as thecount
from Band
join Instruments on bandmate = id
group by id)

select firstname from KAT6 
where KAT6.thecount = (select max(thecount) from KAT6)
order by firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
with KAT7 as (
select Instrument, count(distinct Song) as thecount from Instruments
join Songs on songid = song
group by instrument)

select Instrument from KAT7 
where thecount = (select max(KAT7.thecount) from KAT7);


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

with KAT8 as(
    select Bandmate, Band.firstname, count(*) as thecount from Performance
    join Band on id = Bandmate
    where Stageposition = 'center'
    group by bandmate)
    
select firstname from KAT8 where
thecount = (select max(thecount) from KAT8)
order by firstname;


