-- AIRLINES
INSERT INTO airlines VALUES
    (1,'United Airlines','UAL','USA'),
    (2,'US Airways','USAir','USA'),
    (3,'Delta Airlines','Delta','USA'),
    (4,'Southwest Airlines','Southwest','USA'),
    (5,'American Airlines','American','USA'),
    (6,'Northwest Airlines','Northwest','USA'),
    (7,'Continental Airlines','Continental','USA'),
    (8,'JetBlue Airways','JetBlue','USA'),
    (9,'Frontier Airlines','Frontier','USA'),
    (10,'AirTran Airways','AirTran','USA'),
    (11,'Allegiant Air','Allegiant','USA'),
    (12,'Virgin America','Virgin','USA');
    
-- AIRPORTS
INSERT INTO airports VALUES
    ('Aberdeen','APG','Phillips AAF','United States','US '),
    ('Aberdeen','ABR','Municipal','United States','US '),
    ('Abilene','DYS','Dyess AFB','United States','US '),
    ('Abilene','ABI','Municipal','United States','US '),
    ('Abingdon','VJI','Virginia Highlands','United States','US '),
    ('Ada','ADT','Ada','United States','US '),
    ('Adak Island','ADK','Adak Island Ns','United States','US '),
    ('Adrian','ADG','Lenawee County','United States','US '),
    ('Afton','AFO','Municipal','United States','US '),
    ('Aiken','AIK','Municipal','United States','US '),
    ('Ainsworth','ANW','Ainsworth','United States','US '),
    ('Akhiok','AKK','Akhiok SPB','United States','US '),
    ('Akiachak','KKI','Spb','United States','US '),
    ('Akiak','AKI','Akiak','United States','US '),
    ('Akron CO','AKO','Colorado Plains Regional Airport','United States','US '),
    ('Akron/Canton OH','CAK','Akron/canton Regional','United States','US '),
    ('Akron/Canton', 'AKC', 'Fulton International', 'United States', 'US');

-- FLIGHTS
-- select * from flights;
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 28, 'APG', 'ABR');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 29, 'AIK', 'ADT');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 44, 'AKO', 'AKI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 45, 'CAK', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (1, 54, 'AFO', 'AKO');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (3, 2, 'AIK', 'ADT');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (3, 3, 'DYS', 'ABI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (3, 26, 'AKK', 'VJI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1260, 'AKO', 'AKC');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1261, 'APG', 'ABR');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1286, 'ABR', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (9, 1287, 'DYS', 'ANW');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (10, 6, 'KKI', 'AKC');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (10, 7, 'VJI', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (10, 54, 'ADT', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 4, 'AIK', 'AKO');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 5, 'CAK', 'APG');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 28, 'AKO', 'ABI');
INSERT INTO flights (Airline, FlightNo, SourceAirport, DestAirport) VALUES (6, 29, 'ABR', 'ABI');
